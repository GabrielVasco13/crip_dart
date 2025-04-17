import 'package:encrypt/encrypt.dart';

class Descript {
  // ignore: unused_field
  final Key _key;
  final Encrypter _encrypter;

  // O construtor recebe uma chave de 32 bytes
  Descript(String keyString)
      : _key = Key.fromUtf8(keyString),
        _encrypter = Encrypter(AES(Key.fromUtf8(keyString)));

  // O metodo de descriptografia recebe os dados criptografados e o IV
  // O IV deve ser o mesmo utilizado na criptografia
  String decryptData(Encrypted encryptedData, IV iv) {
    final decrypted = _encrypter.decrypt(encryptedData, iv: iv);
    return decrypted;
  }

  // Opcional: Método para descriptografar dados a partir de uma string Base64
  // Nota: Você DEVE fornecer o IV correto que foi usado para a criptografia.

  String decryptFromBase64(String encryptedBase64, IV iv) {
    final encryptedData = Encrypted.fromBase64(encryptedBase64);
    return decryptData(encryptedData, iv);
  }
}
