import 'package:crip_dart/aes/aes_encryptor.dart';
import 'package:crip_dart/aes/aes_key.dart';
import 'package:crip_dart/rsa/rsa_keys.dart';
import 'package:crip_dart/rsa/rsa_service.dart';

void main() async {
  // AES
  final aes = AESEncryptor(AESKeyLoader.getKey(), AESKeyLoader.getIV());
  final encryptedAES = aes.encryptText('Texto com AES!');
  final decryptedAES = aes.decryptText(encryptedAES);
  print('AES Encrypt: $encryptedAES');
  print('AES Decrypt: $decryptedAES');

  // RSA
  final keys = await RSAKeyManager.generateKeys();
  final rsa = RSAService(publicKey: keys.$2, privateKey: keys.$1);
  final encryptedRSA = await rsa.encrypt('Texto com RSA!');
  final decryptedRSA = await rsa.decrypt(encryptedRSA);
  print('RSA Encrypt: $encryptedRSA');
  print('RSA Decrypt: $decryptedRSA');
}
