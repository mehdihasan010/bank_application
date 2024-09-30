import 'dart:convert';

import 'package:bank_application/data/model/card.dart';
import 'package:bank_application/data/model/users.dart';
import 'package:http/http.dart' as http;

import 'model/transactions.dart';
import 'model/user.dart';

class ApiService {
  static const String baseUrl = 'https://mehdicse.fun/api/v1/api.php';

  // Get user user

  static Future<User> getUser(int userId) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode({'action': 'getUser', 'userId': userId}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Failed to get user');
    }
  }

  // Get user balance

  static Future<double?> getBalance(int userId) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode({'action': 'getBalance', 'userId': userId}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['balance'] != null
          ? double.tryParse(data['balance'].toString())
          : null;
    } else {
      throw Exception('Failed to get balance');
    }
  }

  // Withdraw money

  static Future<bool> withdraw(int userId, double amount) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode(
          {'action': 'withdraw', 'userId': userId, 'amount': amount}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] ?? false;
    } else {
      throw Exception('Failed to withdraw');
    }
  }

  // Add money to balance

  static Future<bool> addMoney(int userId, double amount) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode(
          {'action': 'addMoney', 'userId': userId, 'amount': amount}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] ?? false;
    } else {
      throw Exception('Failed to add money');
    }
  }

// Get Transactions

  static Future<List<Transaction>> fetchTransactions(int userId) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode({
        'action': 'getTransactions',
        'userId': userId,
      }),
    );

    if (response.statusCode == 200) {
      final List transactions = jsonDecode(response.body)['transactions'];
      return transactions.map((json) => Transaction.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  // Add Card
  static Future<String> addCard(CardData cardData) async {
    // Create the JSON body one option
    /* final Map<String, dynamic> body = cardData.toJson();
    body['action'] = 'addCard'; // Action for the API to identify the request */

    final response = await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode({'action': 'addCard', ...cardData.toMap()}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      if (responseData['status'] == 'success') {
        return responseData['message'];
      } else {
        return responseData['message'];
      }
    } else {
      return "Error ${response.statusCode}";
    }
  }

  // Fetch user cards
  static Future<List<CardData>> fetchCards(String userId) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode({
        'action': 'getCard',
        'userId': userId,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      if (responseData['Card'] != null) {
        List<CardData> cards = (responseData['Card'] as List)
            .map((card) => CardData.fromJson(card))
            .toList();
        return cards;
      }
    }
    throw Exception('Failed to load cards');
  }

  // Register user
  static Future<dynamic> register(Users user) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode({
        'action': 'registerUser',
        ...user.toJson(),
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      if (responseData['status'] != null) {
        return responseData;
      }
    }
    return 'Registration failed';
  }

  // Login user
  static Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode({
        'action': 'login',
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      if (responseData['status'] != null) {
        return responseData['status'];
      } else {
        return responseData['error'];
      }
    }
    return 'Login failed';
  }

  static Future<bool> validateOTP(String email, String otp) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode({
        'action': 'validateOTP',
        'email': email,
        'otp': otp,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      try {
        var responseData = jsonDecode(response.body) as Map<String, dynamic>;

        // Check if 'status' exists and is a string or whatever type you expect
        if (responseData.containsKey('status') &&
            responseData['status'] != null) {
          return true;
        } else {
          return false;
        }
      } catch (e) {
        return false; // or you can return the error if needed
      }
    }

    return false;
  }
}
