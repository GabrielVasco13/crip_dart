import 'package:crip_dart/rsa/rsa_keys.dart';
import 'package:crip_dart/rsa/rsa_service.dart';
import 'package:pointycastle/export.dart';

void main() async {
  // AES
  final keyPair = RSAKeyManager.generateKeyPair();
  final publicKey = keyPair.publicKey as RSAPublicKey;
  final privateKey = keyPair.privateKey as RSAPrivateKey;

  // Instanciar serviço
  final rsa = RSAService(publicKey: publicKey, privateKey: privateKey);

  // Criptografar e descriptografar
  final encrypted = rsa.encrypt('Texto com RSA PointyCastle!');
  final decrypted = rsa.decrypt(encrypted);

  print('RSA Encrypt: $encrypted');
  print('RSA Decrypt: $decrypted');
}
