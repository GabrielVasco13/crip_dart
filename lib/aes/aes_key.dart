import 'package:encrypt/encrypt.dart';

class AESKeyLoader {
  static Key getKey() {
    return Key.fromUtf8(
        'my32lengthsupersecretnooneknows!'); // 32 bytes = AES-256
  }

  static IV getIV() {
    return IV.fromLength(16); // Padrão de 16 bytes
  }
}
