import 'dart:developer';

import 'package:available/available.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:private_chat/api/api.dart';
import 'package:private_chat/helpers/dialogs.dart';
import 'package:private_chat/helpers/my_date_utils.dart';
import 'package:private_chat/models/message.dart';

import '../main.dart';

class MessageCard extends StatefulWidget {
  final Message message;

  const MessageCard({Key? key, required this.message}) : super(key: key);

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.authUser.uid == widget.message.fromID;
    return InkWell(
      onLongPress: () {
        _showBottomSheet(isMe);
      },
      child: isMe ? _greenMessage() : _blueMessage(),
    );
  }

  //Left Side Message
  Widget _blueMessage() {
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            padding: widget.message.type == Type.text
                ? EdgeInsets.all(mq.width * .04)
                : EdgeInsets.all(mq.width * .03),
            decoration: BoxDecoration(
                color: Colors.lightBlue.withOpacity(0.1),
                border: Border.all(color: Colors.lightBlue),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )),
            child: widget.message.type == Type.text
                ? Text(widget.message.msg)
                : ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: widget.message.msg,
                placeholder: (_, url) =>
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                errorWidget: (_, url, error) =>
                    CircleAvatar(
                      child: Icon(Icons.image, size: 70),
                    ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04),
          child: Text(
            MyDateUtils.getFormatted(
                context: context, time: widget.message.sent),
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
        )
      ],
    );
  }

  // Right Side Message
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(width: mq.width * .04),
            if (widget.message.read.isNotEmpty)
              Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
                size: 20,
              ),
            SizedBox(width: 2),
            Text(
              MyDateUtils.getFormatted(
                  context: context, time: widget.message.sent),
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            padding: widget.message.type == Type.text
                ? EdgeInsets.all(mq.width * .04)
                : EdgeInsets.all(mq.width * .03),
            decoration: BoxDecoration(
                color: Colors.lightGreen.withOpacity(0.3),
                border: Border.all(color: Colors.lightGreen),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                )),
            child: widget.message.type == Type.text
                ? Text(widget.message.msg)
                : ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: widget.message.msg,
                placeholder: (_, url) =>
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                errorWidget: (_, url, error) =>
                    CircleAvatar(
                      child: Icon(Icons.image, size: 70),
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: mq.height * .015, horizontal: mq.width * .4),
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(12)),
              ),
              widget.message.type == Type.text
                  ? _optionItem(
                  icon: Icon(
                    Icons.copy_all_rounded,
                    color: Colors.blue,
                    size: 26,
                  ),
                  text: 'Copy Text',
                  onTap: () async {
                    await Clipboard.setData(
                        ClipboardData(text: widget.message.msg))
                        .then((value) async {
                      Navigator.pop(context);
                      if (await available(android: OSRequirement(max: 12)))
                        Dialogs.showSnackbar(context, 'Text Copied!');
                    });
                  }) : Container(),
              // : _optionItem(
              //     icon: Icon(
              //       Icons.save,
              //       color: Colors.blue,
              //       size: 26,
              //     ),
              //     text: 'Save Image',
              //     onTap: () async {
              //       try {
              //         log('message: ${widget.message.msg}');
              //         await ImageGallerySaver.saveFile(widget.message.msg)
              //             .then((success) {
              //           Navigator.pop(context);
              //           if (success != null)
              //             Dialogs.showSnackbar(
              //                 context, 'Image Successfully Saved!');
              //         });
              //       } catch (e) {
              //         log('ErrorWhileSavingImage: $e');
              //       }
              //     }),
              // Divider(
              //   color: Colors.black54,
              //   endIndent: mq.width * .04,
              //   indent: mq.width * .04,
              // ),
              if (widget.message.type == Type.text && isMe)
                _optionItem(
                    icon: Icon(
                      Icons.edit,
                      size: 26,
                      color: Colors.blue,
                    ),
                    text: 'Edit Message',
                    onTap: () {}),
              if (isMe)
                _optionItem(
                    icon: Icon(Icons.delete_forever_rounded,
                        color: Colors.red, size: 26),
                    text: 'Delete Message',
                    onTap: () async {
                      await APIs.deleteMessage(widget.message).then((value) {
                        Navigator.pop(context);
                        Dialogs.showSnackbar(context, 'Message Deleted!');
                      });
                    }),
              if (isMe)
                Divider(
                  color: Colors.black54,
                  endIndent: mq.width * .04,
                  indent: mq.width * .04,
                ),
              _optionItem(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.blue,
                  ),
                  text:
                  'Sent At: ${MyDateUtils.getMessageTime(
                      context: context, time: widget.message.sent)}',
                  onTap: () {}),
              _optionItem(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.green,
                  ),
                  text: widget.message.read.isEmpty
                      ? 'Read At: Not seen yet'
                      : 'Read At: ${MyDateUtils.getMessageTime(
                      context: context, time: widget.message.read)}',
                  onTap: () {}),
            ],
          );
        });
  }

  Widget _optionItem(
      {required Icon icon, required String text, required VoidCallback onTap}) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.only(
            left: mq.width * .05,
            top: mq.height * .015,
            bottom: mq.height * .02),
        child: Row(
          children: [
            icon,
            SizedBox(
              width: 18,
            ),
            Text(text)
          ],
        ),
      ),
    );
  }
}
