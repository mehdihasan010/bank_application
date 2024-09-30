class CardData {
  final String userId;
  final String cardNumber;
  final String cardholderName;
  final String expiryDate; // Format: MM/YY
  final String cvv;
  final String cardType;

  // Constructor
  CardData({
    required this.userId,
    required this.cardNumber,
    required this.cardholderName,
    required this.expiryDate,
    required this.cvv,
    required this.cardType,
  });

  // Method to convert the card data to a Map (for API requests)
  Map<String, String> toMap() {
    return {
      'user_id': userId,
      'card_number': cardNumber,
      'cardholder_name': cardholderName,
      'expiry_date': expiryDate,
      'cvv': cvv,
      'card_type': cardType,
    };
  }

  // Factory method to create an instance of CardData from JSON (if needed)
  factory CardData.fromJson(Map<String, dynamic> json) {
    return CardData(
      userId: json['user_id'],
      cardNumber: json['card_number'],
      cardholderName: json['cardholder_name'],
      expiryDate: json['expiry_date'],
      cvv: json['cvv'],
      cardType: json['card_type'],
    );
  }
}
