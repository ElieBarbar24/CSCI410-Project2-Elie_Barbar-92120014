import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connect/Models/Messages.dart';
import 'package:connect/Models/RecentChatModel.dart';
import 'package:connect/Models/User.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

//Create New User Or Signup Methode
Future<int> createUser(User user) async {
  ByteData fileContents = await rootBundle.load('images/pic.png');
  Uint8List imageData = fileContents.buffer.asUint8List();
  const String apiUrl = 'https://eliebarbar.000webhostapp.com/createUser.php';

  var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
  request.fields['json'] = jsonEncode(user.toJson());
  request.files.add(
    http.MultipartFile.fromBytes('file', imageData,
        filename: 'pic.png', contentType: MediaType('image', 'png')),
  );

  try {
    final client = http.Client();
    final response = await client.send(request);

    // Ensure client is closed
    client.close();

    print(response);

    // Handle different response scenarios
    if (response.statusCode == 200) {
      print('User created successfully');
    } else if (response.statusCode == 401) {
      print('Email Already Exist');
    } else {
      print('Failed to create user. Status code: ${response.statusCode}');
    }

    return response.statusCode;
  } catch (error) {
    print('Error sending request: $error');
    return 0;
  }
}

//Accept Friend Request
Future<void> acceptFriendRequest(int Uid) async {
  const String apiUrl =
      'https://eliebarbar.000webhostapp.com/acceptFriendRequest.php';

  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'Uid': currentUser.id, 'Fid': Uid}));
    print(response.body);
    if (response.statusCode == 200) {
      print("Hi");
    } else {
      print('Failed to add friend. Status code: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  } catch (error) {}
}

// Unfriend
Future<void> Unfriend(int Uid) async {
  const String apiUrl = 'https://eliebarbar.000webhostapp.com/UnFriend.php';

  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'Uid': currentUser.id, 'Fid': Uid}));
    if (response.statusCode == 200) {
    } else {
      print('Failed to add friend. Status code: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  } catch (error) {}
}

//Add Friend Methode
Future<void> addFriend(int Uid) async {
  const String apiUrl = 'https://eliebarbar.000webhostapp.com/addFriend.php';

  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'SenderId': currentUser.id, 'RecieverId': Uid}));
    print(response.body);
    if (response.statusCode == 200) {
      print("Hi");
    } else {
      print('Failed to add friend. Status code: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  } catch (error) {}
}

//Login Methode
Future<int?> logIn(String email, String password) async {
  const String apiUrl = 'https://eliebarbar.000webhostapp.com/login.php';

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);

    User user = User.idUser(int.parse(data['ID']), data['name'], data['email'],
        data['password'], data['Status'], data['ProfilePic'], data['friendID']);
    currentUser = user;
    return 200;
  } else if (response.statusCode == 401) {
    // Password don't match
    return 401;
  } else if (response.statusCode == 404) {
    //user not found
    return 404;
  } else {
    print('Failed to login. Status code: ${response.statusCode}');
    return response.statusCode;
  }
}

//Load Friend Requests
class FriendRequests {
  final _usersController = StreamController<List<User>>();
  Stream<List<User>> get usersStream => _usersController.stream;

  Future<void> loadFriendRequests() async {
    const String apiUrl =
        'https://eliebarbar.000webhostapp.com/LoadFriendRequest.php';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'id': currentUser.id}),
    );
    print(response.body);
    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        List<User> users = [];
        _usersController.add(users);
        return;
      }
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      List<User> users = [];
      for (var u in jsonResponse) {
        users.add(User.friendRequest(int.parse(u['ID']), u['name'], u['email'],
            u['password'], u['Status'], u['ProfilePic']));
      }
      _usersController.add(users);
    }
  }

  void dispose() {
    _usersController.close();
  }
}

class searchPeopleStream {
  var _usersController = StreamController<List<User>>();
  Stream<List<User>> get usersStream => _usersController.stream;

  bool _isStreamPaused = false;
  Future<void> searchUsers() async {
    const String apiUrl =
        'https://eliebarbar.000webhostapp.com/searchPeople.php';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'id': currentUser.id}),
    );
    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        List<User> users = [];
        _usersController.add(users);
        return;
      }
      final List<dynamic> jsonResponse = jsonDecode(response.body);

      List<User> users = [];
      for (var u in jsonResponse) {
        users.add(User.friendRequest(
          int.parse(u['ID']),
          u['name'],
          u['email'],
          u['password'],
          u['Status'],
          u['ProfilePic'],
        ));
      }
      _usersController.add(users);
    }
  }

  void pauseStream() {
    _isStreamPaused = true;
    _usersController
        .addError("Stream paused"); // You can use this to signal pause status
    _usersController = StreamController<List<User>>.broadcast();
  }

  void resumeStream() {
    _isStreamPaused = false;
    _usersController.addError(""); // Clear the pause signal
    _usersController = StreamController<List<User>>.broadcast();
  }

  bool isStreamPaused() {
    return _isStreamPaused;
  }

  void dispose() {
    _usersController.close();
  }
}

