import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:plug/app/data/app_exceptions.dart';

import '../../constants/app_constants.dart';
import '../modules/auth_screen/views/auth_screen_view.dart';
import '../services/UserState.dart';
import '../values/strings.dart';
import '../widgets/snack_bar.dart';
import 'models/general_response_model.dart';

String MESSAGE_KEY = 'message';

var head = {"Content-Type": "application/json"};

class ResponseHandler {
  Future<GeneralResponseModel> post(String url, Map<String, dynamic> params,
      {String token = ""}) async {
    var uri = Uri.parse(url);
    if (token.isNotEmpty) {
      head['Authorization'] = 'Bearer $token';
    } else {
      User user = await UserState.get();
      if (user.token.isNotEmpty) {
        print('usertoken: ${user.token}');
        head['Authorization'] = 'Bearer ${user.token}';
      }
    }

    var responseJson;
    try {
      final response =
          await http.post(uri, body: jsonEncode(params), headers: head);
      responseJson = json.decode(response.body.toString());
      print(responseJson);
      return parseResponse(response.statusCode, responseJson);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<GeneralResponseModel> postWithImage(
      String url, Map<String, String> params, var imageFile) async {
    var head = Map<String, String>();
    head['content-type'] = 'application/x-www-form-urlencoded';
    User user = await UserState.get();
    if (user.token.isNotEmpty) {
      head['Authorization'] = 'Bearer ${user.token}';
    }
    var res;
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      if (imageFile != null) {
        var stream = http.ByteStream(imageFile.openRead());
        stream.cast();
        var length = await imageFile.length();
        request.files.add(http.MultipartFile('profileImage', stream, length,
            filename: basename(imageFile.path),
            contentType: MediaType('image', 'png')));
      }
      request.fields.addAll(params);
      request.headers.addAll(head);
      var response = await request
          .send()
          .timeout(AppConstants.API_TIME_OUT_EXCEPTION, onTimeout: () {
        pluhgSnackBar('Sorry', '$TIME_OUT_EXCEPTION');
        throw '';
      });

      response.stream.transform(utf8.decoder).listen((var value) async {
        response.stream.transform(utf8.decoder);
      });
      res = GeneralResponseModel(
        status: response.statusCode == 200,
        message: response.statusCode == 200
            ? "You have changed your profile details"
            : response.reasonPhrase.toString(),
      );
      if (!res.status!) throw FetchDataException(res.message);
      return res;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<GeneralResponseModel> get(String url) async {
    var uri = Uri.parse(url);
    User user = await UserState.get();
    if (user.token.isNotEmpty) {
      print('usertoken: ${user.token}');
      head['Authorization'] = 'Bearer ${user.token}';
    }
    var responseJson;
    try {
      final response = await http.get(uri, headers: head);
      responseJson = json.decode(response.body.toString());
      print(responseJson);
      return parseResponse(response.statusCode, responseJson);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  GeneralResponseModel parseResponse(
      int statusCode, Map<String, dynamic> response) {
    try {
      var res = GeneralResponseModel.fromJson(response);
      if (statusCode != 200) {
        throw FetchDataException(res.message);
      }
      if (statusCode == 401) {
        Get.offAll(() {
          print("[Api:getProfile] force user logout");
          UserState.logout().then((value) => AuthScreenView());
        });
      }
      if (!res.status!) throw FetchDataException(res.message);
      return res;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }
}
