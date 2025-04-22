class BenchmarkResult {
  final String keySize;
  final double encryptionTimeMs;
  final double decryptionTimeMs;
  final double totalTimeMs;

  BenchmarkResult(this.keySize, this.encryptionTimeMs, this.decryptionTimeMs)
      : totalTimeMs = encryptionTimeMs + decryptionTimeMs;

  @override
  String toString() {
    return 'Chave $keySize: Encrypt=${encryptionTimeMs.toStringAsFixed(4)}ms, '
        'Decrypt=${decryptionTimeMs.toStringAsFixed(4)}ms, '
        'Total=${totalTimeMs.toStringAsFixed(4)}ms';
  }
}
