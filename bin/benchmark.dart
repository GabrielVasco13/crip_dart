import 'dart:math';
import 'package:crip_dart/benchmark/benchmark_result.dart';
import 'package:crip_dart/colors/xterm_colors.dart';
import 'package:crip_dart/helper/key_size.dart';

void main() {
  const int numIterations = 5000;
  const int textLength = 10000;

  // Gerar texto aleatório para usar nos testes (para consistência)
  final String testText = _generateRandomString(textLength);

  // Lista para armazenar resultados
  final List<BenchmarkResult> results = [];

  print(
      '${XTermColor.green}Inicializando benchmark de criptografia AES com $numIterations iterações');
  print('${XTermColor.green}Tamanho do texto: $textLength caracteres');
  print(
      '${XTermColor.green}--------------------------------------------------------------');

  // Teste para cada tamanho de chave
  for (final keySize in KeySize.values) {
    final String description;
    switch (keySize) {
      case KeySize.bits128:
        description = '128 bits (16 bytes)';
        break;
      case KeySize.bits192:
        description = '192 bits (24 bytes)';
        break;
      case KeySize.bits256:
        description = '256 bits (32 bytes)';
        break;
    }

    print('Testando chave de $description...');

    // Obter a chave
    final mySecretKey = keySize.keyString;

    // Criar instâncias de criptografia e descriptografia
    final encript = Cript(mySecretKey);
    final descript = Descript(mySecretKey);

    // Medir o tempo total diretamente, sem dividir por iteração ainda
    // Isso evita perder precisão com operações muito rápidas

    // Criptografia
    final encryptStart =
        DateTime.now().microsecondsSinceEpoch; // Usar microssegundos
    for (int i = 0; i < numIterations; i++) {
      final encryptionResult = encript.encryptText(testText);
      if (i == numIterations - 1) {
        // Usar o último resultado para descriptografia
        final decryptStart = DateTime.now().microsecondsSinceEpoch;
        for (int j = 0; j < numIterations; j++) {
          descript.decryptData(
              encryptionResult.encryptedData, encryptionResult.iv);
        }
        final decryptEnd = DateTime.now().microsecondsSinceEpoch;

        // Calcular tempos totais em microssegundos
        final encryptEnd = DateTime.now().microsecondsSinceEpoch;
        final totalEncryptTime = encryptEnd - encryptStart;
        final totalDecryptTime = decryptEnd - decryptStart;

        // Calcular médias em milissegundos (dividindo por 1000)
        final avgEncryptTimeMs =
            (totalEncryptTime / numIterations / 1000).toStringAsFixed(3);
        final avgDecryptTimeMs =
            (totalDecryptTime / numIterations / 1000).toStringAsFixed(3);

        // Armazenar resultado com maior precisão
        results.add(BenchmarkResult(
          description,
          double.parse(avgEncryptTimeMs),
          double.parse(avgDecryptTimeMs),
        ));
      }
    }
  }

  // Exibir resultados
  print('--------------------------------------------------------------');
  print('RESULTADOS DO BENCHMARK (média por operação em ms):');
  for (final result in results) {
    print(result);
  }

  // Encontrar o mais rápido
  BenchmarkResult? fastest = results.isNotEmpty ? results[0] : null;
  for (final result in results) {
    if (result.totalTimeMs < fastest!.totalTimeMs) {
      fastest = result;
    }
  }

  if (fastest != null) {
    print('--------------------------------------------------------------');
    print('O tamanho de chave mais rápido foi: ${fastest.keySize}');
    print('--------------------------------------------------------------');
  }
}

// Gerador de string aleatória para teste
String _generateRandomString(int length) {
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
}
