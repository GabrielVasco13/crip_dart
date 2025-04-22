import 'package:fast_rsa/fast_rsa.dart';

class RSAKeyManager {
  static Future<(String privateKey, String publicKey)> generateKeys() async {
    final pair = await RSA.generate(2048);
    return (pair.privateKey, pair.publicKey);
  }
}
