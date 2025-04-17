import 'package:crip_dart/helper/encrypted_result.dart';
import 'package:encrypt/encrypt.dart';

class Cript {
  final Key _key;
  final IV _iv; // Store IV pode ser utilizado dps
  final Encrypter _encrypter;

  Cript(String keyString)
      : _key = Key.fromUtf8(keyString),
        _iv = IV.fromLength(16),
        _encrypter = Encrypter(AES(Key.fromUtf8(keyString)));

  EncryptedResult encryptText(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return EncryptedResult(encrypted, _iv);
  }
}
