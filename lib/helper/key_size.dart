enum KeySize {
  /// 16 bytes
  bits128('my 16 length key'),

  /// 24 bytes
  bits192('my 24 length key........'),

  /// 32 bytes
  bits256('my 32 length key................');

  final String keyString;
  const KeySize(this.keyString);

  int get length => keyString.length;
}
