
class Auth{
  final String id; 

  Auth({
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }

  @override
  String toString() {
    return 'User{id: $id,}';
  }
}