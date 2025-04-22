import 'dart:convert';
import 'dart:math';
import 'package:crip_dart/colors/xterm_colors.dart';
import 'package:pointycastle/export.dart';
import 'package:crip_dart/user_usr_generated.dart';
import 'package:crip_dart/aes/aes_key.dart';
import 'package:crip_dart/aes/aes_encryptor.dart';
import 'package:crip_dart/rsa/rsa_keys.dart';
import 'package:crip_dart/rsa/rsa_service.dart';

String randomString(int length) {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final rand = Random.secure();
  return List.generate(length, (_) => chars[rand.nextInt(chars.length)]).join();
}

Map<String, dynamic> generateRandomUserMap(int id) {
  return {
    'id': id,
    'name': randomString(10),
    'email': '${randomString(5)}@${randomString(5)}.com'
  };
}

UserObjectBuilder generateRandomUserObj(int id) {
  return UserObjectBuilder(
    id: id,
    name: randomString(10),
    email: '${randomString(5)}@${randomString(5)}.com',
  );
}

void main() async {
  const int n = 1000; // quantidade de usuários para o teste
  final usersJson = List.generate(n, (i) => generateRandomUserMap(i));
  final usersFlat = List.generate(n, (i) => generateRandomUserObj(i));

  // AES setup
  final aesKey = AESKeyLoader.getKey();
  final aesIv = AESKeyLoader.getIV();
  final aes = AESEncryptor(aesKey, aesIv);

  // RSA setup
  final keyPair = RSAKeyManager.generateKeyPair();
  final publicKey = keyPair.publicKey as RSAPublicKey;
  final privateKey = keyPair.privateKey as RSAPrivateKey;
  final rsa = RSAService(publicKey: publicKey, privateKey: privateKey);

  // --- JSON SERIALIZATION ---
  final jsonStart = DateTime.now().microsecondsSinceEpoch;
  final jsonString = jsonEncode(usersJson);
  final jsonSerTime = DateTime.now().microsecondsSinceEpoch - jsonStart;

  // --- JSON DESERIALIZATION ---
  final jsonDesStart = DateTime.now().microsecondsSinceEpoch;
  jsonDecode(jsonString);
  final jsonDeserTime = DateTime.now().microsecondsSinceEpoch - jsonDesStart;

  // --- FLATBUFFERS SERIALIZATION ---
  final flatStart = DateTime.now().microsecondsSinceEpoch;
  final flatBuffers = usersFlat.map((u) => u.toBytes()).toList();
  final flatSerTime = DateTime.now().microsecondsSinceEpoch - flatStart;

  // --- FLATBUFFERS DESERIALIZATION ---
  final flatDesStart = DateTime.now().microsecondsSinceEpoch;
  flatBuffers.map((b) => User(b)).toList();
  final flatDeserTime = DateTime.now().microsecondsSinceEpoch - flatDesStart;

  // --- AES ENCRYPT ---
  final aesEncStart = DateTime.now().microsecondsSinceEpoch;
  final aesEncrypted = aes.encryptText(jsonString);
  final aesEncTime = DateTime.now().microsecondsSinceEpoch - aesEncStart;

  // --- AES DECRYPT ---
  final aesDecStart = DateTime.now().microsecondsSinceEpoch;
  aes.decryptText(aesEncrypted);
  final aesDecTime = DateTime.now().microsecondsSinceEpoch - aesDecStart;

  // --- RSA ENCRYPT ---
  final rsaEncStart = DateTime.now().microsecondsSinceEpoch;
  final rsaEncrypted = rsa.encrypt(jsonString);
  final rsaEncTime = DateTime.now().microsecondsSinceEpoch - rsaEncStart;

  // --- RSA DECRYPT ---
  final rsaDecStart = DateTime.now().microsecondsSinceEpoch;
  rsa.decrypt(rsaEncrypted);
  final rsaDecTime = DateTime.now().microsecondsSinceEpoch - rsaDecStart;

  print('${XTermColor.orangeRed}--- JSON ---');
  print('${XTermColor.green}Serialização: ${jsonSerTime / 1000} ms');
  print('${XTermColor.green}Deserialização: ${jsonDeserTime / 1000} ms');
  print('${XTermColor.magenta}--- FlatBuffers ---');
  print('${XTermColor.blueBright}Serialização: ${flatSerTime / 1000} ms');
  print('${XTermColor.blueBright}Deserialização: ${flatDeserTime / 1000} ms');
  print('${XTermColor.orangeRed}--- AES ---');
  print('${XTermColor.green}Encrypt: ${aesEncTime / 1000} ms');
  print('${XTermColor.green}Decrypt: ${aesDecTime / 1000} ms');
  print('${XTermColor.orangeRed}--- RSA ---');
  print('${XTermColor.green}Encrypt: ${rsaEncTime / 1000} ms');
  print('${XTermColor.green}Decrypt: ${rsaDecTime / 1000} ms');
}
