import 'dart:io';
import 'package:crip_dart/encript.dart';
import 'package:crip_dart/descript.dart';
import 'package:crip_dart/helper/encrypted_result.dart';
import 'package:crip_dart/helper/key_size.dart';

void main() {
  // Chave definida com 16 bytes
  final mySecretKey = KeySize.bits256.keyString;

  final encript = Cript(mySecretKey);
  final descript = Descript(mySecretKey);

  print("Digite o texto para criptografar:");
  String? input = stdin.readLineSync();

  if (input != null && input.isNotEmpty) {
    final plainText = input;

    // 1. Encriptando utilizando a instancia do Encript
    // Passa o texto plano para criptografar
    // O IV é gerado automaticamente na classe Cript
    // e não precisa ser passado como argumento
    // O resultado é uma instância de EncryptedResult
    // que contém os dados criptografados e o IV

    final EncryptedResult encryptionResult = encript.encryptText(plainText);

    print(
        'Texto Criptografado (Base64): ${encryptionResult.encryptedData.base64}');

    // Também pode imprimir o IV se necessário: print('IV (Base64): ${encryptionResult.iv.base64}');

    // 2. Descriptografando utilizando a instancia do Descript
    // Passa os dados criptografados e o IV para descriptografar
    final decryptedText = descript.decryptData(encryptionResult.encryptedData,
        encryptionResult.iv // Usar o IV gerado na criptografia
        );

    print('Texto Descriptografado: $decryptedText');
  } else {
    print("Nenhuma entrada fornecida.");
  }
}
