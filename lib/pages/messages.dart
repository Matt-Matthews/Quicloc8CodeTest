// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final List<Color> msgColor = <Color>[];
  List msgs = [];
  var random = Random();
  void addMsgColors() {
    //add random colors to a list of colors
    msgColor.add(Colors.green);
    msgColor.add(Colors.redAccent);
    msgColor.add(Colors.blueAccent);
    msgColor.add(Colors.orangeAccent);
    msgColor.add(Colors.greenAccent);
    msgColor.add(Colors.blue);
    msgColor.add(Colors.orange);
  }

  Future<String> getMsgs() async {
    //get mesages data from json file
    var msgData = await rootBundle.loadString('lib/assets/messages.json');

    setState(() {
      msgs = json.decode(msgData);
    });

    print(msgs);
    return 'done..';
  }

  @override
  void initState() {
    super.initState();
    addMsgColors();
    getMsgs();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData _mediaQueryData = MediaQuery.of(context);
    final _screenWidth = _mediaQueryData.size.width;
    final _screenHeight = _mediaQueryData.size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: ListView.builder(
          itemCount: msgs.length,
          itemBuilder: (BuildContext context, int index) {
            return Material(
                elevation: 8,
                child: Container(
                  width: _screenWidth * 0.8,
                  height: _screenHeight * 0.1,
                  margin: EdgeInsets.only(
                      top: 2,
                      bottom: 2,
                      left: _screenWidth * 0.015,
                      right: _screenWidth * 0.015),
                  padding: EdgeInsets.only(left: _screenWidth * 0.02),
                  color: Colors.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            child: Text(
                              msgs[index]["subject"][0],
                              style: TextStyle(
                                  fontSize: _screenWidth *
                                      0.05, //display font size according to the width of the screen
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            radius: _screenHeight * 0.035,
                            backgroundColor: msgColor[random.nextInt(
                                7)], //display random colors from the list of colors.
                          ),
                          SizedBox(
                            width: _screenWidth * 0.04,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: _screenWidth * 0.65,
                                  child: Text(
                                    msgs[index]["subject"],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: _screenWidth * 0.045,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  )),
                              SizedBox(
                                height: _screenHeight * 0.005,
                              ),
                              SizedBox(
                                width: _screenWidth * 0.65,
                                child: Text(
                                  msgs[index]["message"],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: _screenWidth * 0.04,
                                      color: Colors.grey),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            msgs[index]["display"],
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: _screenWidth * 0.032),
                          ),
                          SizedBox(
                            height: _screenHeight * 0.002,
                          ),
                          GestureDetector(
                            child: msgs[index]["favourate"] == true
                                ? Icon(Icons.star,
                                    color:
                                        Theme.of(context).colorScheme.primary)
                                : const Icon(Icons.star_outline,
                                    color: Colors.grey),
                            onTap: () {
                              if (msgs[index]["favourate"] != true) {
                                setState(() {
                                  msgs[index]["favourate"] = true;
                                });
                              } else {
                                setState(() {
                                  msgs[index]["favourate"] = false;
                                });
                              }
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ));
          }),
    );
  }
}
