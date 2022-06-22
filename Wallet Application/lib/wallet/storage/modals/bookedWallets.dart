class BookedWallet {
  final String name;
  final String signature;

  BookedWallet({
    this.name,
    this.signature,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'signature': signature,
    };
  }

  @override
  String toString() {
    return 'BookedWallet{name: $name, signature: $signature}';
  }
}