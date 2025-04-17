import 'package:encrypt/encrypt.dart';

class EncryptedResult {
  final Encrypted encryptedData;
  final IV iv;

  EncryptedResult(this.encryptedData, this.iv);
}
