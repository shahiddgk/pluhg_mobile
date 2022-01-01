
/*

Widget recieverMessage(
    {required BuildContext context,
    required String message,
    required String time,
    required String img}) {
  Size size = MediaQuery.of(context).size;
  return Row(
    children: [
      Container(

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [BoxShadow(color: Colors.white)],
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: CircleAvatar(
          radius: 40.w,
          backgroundImage: NetworkImage(img),
        ),
      ),
      SizedBox(
        width: 10.w,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: size.width * 0.6,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(21),
                    bottomLeft: Radius.circular(21),
                    bottomRight: Radius.circular(20))),
            child: Text(
              message,
              style: body2TextStyle,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            time,
            style: body4TextStyle,
          )
        ],
      )
    ],
  );
}

Widget myMessage({
  required BuildContext context,
  required String message,
  required String time,
}) {
  Size size = MediaQuery.of(context).size;
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: size.width * 0.5,
            decoration: BoxDecoration(
                color: Color(0xff000BFF),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(21),
                    bottomLeft: Radius.circular(21),
                    bottomRight: Radius.circular(0))),
            child: Text(
              message,
              style: body2TextStyleWhite,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            time,
            style: body4TextStyle,
          )
        ],
      )
    ],
  );
}
*/