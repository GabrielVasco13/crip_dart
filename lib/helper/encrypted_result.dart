import 'package:encrypt/encrypt.dart';

// A classe EncryptedResult é utilizada para armazenar o resultado da criptografia
// e o vetor de inicialização (IV) utilizado na criptografia.
// Ela contém dois campos: encryptedData e iv, ambos do tipo Encrypted e IV, respectivamente.
class EncryptedResult {
  final Encrypted encryptedData;
  final IV iv;

  EncryptedResult(this.encryptedData, this.iv);
}
