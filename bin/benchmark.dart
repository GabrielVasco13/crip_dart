import 'dart:convert';
import 'dart:math';
import 'package:crip_dart/colors/xterm_colors.dart';
import 'package:encrypt/encrypt.dart';
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
  const int n = 100000; // quantidade de usuários para o teste
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
  final decodedJson = jsonDecode(jsonString);
  final jsonDeserTime = DateTime.now().microsecondsSinceEpoch - jsonDesStart;

  // --- FLATBUFFERS SERIALIZATION ---
  final flatStart = DateTime.now().microsecondsSinceEpoch;
  final flatBuffers = usersFlat.map((u) => u.toBytes()).toList();
  final flatSerTime = DateTime.now().microsecondsSinceEpoch - flatStart;

  // --- FLATBUFFERS DESERIALIZATION ---
  final flatDesStart = DateTime.now().microsecondsSinceEpoch;
  final flatObjs = flatBuffers.map((b) => User(b)).toList();
  final flatDeserTime = DateTime.now().microsecondsSinceEpoch - flatDesStart;

  // --- AES ENCRYPT ---
  final aesEncStart = DateTime.now().microsecondsSinceEpoch;
  final aesEncrypted = aes.encryptText(jsonString);
  final aesEncTime = DateTime.now().microsecondsSinceEpoch - aesEncStart;

  // --- RSA ENCRYPT (da chave AES) ---
  final rsaEncStart = DateTime.now().microsecondsSinceEpoch;
  final aesKeyBase64 = base64Encode(aesKey.bytes);
  final aesIvBase64 = base64Encode(aesIv.bytes);
  final rsaEncryptedKey = rsa.encrypt(aesKeyBase64);
  final rsaEncryptedIv = rsa.encrypt(aesIvBase64);
  final rsaEncTime = DateTime.now().microsecondsSinceEpoch - rsaEncStart;

  // --- RSA DECRYPT (da chave AES) ---
  final rsaDecStart = DateTime.now().microsecondsSinceEpoch;
  final decryptedKeyBase64 = rsa.decrypt(rsaEncryptedKey);
  final decryptedIvBase64 = rsa.decrypt(rsaEncryptedIv);
  final decryptedKey = Key.fromBase64(decryptedKeyBase64);
  final decryptedIv = IV.fromBase64(decryptedIvBase64);
  final rsaDecTime = DateTime.now().microsecondsSinceEpoch - rsaDecStart;

  // --- AES DECRYPT (usando chave/IV recuperados via RSA) ---
  final aesDecStart = DateTime.now().microsecondsSinceEpoch;
  final aesRecovered = AESEncryptor(decryptedKey, decryptedIv);
  final aesDecrypted = aesRecovered.decryptText(aesEncrypted);
  final aesDecTime = DateTime.now().microsecondsSinceEpoch - aesDecStart;

  // Exibir exemplos dos dados
  print(
      '\n${XTermColor.orangeRed}===== SERIALIZAÇÃO/DESSERIALIZAÇÃO =====${XTermColor.reset}');
  print(
      '${XTermColor.yellow}JSON serializado: ${jsonString.substring(0, 100)}...${XTermColor.reset}');
  print(
      '${XTermColor.yellow}JSON desserializado: ${decodedJson.toString().substring(0, 100)}...${XTermColor.reset}');
  print(
      '${XTermColor.magenta}FlatBuffer serializado (bytes): ${flatBuffers[0].take(20).toList()}...${XTermColor.reset}');
  print(
      '${XTermColor.magenta}FlatBuffer desserializado: id=${flatObjs[0].id}, name=${flatObjs[0].name}, email=${flatObjs[0].email}${XTermColor.reset}');

  print('\n${XTermColor.orangeRed}===== DESEMPENHO =====${XTermColor.reset}');
  print(
      '${XTermColor.yellow}JSON - Serialização: ${jsonSerTime / 1000} ms | Desserialização: ${jsonDeserTime / 1000} ms${XTermColor.reset}');
  print(
      '${XTermColor.magenta}FlatBuffers - Serialização: ${flatSerTime / 1000} ms | Desserialização: ${flatDeserTime / 1000} ms${XTermColor.reset}');

  print('\n${XTermColor.orangeRed}===== AES =====${XTermColor.reset}');
  print(
      '${XTermColor.cyan}AES Encrypted (base64): ${aesEncrypted.substring(0, 100)}...${XTermColor.reset}');
  print(
      '${XTermColor.cyan}AES Decrypted (JSON): ${aesDecrypted.substring(0, 100)}...${XTermColor.reset}');
  print(
      '${XTermColor.green}Encrypt: ${aesEncTime / 1000} ms | Decrypt: ${aesDecTime / 1000} ms${XTermColor.reset}');

  print('\n${XTermColor.orangeRed}===== RSA =====${XTermColor.reset}');
  print(
      '${XTermColor.cyan}RSA Encrypted AES Key: ${rsaEncryptedKey.substring(0, 100)}...${XTermColor.reset}');
  print(
      '${XTermColor.cyan}RSA Encrypted AES IV: ${rsaEncryptedIv.substring(0, 100)}...${XTermColor.reset}');
  print(
      '${XTermColor.green}Encrypt Key+IV: ${rsaEncTime / 1000} ms | Decrypt Key+IV: ${rsaDecTime / 1000} ms${XTermColor.reset}');

  print(
      '\n${XTermColor.orangeRed}===== AES + RSA (HÍBRIDO) =====${XTermColor.reset}');
  print(
      '${XTermColor.cyan}AES Encrypted (base64): ${aesEncrypted.substring(0, 100)}...${XTermColor.reset}');
  print(
      '${XTermColor.cyan}AES Decrypted (JSON via chave/IV RSA): ${aesDecrypted.substring(0, 100)}...${XTermColor.reset}');
  print(
      '${XTermColor.green}AES Encrypt: ${aesEncTime / 1000} ms | RSA Encrypt Key+IV: ${rsaEncTime / 1000} ms | RSA Decrypt Key+IV: ${rsaDecTime / 1000} ms | AES Decrypt: ${aesDecTime / 1000} ms${XTermColor.reset}');

  print('');
  print(
    '${XTermColor.orangeRed}--- JSON ---${XTermColor.reset}',
  );
  print(
    '${XTermColor.green}Serialização: ${jsonSerTime / 1000} ms${XTermColor.reset}',
  );
  print(
    '${XTermColor.green}Deserialização: ${jsonDeserTime / 1000} ms${XTermColor.reset}',
  );
  print(
    '${XTermColor.magenta}--- FlatBuffers ---${XTermColor.reset}',
  );
  print(
    '${XTermColor.blueBright}Serialização: ${flatSerTime / 1000} ms${XTermColor.reset}',
  );
  print(
    '${XTermColor.blueBright}Deserialização: ${flatDeserTime / 1000} ms${XTermColor.reset}',
  );
  print(
    '${XTermColor.orangeRed}--- AES ---${XTermColor.reset}',
  );
  print(
    '${XTermColor.green}Encrypt: ${aesEncTime / 1000} ms${XTermColor.reset}',
  );
  print(
    '${XTermColor.green}Decrypt: ${aesDecTime / 1000} ms${XTermColor.reset}',
  );
  print(
    '${XTermColor.orangeRed}--- RSA ---${XTermColor.reset}',
  );
  print(
    '${XTermColor.green}Encrypt: ${rsaEncTime / 1000} ms${XTermColor.reset}',
  );
  print(
    '${XTermColor.green}Decrypt: ${rsaDecTime / 1000} ms${XTermColor.reset}',
  );
}