class filterPeopleStream {
  var _usersController = StreamController<List<User>>();
  Stream<List<User>> get usersStream => _usersController.stream;
  bool _isStreamPaused = false;

  Future<void> filterPeople(String s) async {
    const String apiUrl =
        'https://eliebarbar.000webhostapp.com/searchPeople.php';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'id': currentUser.id, 'subName': s}),
    );
    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        List<User> users = [];
        _usersController.add(users);
        return;
      }
      final List<dynamic> jsonResponse = jsonDecode(response.body);

      List<User> users = [];
      for (var u in jsonResponse) {
        users.add(User.idUser(
            int.parse(u['ID']),
            u['name'],
            u['email'],
            u['password'],
            u['Status'],
            u['ProfilePic'],
            int.parse(u['friendID'])));
      }
      _usersController.add(users);
    }
  }

  void pauseStream() {
    _isStreamPaused = true;
    _usersController
        .addError("Stream paused"); // You can use this to signal pause status
    _usersController = StreamController<List<User>>.broadcast();
  }

  void resumeStream() {
    _isStreamPaused = false;
    _usersController.addError(""); // Clear the pause signal
    _usersController = StreamController<List<User>>.broadcast();
  }

  bool isStreamPaused() {
    return _isStreamPaused;
  }

  void dispose() {
    _usersController.close();
  }
}

class SFriends {
  final _usersController = StreamController<List<User>>();
  Stream<List<User>> get usersStream => _usersController.stream;

  Future<void> searchUsers(int myid) async {
    const String apiUrl =
        'https://eliebarbar.000webhostapp.com/LoadFriends.php';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'id': currentUser.id}),
    );
    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        List<User> users = [];
        _usersController.add(users);
        return;
      }
      print(response.body);
      final List<dynamic> jsonResponse = jsonDecode(response.body);

      List<User> users = [];
      for (var u in jsonResponse) {
        users.add(User.idUser(
            int.parse(u['ID']),
            u['name'],
            u['email'],
            u['password'],
            u['Status'],
            u['ProfilePic'],
            int.parse(u['friendID'])));
      }
      _usersController.add(users);
    }
  }

  void dispose() {
    _usersController.close();
  }
}

Future<int?> updateName(String name) async {
  const String apiUrl = 'https://eliebarbar.000webhostapp.com/updateName.php';

  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'id': currentUser.id, 'name': name}));
    print(response.body);
    if (response.statusCode == 200) {
      return 200;
    } else {
      return 500;
    }
  } catch (error) {}
}

Future<void> updatePassword(String password) async {
  const String apiUrl =
      'https://eliebarbar.000webhostapp.com/updatePassword.php';

  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'id': currentUser.id, 'password': password}));
    print(response.body);
    if (response.statusCode == 200) {
      print("Hi");
    } else {
      print('Failed to add friend. Status code: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  } catch (error) {}
}

Future<int?> updateEmail(String email) async {
  const String apiUrl = 'https://eliebarbar.000webhostapp.com/updateEmail.php';

  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'id': currentUser.id, 'email': email}));
    print(response.body);
    return response.statusCode;
  } catch (error) {}
}

Future<void> updateProfile(int id, File image) async {
  const String apiUrl = 'https://eliebarbar.000webhostapp.com/updateImage.php';

  try {
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.fields['json'] = jsonEncode({'id': id});
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error uploading image: $error');
  }
}

Future<void> sendMessage(Messages message) async {
  const String apiUrl = 'https://eliebarbar.000webhostapp.com/sendMessage.php';

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(message.toSend()),
  );
  print(response.body);
}

Future<List<Messages>?> loadMessages(int id) async {
  const String apiUrl = 'https://eliebarbar.000webhostapp.com/LoadMessages.php';

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({'relationId': id}),
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    List<Messages> messages =
        jsonList.map((json) => Messages.fromJson(json)).toList();
    return messages;
  } else {
    // Handle errors here
    print('Error: ${response.statusCode}');
  }
}

class MessageStream {
  final _messagesController = StreamController<List<Messages>>();
  Stream<List<Messages>> get messagesStream => _messagesController.stream;

