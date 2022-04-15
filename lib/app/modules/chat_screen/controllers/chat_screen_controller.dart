import 'package:get/get.dart';
import 'package:plug/app/data/api_calls.dart';
import 'package:plug/app/services/UserState.dart';
import 'package:plug/widgets/models/user_chat.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreenController extends GetxController {
  //TODO: Implement ChatScreenController
  late IO.Socket socket;

  RxList users = [].obs;
  List<UserChat> usersTemp = [];

  final size = Get.size;
  String? userID;
  final count = 0.obs;
  int total_unread_messages = 0;
  RxString search = "".obs;

  @override
  void onInit() {
    super.onInit();
    connect();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void connect() async {
    User user = await UserState.get();
    userID = user.id;
    socket = IO.io(APICALLS.ws_url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    //Connect websockets
    socket.connect();

    // if the web socket is connected
    socket.onConnect((data) {
      print("[Socket:onConnect] run");
      getMessages(userID.toString());
    });

    socket.onConnectError((data) {
      print("[Socket:onConnectError] data: ${data.toString()}");
    });
  }

  void getMessages(String userId) {
    print("[ChatScreenController:getMessages] for $userId");

    socket.emit('getMessageListing', {'userId': userId});
    socket.on('getListingResponse', (data) {
      print("[ChatScreenController:getMessages] getListingResponse ${data.toString()}");
      var chatsArr = data['data'];

      users.value = List<UserChat>.from(chatsArr.map((dynamic message) => UserChat.fromJson(message)).toList());

      for (UserChat user in users) {
        total_unread_messages = total_unread_messages + user.unReadCount;
      }

      usersTemp = List<UserChat>.from(users.value);
    });
  }

  searchMessages(String name) {
    if (name.isEmpty) {
      users.value = usersTemp;
    } else {
      users.value = usersTemp.where((element) => element.name!.toLowerCase().contains(name.toLowerCase())).toList();
    }
  }
}
