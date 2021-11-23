import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

void launchURL(String url) async => await canLaunch(url)
    ? await launch(url)
    : Get.snackbar("So sorry", "Could not launch $url");
