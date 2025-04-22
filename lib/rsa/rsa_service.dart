import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

class RSAService {
  final RSAPublicKey publicKey;
  final RSAPrivateKey privateKey;

  RSAService({
    required this.publicKey,
    required this.privateKey,
  });

  String encrypt(String text) {
    final encryptor = OAEPEncoding(RSAEngine())
      ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));
    final input = Uint8List.fromList(utf8.encode(text));
    final output = _processInBlocks(encryptor, input);
    return base64Encode(output);
  }

  String decrypt(String base64Encrypted) {
    final decryptor = OAEPEncoding(RSAEngine())
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey));
    final input = base64Decode(base64Encrypted);
    final output = _processInBlocks(decryptor, input);
    return utf8.decode(output);
  }

  Uint8List _processInBlocks(AsymmetricBlockCipher engine, Uint8List input) {
    final numBlocks = (input.length / engine.inputBlockSize).ceil();
    final output = <int>[];
    for (var i = 0; i < numBlocks; i++) {
      final start = i * engine.inputBlockSize;
      final end = start + engine.inputBlockSize;
      final chunk =
          input.sublist(start, end > input.length ? input.length : end);
      output.addAll(engine.process(chunk));
    }
    return Uint8List.fromList(output);
  }
}
