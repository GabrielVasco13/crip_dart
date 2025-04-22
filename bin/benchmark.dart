import 'dart:convert';

import 'package:crip_dart/aes/aes_key.dart';
import 'package:crip_dart/aes/aes_encryptor.dart';
import 'package:crip_dart/user_usr_generated.dart';

void main() {
  const int numIterations = 1000;
  final userMap = {'name': 'Gabriel', 'id': 30, 'email': 'jorge@gmail.com'};
  final userJson = jsonEncode(userMap);

  final userFB =
      UserObjectBuilder(name: 'Gabriel', id: 30, email: "jorge@gmail.com");
  final userFBBytes = userFB.toBytes();

  final keySizes = {
    16: AESKeyLoader.getKey(),
    24: AESKeyLoader.getKey(),
    32: AESKeyLoader.getKey(),
  };

  print('Json');
  for (final entry in keySizes.entries) {
    final key = entry.value;
    final iv = AESKeyLoader.getIV();
    final aes = AESEncryptor(key, iv);

    double totalEncryptTime = 0;
    double totalDecryptTime = 0;
    String? encrypted;
    String decrypted = '';

    for (int i = 0; i < numIterations; i++) {
      final swEncrypt = Stopwatch()..start();
      encrypted = aes.encryptText(userJson);
      swEncrypt.stop();
      totalEncryptTime += swEncrypt.elapsedMicroseconds / 1000;

      final swDecrypt = Stopwatch()..start();
      decrypted = aes.decryptText(encrypted);
      swDecrypt.stop();
      totalDecryptTime += swDecrypt.elapsedMicroseconds / 1000;
    }

    final total = totalEncryptTime + totalDecryptTime;
    print('${entry.key} bytes');
    print(
        'Encriptação: ${(totalEncryptTime / numIterations).toStringAsFixed(4)} ms | '
        'Decriptação: ${(totalDecryptTime / numIterations).toStringAsFixed(4)} ms | '
        'Tempo total: ${(total / numIterations).toStringAsFixed(4)} ms\n');
  }

  print('Flatbuffers');
  for (final entry in keySizes.entries) {
    final key = entry.value;
    final iv = AESKeyLoader.getIV();
    final aes = AESEncryptor(key, iv);

    double totalEncryptTime = 0;
    double totalDecryptTime = 0;
    String? encrypted;
    String decrypted = '';

    for (int i = 0; i < numIterations; i++) {
      final swEncrypt = Stopwatch()..start();
      encrypted = aes.encryptText(String.fromCharCodes(userFBBytes));
      swEncrypt.stop();
      totalEncryptTime += swEncrypt.elapsedMicroseconds / 1000;

      final swDecrypt = Stopwatch()..start();
      decrypted = aes.decryptText(encrypted);
      swDecrypt.stop();
      totalDecryptTime += swDecrypt.elapsedMicroseconds / 1000;
    }

    final total = totalEncryptTime + totalDecryptTime;
    print('${entry.key} bytes');
    print(
        'Encriptação: ${(totalEncryptTime / numIterations).toStringAsFixed(4)} ms | '
        'Decriptação: ${(totalDecryptTime / numIterations).toStringAsFixed(4)} ms | '
        'Tempo total: ${(total / numIterations).toStringAsFixed(4)} ms\n');
  }
}
