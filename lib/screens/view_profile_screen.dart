import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:private_chat/api/api.dart';
import 'package:private_chat/helpers/dialogs.dart';
import 'package:private_chat/helpers/my_date_utils.dart';
import 'package:private_chat/screens/auth/login_screen.dart';
import 'package:private_chat/widgets/chat_user_card.dart';

import '../main.dart';
import '../models/chat_user.dart';

class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ViewProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  List<ChatUser> list = [];
  String? _image;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.user.name),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
              child: Column(
                children: [
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .03,
                  ),
                  _image != null ? ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .1),
                    child: Image.file(
                      File(_image!),
                      height: mq.height * .2,
                      width: mq.height * .2,
                      fit: BoxFit.cover,
                    ),
                  ) :
                  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .1),
                    child: CachedNetworkImage(
                      height: mq.height * .2,
                      width: mq.height * .2,
                      fit: BoxFit.cover,
                      imageUrl: widget.user.image,
                      // placeholder: (_, url) => CircularProgressIndicator(),
                      errorWidget: (_, url, error) => CircleAvatar(
                        child: Icon(CupertinoIcons.person),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .03,
                  ),
                  Text(widget.user.email,
                      style: TextStyle(color: Colors.black54, fontSize: 16)),
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('About: ',
                          style: TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.bold)),
                      Text(widget.user.about,
                          style: TextStyle(color: Colors.black54, fontSize: 15)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Joined On: ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
            Text("${MyDateUtils.getLastMessageTime(context: context, time: widget.user.createdAt, isTrue: true)}",
                style: TextStyle(color: Colors.black54, fontSize: 16))
          ],
        ),
      ),
    );
  }

}
