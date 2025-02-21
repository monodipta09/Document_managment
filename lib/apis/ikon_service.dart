import 'dart:core';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../login_page.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
class IKonService {
  late String _tempTicket;
  late String _ticket;
  late String softwareId ;
  late final String _globalAccountId = 'b8bbe5c9-ad0d-4874-b563-275a86e4b818';
  late String  _softwareName = "Document Management";
  late String _versionNumber = "1";
  static final IKonService iKonService = new IKonService();



  final String restUrl = "https://ikoncloud-dev.keross.com/rest";
  final String uploadUrl = 'https://ikoncloud-dev.keross.com/upload';
  final String downloadUrl = 'https://ikoncloud-dev.keross.com/download';

  // Hashes the input string using SHA-512.
  Future<String> _hashPassword(String content) async {
    try {
      final bytes = utf8.encode(content);
      final digest = sha512.convert(bytes);
      return digest.toString();
    } catch (error) {
      throw Exception('Hashing failed: $error');
    }
  }

//   Future<bool> login(String username, String password) async {
//     try {
//       // Hash the password
//       final hashedPassword = await _hashPassword(password);
//
//       // Define headers
//       final headers = {
//         "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
//       };
//
//       // Define query parameters
//       final params = {
//         "inZip": "false",
//         "outZip": "true",
//         "inFormat": "xml",
//         "outFormat": "typedjson",
//         "service": "loginService",
//         "operation": "login",
//         "locale": "en_US",
//       };
//
//       // Construct the credential XML string
//       final credential = '''
// <list>
//   <string>
//     <content><![CDATA[$username]]></content>
//   </string>
//   <string>
//     <content><![CDATA[$hashedPassword]]></content>
//   </string>
// </list>
// '''.trim().replaceAll(RegExp(r'\s+'), '');
//
//       // Encode the parameters into the URL
//       final uri = Uri.parse(restUrl).replace(queryParameters: params);
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
//         // Navigate through the JSON structure to find the temporaryTicket
//         final tempTicket = responseData['value']?['temporaryTicket']?['value'];
//         final ticket = responseData['value']?['ticket']?['value'];
//
//         if (tempTicket != null && tempTicket is String) {
//           // Store the temporaryTicket securely
//           this._tempTicket = tempTicket;
//           return true;
//         }
//
//         else if(ticket != null && ticket is String) {
//           this._ticket = ticket;
//
//            _softwareId = await  _getSoftwareId(_softwareName, _versionNumber);
//           return true;
//         }
//
//         else {
//           // Temporary ticket not found in response
//           return false;
//         }
//       } else {
//         // Handle non-200 responses
//         return false;
//       }
//     } catch (e) {
//       // Handle any exceptions
//       print('Login error: $e');
//       return false;
//     }
//   }

