import 'package:crip_dart/helper/encrypted_result.dart';
import 'package:encrypt/encrypt.dart';

class Cript {
  // ignore: unused_field
  final Key _key;
  final IV _iv; // Store IV pode ser utilizado dps
  final Encrypter _encrypter;

  // O construtor recebe uma chave de 32 bytes
  // O IV é gerado automaticamente
  Cript(String keyString)
      : _key = Key.fromUtf8(keyString),
        _iv = IV.fromLength(16),
        _encrypter = Encrypter(AES(Key.fromUtf8(keyString)));

  // O metodo de criptografia recebe o texto plano
  // O IV é gerado automaticamente na classe Cript
  // e não precisa ser passado como argumento
  EncryptedResult encryptText(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return EncryptedResult(encrypted, _iv);
  }
}
