import 'package:fast_rsa/fast_rsa.dart';

class RSAService {
  final String publicKey;
  final String privateKey;

  RSAService({required this.publicKey, required this.privateKey});

  Future<String> encrypt(String text) async {
    return await RSA.encryptPKCS1v15(text, publicKey);
  }

  Future<String> decrypt(String base64Encrypted) async {
    return await RSA.decryptPKCS1v15(base64Encrypted, privateKey);
  }
}