  Future<bool> login(String username, String password) async {
    try {
      final hashedPassword = await _hashPassword(password);

      final headers = {
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
      };

      final params = {
        "inZip": "false",
        "outZip": "true",
        "inFormat": "xml",
        "outFormat": "typedjson",
        "service": "loginService",
        "operation": "login",
        "locale": "en_US",
      };

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

      final uri = Uri.parse(restUrl).replace(queryParameters: params);
      final body = {'arguments': credential};

      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final ticket = responseData['value']?['ticket']?['value'];

        if (ticket != null && ticket is String) {
          this._ticket = ticket;

          // Get software ID and store it
          softwareId = await _getSoftwareId(_softwareName, _versionNumber);

          // Save both ticket and softwareId to Secure Storage
          final storage = FlutterSecureStorage();
          await storage.write(key: "ticket", value: ticket);
          await storage.write(key: "softwareId", value: softwareId);

          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }



  Future<bool> validateSession(String savedTicket) async {
    try {
      final headers = {
        "Content-Type": "application/x-www-form-urlencoded",
      };

      final params = {
        "inZip": "false",
        "outZip": "false",
        "inFormat": "freejson",
        "outFormat": "freejson",
        "service": "loginService",
        "operation": "getLoggedInUserProfile",
        "ticket": savedTicket,
        "activeAccountId": _globalAccountId
      };

      final uri = Uri.parse(restUrl).replace(queryParameters: params);
      final response = await http.post(uri, headers: headers);

      if (response.statusCode == 200) {
        this._ticket = savedTicket;

        // Retrieve the stored softwareId
        final storage = FlutterSecureStorage();
        String? savedSoftwareId = await storage.read(key: "softwareId");

        if (savedSoftwareId != null && savedSoftwareId.isNotEmpty) {
          this.softwareId = savedSoftwareId;
        } else {
          // Re-fetch if not found
          softwareId = await _getSoftwareId(_softwareName, _versionNumber);
          await storage.write(key: "softwareId", value: softwareId);
        }

        return true;
      } else {
        await logout();
        return false;
      }
    } catch (error) {
      print("Error validating session: $error");
      return false;
    }
  }



  Future<bool> validateOtp(String otp) async {
    try {
      // Define headers
      final headers = {
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
      };

      // Retrieve the temporaryTicket from secure storage
      final temporaryTicket = this._tempTicket;
      if (temporaryTicket == null) {
        return false;
      }

      // Define query parameters
      final params = {
        "inFormat": "xml",
        "inZip": "false",
        "locale": "en_US",
        "operation": "validateOTP",
        "outFormat": "typedjson",
        "outZip": "true",
        "service": "loginService",
      };

      // Construct the credential XML string
      final credential = '''
<list>
  <string>
    <content><![CDATA[$temporaryTicket]]></content>
  </string>
  <string>
    <content><![CDATA[$otp]]></content>
  </string>
</list>
'''.trim().replaceAll(RegExp(r'\s+'), '');

      // Encode the parameters into the URL
      final uri = Uri.parse(restUrl).replace(queryParameters: params);

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

        // Navigate through the JSON structure to find the ticket
        final ticket = responseData['value']?['ticket']?['value'];

        if (ticket != null && ticket is String) {
          // Store the ticket securely
          this._ticket = ticket;
          return true;
        } else {
          // Ticket not found in response
          return false;
        }
      } else {
        // Handle non-200 responses
        return false;
      }
    } catch (e) {
      // Handle any exceptions
      print('OTP Validation error: $e');
      return false;
    }
  }

  Future<bool> resetPassword(String userName) async {
    try {
      // Define headers
      final headers = {
        "User-Agent": "Human",
        "Content-Type": "application/x-www-form-urlencoded",
      };

      // Define query parameters
      final params = {
        "inZip": "false",
        "outZip": "false",
        "inFormat": "freejson",
        "outFormat": "freejson",
        "service": "loginService",
        "operation": "resetPassword",
      };

      // Construct the data
      final data = jsonEncode([userName]); // Equivalent to '["$userName"]'

      // Encode the parameters into the URL
      final uri = Uri.parse(restUrl).replace(queryParameters: params);

      // Encode the body as application/x-www-form-urlencoded
      final body = {'arguments': data};

      // Make the POST request
      final response = await http.post(
        uri,
        headers: headers,
        body: body,
      );

      print(response);

      if (response.statusCode == 200) {
        // Optionally, you can parse the response data here
        // For example:
        // final responseData = json.decode(response.body);
        // return responseData;
        return true;
      } else {
        // Handle non-200 responses
        return false;
      }
    } catch (error) {
      print("Error during resetPassword API call: $error");
      throw error;
    }
  }

  // Future<void> logout({Function? callback}) async {
  //   try {
  //     final storage = FlutterSecureStorage();
  //     await storage.delete(key: "ticket");
  //     await storage.delete(key: "locale");
  //     await storage.delete(key: "version");
  //     await storage.delete(key: "theme");
  //     await storage.delete(key: "userpagetype");
  //
  //     final headers = {
  //       "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
  //     };
  //
  //     final params = {
  //       "inZip": "false",
  //       "outZip": "false",
  //       "inFormat": "freejson",
  //       "outFormat": "freejson",
  //       "service": "loginService",
  //       "operation": "logout",
  //     };
  //
  //     final uri = Uri.parse(restUrl).replace(queryParameters: params);
  //     final response = await http.post(uri, headers: headers);
  //
  //     if (response.statusCode == 200) {
  //       if (callback != null) {
  //         callback();
  //       } else {
  //         // Navigate to the LoginPage using navigatorKey
  //         navigatorKey.currentState?.pushAndRemoveUntil(
  //           MaterialPageRoute(builder: (context) => LoginPage()),
  //               (route) => false,
  //         );
  //       }
  //     } else {
  //       throw Exception("Logout API failed");
  //     }
  //   } catch (e) {
  //     print("Logout error: $e");
  //
  //     // Navigate to the LoginPage in case of an error
  //     navigatorKey.currentState?.pushAndRemoveUntil(
  //       MaterialPageRoute(builder: (context) => LoginPage()),
  //           (route) => false,
  //     );
  //   }
  // }

  Future<void> logout({Function? callback}) async {
    try {
      final storage = FlutterSecureStorage();
      await storage.delete(key: "ticket"); // Remove stored ticket
      await storage.delete(key: "softwareId"); // Remove stored softwareId
      await storage.delete(key: "locale");
      await storage.delete(key: "version");
      await storage.delete(key: "theme");
      await storage.delete(key: "userpagetype");

      final headers = {
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
      };

      final params = {
        "inZip": "false",
        "outZip": "false",
        "inFormat": "freejson",
        "outFormat": "freejson",
        "service": "loginService",
        "operation": "logout",
      };

      final uri = Uri.parse(restUrl).replace(queryParameters: params);
      await http.post(uri, headers: headers);

      if (callback != null) {
        callback();
      } else {
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => false,
        );
      }
    } catch (e) {
      print("Logout error: $e");
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false,
      );
    }
  }



  Future<String> _getSoftwareId(String softwareName,String versionNumber ) async {
    var headers = {
      'User-Agent': 'IKON Job Server',
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    // Define query parameters
    final params = {
      "inZip": "false",
      "outZip": "false",
      "inFormat": "freejson",
      "outFormat": "freejson",
      "service": "softwareService",
      "operation": "mapSoftwareName",
      "locale":"en_US",
      "activeAccountId":this._globalAccountId,
      "ticket": this._ticket
    };

    final uri = Uri.parse(restUrl).replace(queryParameters: params);

    final body = {
      'arguments': jsonEncode([softwareName,versionNumber])
    };

    // Make the POST request
    final response = await http.post(
      uri,
      headers: headers,
      body: body,
    );

    print(response);
    try{
      if (response.statusCode == 200) {
        // Optionally, you can parse the response data here
        // For example:
        // final responseData = json.decode(response.body);
        // return responseData;
        return response.body.replaceAll('\"', "");
      }else if(response.statusCode == 401){
        await logout();
        return "";
      } else {
        // Handle non-200 responses
        return 'false';
      }
    } catch (error) {
      print("Error during getSoftwareId API call: $error");
      throw error;
    }

  }


  Future<List<Map<String, dynamic>>> getMyInstancesV2({
    required String processName,
    required Map<String, dynamic>? predefinedFilters,
    required Map<String, dynamic>? processVariableFilters,
    required Map<String, dynamic>? taskVariableFilters,
    required String? mongoWhereClause,
    required List<String> projections,
    required bool allInstance,})
    async {
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    final params = {
      "inZip": "false",
      "outZip": "false",
      "inFormat": "freejson",
      "outFormat": "freejson",
      "service": "processRuntimeService",
      "operation": "getMyInstancesV2",
      "softwareId": softwareId,
      "activeAccountId": _globalAccountId,
      "ticket": _ticket
    };

    try {
      final uri = Uri.parse(restUrl).replace(queryParameters: params);

      final arguments = [
        processName,
        _globalAccountId,
        predefinedFilters,
        processVariableFilters,
        taskVariableFilters,
        mongoWhereClause,
        projections,  // Now using the projections parameter instead of empty array
        allInstance
      ];

      final body = {
        'arguments': jsonEncode(arguments)
      };

      final response = await http.post(
        uri,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(
            responseData.map((item) => Map<String, dynamic>.from(item))
        );
      }else if(response.statusCode == 401){
        await logout();
        return [];
    }else {
        print('API Error: ${response.statusCode} - ${response.reasonPhrase}');
        throw Exception('Failed to get instances: ${response.reasonPhrase}');
      }
    } catch (error) {
      print("Error during getMyInstances API call: $error");
      throw error;
    }
  }

  String getDownloadUrlForFiles(String resourceId, String resourceName, String resourceType) {
      return downloadUrl + "?ticket=" + _ticket + "&resourceId=" + resourceId + "&resourceName=" + resourceName + "&resourceType=" + resourceType;
  }

  Future<String> mapProcessName({required String processName}) async {
      final headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

    final params = {
      "inZip": "false",
      "outZip": "false",
      "inFormat": "freejson",
      "outFormat": "freejson",
      "service": "processRuntimeService",
      "operation": "mapProcessName",
      "ticket": _ticket,
      "activeAccountId": _globalAccountId,
      "softwareId": softwareId
    };

    try {
      final uri = Uri.parse(restUrl).replace(queryParameters: params);

      final arguments = [
        processName,
        _globalAccountId
      ];

      final body = {
        'arguments': jsonEncode(arguments)
      };

      final response = await http.post(
        uri,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return response.body.replaceAll('\"', "");
      }else if(response.statusCode == 401){
        await logout();
        return "";
      } else {
        print('API Error: ${response.statusCode} - ${response.reasonPhrase}');
        throw Exception('Failed to map process name: ${response.reasonPhrase}');
      }
    } catch (error) {
      print("Error during mapProcessName API call: $error");
      throw error;
    }
  }


  Future<bool> startProcessV2({required String processId,
     required dynamic  data,
     required dynamic processIdentifierFields
  })
   async {
    try {
      final headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      final params = {
        "inZip": "false",
        "outZip": "false",
        "inFormat": "freejson",
        "outFormat": "freejson",
        "service": "processRuntimeService",
        "operation": "startProcessV2",
        "ticket": _ticket,
        "activeAccountId": _globalAccountId,
        "softwareId": softwareId
      };

      final uri = Uri.parse(restUrl).replace(queryParameters: params);

      final arguments = [
        processId,
        data,
        processIdentifierFields
      ];

      final body = {
        'arguments': jsonEncode(arguments)
      };

      final response = await http.post(
        uri,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final processInstanceID = jsonDecode(response.body);

        // You might want to check specific conditions in the response
        // to determine if the process started successfully
        if (processInstanceID != null) {
          return true;
        } else {
          print('Process start failed: Invalid response data');
          return false;
        }
      } else if(response.statusCode == 401){
        await logout();
        return false;
      }else {
        print('API Error: ${response.statusCode} - ${response.reasonPhrase}');
        print(response.body);
        return false;
      }
    } catch (error) {
      print("Error during startProcessV2 API call: $error");

      return false;
    }
  }

  Future<bool> invokeAction({
    required String taskId,
    required String transitionName,
    required dynamic  data,
    required dynamic processIdentifierFields})
  async {
    try {
      final headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      final params = {
        "inZip": "false",
        "outZip": "false",
        "inFormat": "freejson",
        "outFormat": "freejson",
        "service": "processRuntimeService",
        "operation": "invokeAction",
        "ticket": _ticket,
        "activeAccountId": _globalAccountId,
        "softwareId": softwareId
      };

      final uri = Uri.parse(restUrl).replace(queryParameters: params);

      final arguments = [
        taskId,
        transitionName,
        data,
        processIdentifierFields
      ];

      final body = {
        'arguments': jsonEncode(arguments)
      };

      final response = await http.post(
        uri,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final processInstanceID = jsonDecode(response.body);

        // You might want to check specific conditions in the response
        // to determine if the process started successfully
        if (processInstanceID != null) {
          return true;
        } else {
          print('Process invoke failed: Invalid response data');
          return false;
        }
      } else if(response.statusCode == 401){
        await logout();
        return false;
      }else {
        print('API Error: ${response.statusCode} - ${response.reasonPhrase}');
        print(response.body);
        return false;


      }
    } catch (error) {
      print("Error during invokeAction API call: $error");
      return false;
    }
  }

  Future<Map<String, dynamic>> getLoggedInUserProfile() async {
    try {
      final headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      final params = {
        "inZip": "false",
        "outZip": "false",
        "inFormat": "freejson",
        "outFormat": "freejson",
        "service": "loginService",
        "operation": "getLoggedInUserProfile",
        "ticket": _ticket,
        "activeAccountId": _globalAccountId
      };

      final uri = Uri.parse(restUrl).replace(queryParameters: params);

      // Empty body as per original request
      final body = {};

      final response = await http.post(
        uri,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final userProfile = jsonDecode(response.body);

        if (userProfile != null && userProfile is Map<String, dynamic>) {
          return userProfile;
        } else {
          print('Get user profile failed: Invalid response data');
          throw Exception('Invalid response format');
        }
      } else if(response.statusCode == 401){
        await logout();
        return {};
      }else {
        print('API Error: ${response.statusCode} - ${response.reasonPhrase}');
        print(response.body);
        throw Exception('Failed to get user profile: ${response.reasonPhrase}');
      }
    } catch (error) {
      print("Error during getLoggedInUserProfileDetails API call: $error");
      throw error;
    }
  }

  Future<Map<String, dynamic>> getLoggedInUserProfileDetails() async {
    try {
      final headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      final params = {
        "inZip": "false",
        "outZip": "false",
        "inFormat": "freejson",
        "outFormat": "freejson",
        "service": "loginService",
        "operation": "getLoggedInUserProfileDetails",
        "ticket": _ticket,
        "activeAccountId": _globalAccountId
      };

      final uri = Uri.parse(restUrl).replace(queryParameters: params);

      // Empty body as per original request
      final body = {};

      final response = await http.post(
        uri,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final userProfile = jsonDecode(response.body);

        if (userProfile != null && userProfile is Map<String, dynamic>) {
          return userProfile;
        } else {
          print('Get user profile failed: Invalid response data');
          throw Exception('Invalid response format');
        }
      }else if(response.statusCode == 401){
        await logout();
        return {};
      } else {
        print('API Error: ${response.statusCode} - ${response.reasonPhrase}');
        print(response.body);
        throw Exception('Failed to get user profile: ${response.reasonPhrase}');
      }
    } catch (error) {
      print("Error during getLoggedInUserProfileDetails API call: $error");
      throw error;
    }
  }

    Future<List<dynamic>> getAllUsers() async {
    try {
      final headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      final params = {
        "inZip": "false",
        "outZip": "false",
        "inFormat": "freejson",
        "outFormat": "freejson",
        "service": "userService",
        "operation": "getAllUsers",
        "ticket": _ticket,
        "activeAccountId": _globalAccountId
      };

      final uri = Uri.parse(restUrl).replace(queryParameters: params);

      
      final arguments = [
        _globalAccountId,
      ];

      // Empty body as per original request
      final body = {
        'arguments': jsonEncode(arguments),
      };

      final response = await http.post(
        uri,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final userProfile = jsonDecode(response.body);

        if (userProfile != null && userProfile is List) {
          return userProfile;
        } else {
          print('Get user profile failed: Invalid response data');
          throw Exception('Invalid response format');
        }
      } else {
        print('API Error: ${response.statusCode} - ${response.reasonPhrase}');
        print(response.body);
        throw Exception('Failed to get user profile: ${response.reasonPhrase}');
      }
    } catch (error) {
      print("Error during getLoggedInUserProfileDetails API call: $error");
      throw error;
    }
  }

  Future<String> uploadFile({ required String filePath, required String resourceId}) async {
    var headers = {
      'Content-Type': 'multipart/form-data'
    };

    final uri = Uri.parse(uploadUrl).replace(queryParameters: {
      'ticket': _ticket,
      'resourceId': resourceId
    });

    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('file', filePath));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        return await response.stream.bytesToString();
      }else if(response.statusCode == 401){
        await logout();
        return "";
      } else {
        print('Upload failed: ${response.reasonPhrase}');
        return 'false';
      }
    } catch (error) {
      print("Error during file upload: $error");
      throw error;
    }
  }


  Future<String> downloadResource({required String resourceId,required String resourceName}) async {
    try {
      final params = {
        'ticket': _ticket,
        'resourceId': resourceId,
        'resourceName': resourceName
      };

      final uri = Uri.parse(downloadUrl).replace(queryParameters: params);

      final request = http.MultipartRequest('GET', uri);

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        return responseBody;
      }else if(response.statusCode == 401){
        await logout();
        return "";
      } else {
        print('API Error: ${response.statusCode} - ${response.reasonPhrase}');
        throw Exception('Failed to download resource: ${response.reasonPhrase}');
      }
    } catch (error) {
      print("Error during downloadResource API call: $error");
      throw error;
    }
  }

  // Future<void> updateUserProfile({required String name, required String password, required String phone, required String email, required dynamic thumbnail}) async {
  //   try {
  //     final headers = {
  //       'Content-Type': 'application/x-www-form-urlencoded',
  //       'Cookie': 'CustomHeader=$email'
  //     };
  //
  //     final params = {
  //       "inZip": "false",
  //       "outZip": "false",
  //       "inFormat": "freejson",
  //       "outFormat": "freejson",
  //       "service": "loginService",
  //       "operation": "updateUserProfile",
  //       "ticket": _ticket, // Assuming ticket is available in scope
  //     };
  //
  //     final uri = Uri.parse(restUrl).replace(queryParameters: params);
  //
  //     final arguments = jsonEncode([name, password, phone, email, thumbnail]);
  //     final body = {
  //       'arguments': arguments
  //     };
  //
  //     final response = await http.post(
  //       uri,
  //       headers: headers,
  //       body: body,
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final updatedProfile = jsonDecode(response.body);
  //
  //       if (updatedProfile != null && updatedProfile is Map<String, dynamic>) {
  //         return ;
  //       } else {
  //         print('Update user profile failed: Invalid response data');
  //         throw Exception('Invalid response format');
  //       }
  //     } else {
  //       print('API Error: ${response.statusCode} - ${response.reasonPhrase}');
  //       print(response.body);
  //       throw Exception('Failed to update user profile: ${response.reasonPhrase}');
  //     }
  //   } catch (error) {
  //     print("Error during updateUserProfile API call: $error");
  //     throw error;
  //   }
  // }

  Future<void> updateUserProfile({
    required String name,
    required String password,
    required String phone,
    required String email,
    required dynamic thumbnail,
  }) async {
    try {
      final headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'CustomHeader=$email',
      };

      final params = {
        "inZip": "false",
        "outZip": "false",
        "inFormat": "freejson",
        "outFormat": "freejson",
        "service": "loginService",
        "operation": "updateUserProfile",
        "ticket": _ticket, // Ensure _ticket is valid
      };

      final uri = Uri.parse(restUrl).replace(queryParameters: params);

      final arguments = jsonEncode([name, password, phone, email, thumbnail]);
      final body = 'arguments=${Uri.encodeComponent(arguments)}';

      print('Request URI: $uri');
      print('Request Headers: $headers');
      print('Request Body: $body');

      final response = await http.post(
        uri,
        headers: headers,
        body: body,
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final updatedProfile = jsonDecode(response.body);

        // if (updatedProfile != null && updatedProfile is Map<String, dynamic>) {
        //   print('Profile updated successfully.');
        //   return;
        // } else {
        //   print('Update user profile failed: Invalid response data');
        //   throw Exception('Invalid response format');
        // }
      } else if(response.statusCode == 401){
        await logout();
      }else {
        print('API Error: ${response.statusCode} - ${response.reasonPhrase}');
        print('Error Body: ${response.body}');
        throw Exception('Failed to update user profile: ${response.reasonPhrase}');
      }
    } catch (error) {
      print("Error during updateUserProfile API call: $error");
      throw error;
    }
  }



}