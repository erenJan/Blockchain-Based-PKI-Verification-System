class Wallets{
  final String name;
  final String privateKey;
  final String publicKey;

  Wallets({
    this.name,
    this.privateKey,
    this.publicKey
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'privateKey': privateKey,
      'publicKey':publicKey
    };
  }

  @override
  String toString() {
    return 'Wallet{name: $name, privateKey: $privateKey, publicKey: $publicKey}';
  }
}