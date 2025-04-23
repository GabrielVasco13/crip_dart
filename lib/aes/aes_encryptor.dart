import 'package:encrypt/encrypt.dart';

class AESEncryptor {
  final Key key;
  final IV iv;

  AESEncryptor(this.key, this.iv);

  String encryptText(String plainText) {
    final encrypter = Encrypter(AES(key));
    return encrypter.encrypt(plainText, iv: iv).base64;
  }

  String decryptText(String encryptedText) {
    final encrypter = Encrypter(AES(key));
    return encrypter.decrypt(Encrypted.from64(encryptedText), iv: iv);
  }
}
