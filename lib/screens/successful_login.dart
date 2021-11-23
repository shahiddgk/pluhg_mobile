import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plug/widgets/colours.dart';


class SuccessfulScreen extends StatelessWidget {
  const SuccessfulScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: size.height * 0.11),
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              "resources/svg/successful.svg",
              height: MediaQuery.of(context).size.height * 0.34,
            ),
          ),
          Text(
            'Successful',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: pluhgColour,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5),
            child: Text(
              'Your phone number has been successfully verified. Proceed to login.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Spacer(),
          InkWell(
            onTap: () {
              // Navigator.of(context).push(
              //     MaterialPageRoute(builder: (ctx) => SuccessfulLoginScreen()));
            },
            child: Container(
              width: size.width * 0.70,
              height: 45,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(22.5),
              ),
              child: Center(
                child: Text(
                  'Log In',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 14),
        ],
      ),
    );
  }
}
