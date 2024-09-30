class User {
  final int id;
  final String name;
  final String email;
  final double balance;

  // Constructor
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.balance,
  });

  // Factory method to create a User object from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.parse(json['id']),
      name: json['name'],
      email: json['email'],
      balance: double.parse(json['balance']),
    );
  }

  // Method to convert User object back to JSON if needed
  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'name': name,
      'email': email,
      'balance': balance.toString(),
    };
  }
}