  Future<void> loadMessages(int id) async {
    const String apiUrl =
        'https://eliebarbar.000webhostapp.com/LoadMessages.php';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'relationId': id}),
    );

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        List<Messages> messages = [];
        _messagesController.add(messages);
        return;
      }

      final List<dynamic> jsonList = jsonDecode(response.body);
      List<Messages> messages =
          jsonList.map((json) => Messages.fromJson(json)).toList();
      _messagesController.add(messages);
    } else {
      // Handle errors here
      print('Error: ${response.statusCode}');
    }
  }

  void dispose() {
    _messagesController.close();
  }
}

class SignalService {
  final _signalController = StreamController<int?>();
  Stream<int?> get signalStream => _signalController.stream;

  Future<void> roomSignalCheck(int id) async {
    const String apiUrl =
        'https://eliebarbar.000webhostapp.com/chatRoomSignalRequest.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'id': id}),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final int? signal = responseBody['signal'];
        _signalController.add(signal);
      } else {
        // Emit an error to the stream when the request fails
        _signalController.addError(response.statusCode);
      }
    } catch (error) {
      // Handle network errors
      _signalController.addError(error);
    }
  }

  void dispose() {
    _signalController.close();
  }
}

Future<void> roomSignalChangeTo1(int id) async {
  const String apiUrl =
      'https://eliebarbar.000webhostapp.com/chatRoomSignalChange1.php';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'id': id}),
    );
    print(response.body);
  } catch (error) {}
}

Future<void> roomSignalChangeTo0(int id) async {
  const String apiUrl =
      'https://eliebarbar.000webhostapp.com/chatRoomSignalChange0.php';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'id': id}),
    );
    print(response.body);
  } catch (error) {}
}

Future<void> LoadRecentChats(int id) async {
  const String apiUrl =
      'https://eliebarbar.000webhostapp.com/LoadRecentChats.php';
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'id': id}),
    );
    print(response.body);
    //List<Map<String,dynamic>> recentChats = jsonDecode(response);
  } catch (error) {
    print(error);
  }
}

class RecentChatsStream {
  final _recentChatsController = StreamController<List<RecentChatsModel>>();
  Stream<List<RecentChatsModel>> get recentChatsStream =>
      _recentChatsController.stream;

  Future<void> loadRecentChats(int id) async {
    const String apiUrl =
        'https://eliebarbar.000webhostapp.com/LoadRecentChats.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'id': id}),
      );
      print(response.body);
      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          _recentChatsController.add([]);
          return;
        }

        final List<dynamic> jsonList = jsonDecode(response.body);
        List<RecentChatsModel> recentChats =
            jsonList.map((json) => RecentChatsModel.fromJson(json)).toList();
        _recentChatsController.add(recentChats);
      } else {
        // Handle errors here
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle errors here
      print(error);
    }
  }

  void dispose() {
    _recentChatsController.close();
  }
}

class RecentChatSignal {
  final _signalController = StreamController<int?>();
  Stream<int?> get signalStream => _signalController.stream;

  Future<void> RecentChatSignalCheck(int id) async {
    const String apiUrl =
        'https://eliebarbar.000webhostapp.com/RecentChatSignalCheck.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'id': id}),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final int? signal = responseBody['signal'];
        _signalController.add(signal);
      } else {
        _signalController.addError(response.statusCode);
      }
    } catch (error) {
      _signalController.addError(error);
    }
  }

  void dispose() {
    _signalController.close();
  }
}

Future<int?> RecentChatSignalCheck(int id) async {
  const String apiUrl =
      'https://eliebarbar.000webhostapp.com/RecentChatSignalCheck.php';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'id': id}),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final int? signal = responseBody['signal'];
      return signal;
    } else {}
  } catch (error) {}
}

Future<void> RecentChatSignalChange0(int id) async {
  const String apiUrl =
      'https://eliebarbar.000webhostapp.com/RecentChatSignalChange0.php';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'id': id}),
    );
  } catch (error) {}
}

Future<void> RecentChatSignalChange1(int id) async {
  const String apiUrl =
      'https://eliebarbar.000webhostapp.com/RecentChatSignalChange1.php';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'id': id}),
    );
  } catch (error) {
    print(error);
  }
}

Future<void> MakeUnreadedMessagesReaded(int id, int relationId) async {
  const String apiUrl =
      'https://eliebarbar.000webhostapp.com/MessageTypeChange.php';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'id': id, 'relationId': relationId}),
    );
  } catch (error) {}
}
