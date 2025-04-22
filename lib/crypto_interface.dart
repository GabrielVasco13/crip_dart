abstract class CryptoService {
  Future<String> encrypt(String text);
  Future<String> decrypt(String encryptedText);
}
