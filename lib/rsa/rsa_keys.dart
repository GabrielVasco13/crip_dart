import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

class RSAKeyManager {
  static AsymmetricKeyPair<PublicKey, PrivateKey> generateKeyPair(
      {int bitLength = 2048}) {
    final keyGen = RSAKeyGenerator()
      ..init(ParametersWithRandom(
        RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64),
        _secureRandom(),
      ));
    return keyGen.generateKeyPair();
  }

  static SecureRandom _secureRandom() {
    final secureRandom = FortunaRandom();
    final seed = Uint8List(32);
    final random = Random.secure();
    for (int i = 0; i < seed.length; i++) {
      seed[i] = random.nextInt(256);
    }
    secureRandom.seed(KeyParameter(seed));
    return secureRandom;
  }
}
