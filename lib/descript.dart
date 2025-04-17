import 'package:encrypt/encrypt.dart';

class Descript {
  final Key _key;
  final Encrypter _encrypter;

  // Constructor requires the secret key string
  Descript(String keyString)
      : _key = Key.fromUtf8(keyString),
        _encrypter = Encrypter(AES(Key.fromUtf8(keyString)));

  // Method to decrypt text using provided encrypted data and IV
  String decryptData(Encrypted encryptedData, IV iv) {
    final decrypted = _encrypter.decrypt(encryptedData, iv: iv);
    return decrypted;
  }

  // Optional: Helper to decrypt from Base64 string if you know the IV separately
  // Note: You MUST provide the correct IV that was used for encryption.
  String decryptFromBase64(String encryptedBase64, IV iv) {
    final encryptedData = Encrypted.fromBase64(encryptedBase64);
    return decryptData(encryptedData, iv);
  }
}
