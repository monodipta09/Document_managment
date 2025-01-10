import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
class AuthService {
  static const String baseUrl = "https://ikoncloud.keross.com/rest";
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Hashes the input string using SHA-512.
  Future<String> hashPassword(String content) async {
    try {
      final bytes = utf8.encode(content);
      final digest = sha512.convert(bytes);
      return digest.toString();
    } catch (error) {
      throw Exception('Hashing failed: $error');
    }
  }

  /// Logs in the user with [username] and [password].
  Future<bool> login(String username, String password) async {
    try {
      // Hash the password
      final hashedPassword = await hashPassword(password);

      // Define headers
      final headers = {
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
      };

      // Define query parameters
      final params = {
        "inZip": "false",
        "outZip": "true",
        "inFormat": "xml",
        "outFormat": "typedjson",
        "service": "loginService",
        "operation": "login",
        "locale": "en_US",
      };

      // Construct the credential XML string
      final credential = '''
<list>
  <string>
    <content><![CDATA[$username]]></content>
  </string>
  <string>
    <content><![CDATA[$hashedPassword]]></content>
  </string>
</list>
'''.trim().replaceAll(RegExp(r'\s+'), '');

      // Encode the parameters into the URL
      final uri = Uri.parse(baseUrl).replace(queryParameters: params);

      // Encode the body as application/x-www-form-urlencoded
      final body = {'arguments': credential};

      // Make the POST request
      final response = await http.post(
        uri,
        headers: headers,
        body: body,
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Navigate through the JSON structure to find the temporaryTicket
        final tempTicket = responseData['value']?['temporaryTicket']?['value'];

        if (tempTicket != null && tempTicket is String) {
          // Store the temporaryTicket securely
          await _secureStorage.write(key: 'tempTicket', value: tempTicket);
          return true;
        } else {
          // Temporary ticket not found in response
          return false;
        }
      } else {
        // Handle non-200 responses
        return false;
      }
    } catch (e) {
      // Handle any exceptions
      print('Login error: $e');
      return false;
    }
  }

  /// Validates the OTP provided by the user.
//   Future<bool> validateOtp(String otp) async {
//     try {
//       // Define headers
//       final headers = {
//         "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
//       };
//
//       // Retrieve the temporaryTicket from secure storage
//       final temporaryTicket = await _secureStorage.read(key: "tempTicket");
//       if (temporaryTicket == null) {
//         return false;
//       }
//
//       // Define query parameters
//       final params = {
//         "inFormat": "xml",
//         "inZip": "false",
//         "locale": "en_US",
//         "operation": "validateOTP",
//         "outFormat": "typedjson",
//         "outZip": "true",
//         "service": "loginService",
//       };
//
//       // Construct the credential XML string
//       final credential = '''
// <list>
//   <string>
//     <content><![CDATA[$temporaryTicket]]></content>
//   </string>
//   <string>
//     <content><![CDATA[$otp]]></content>
//   </string>
// </list>
// '''.trim().replaceAll(RegExp(r'\s+'), '');
//
//       // Encode the parameters into the URL
//       final uri = Uri.parse(baseUrl).replace(queryParameters: params);
//
//       // Encode the body as application/x-www-form-urlencoded
//       final body = {'arguments': credential};
//
//       // Make the POST request
//       final response = await http.post(
//         uri,
//         headers: headers,
//         body: body,
//       );
//
//       // Check if the request was successful
//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//
//         // Navigate through the JSON structure to find the ticket
//         final ticket = responseData['value']?['ticket']?['value'];
//
//         if (ticket != null && ticket is String) {
//           // Store the ticket securely
//           await _secureStorage.write(key: 'ticket', value: ticket);
//           return true;
//         } else {
//           // Ticket not found in response
//           return false;
//         }
//       } else {
//         // Handle non-200 responses
//         return false;
//       }
//     } catch (e) {
//       // Handle any exceptions
//       print('OTP Validation error: $e');
//       return false;
//     }
//   }

  /// Resets the password for the given [username].
  // Future<bool> resetPassword(String userName) async {
  //   try {
  //     // Define headers
  //     final headers = {
  //       "User-Agent": "Human",
  //       "Content-Type": "application/x-www-form-urlencoded",
  //     };
  //
  //     // Define query parameters
  //     final params = {
  //       "inZip": "false",
  //       "outZip": "false",
  //       "inFormat": "freejson",
  //       "outFormat": "freejson",
  //       "service": "loginService",
  //       "operation": "resetPassword",
  //     };
  //
  //     // Construct the data
  //     final data = jsonEncode([userName]); // Equivalent to '["$userName"]'
  //
  //     // Encode the parameters into the URL
  //     final uri = Uri.parse(baseUrl).replace(queryParameters: params);
  //
  //     // Encode the body as application/x-www-form-urlencoded
  //     final body = {'arguments': data};
  //
  //     // Make the POST request
  //     final response = await http.post(
  //       uri,
  //       headers: headers,
  //       body: body,
  //     );
  //
  //     print(response);
  //
  //     if (response.statusCode == 200) {
  //       // Optionally, you can parse the response data here
  //       // For example:
  //       // final responseData = json.decode(response.body);
  //       // return responseData;
  //       return true;
  //     } else {
  //       // Handle non-200 responses
  //       return false;
  //     }
  //   } catch (error) {
  //     print("Error during resetPassword API call: $error");
  //     throw error;
  //   }
  // }
}
