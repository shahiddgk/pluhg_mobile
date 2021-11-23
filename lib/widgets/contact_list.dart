// import 'dart:typed_data';

import 'package:flutter/material.dart';

Widget contactList(
    String name, String contact, Widget image, Function load, String status) {
  return GestureDetector(
    onTap: () => load(),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              image,
              SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  Text(
                    contact,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(),
      ],
    ),
  );
}
