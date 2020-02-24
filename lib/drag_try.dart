import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DragTry extends StatefulWidget {
  @override
  createState() => _DragTryState();
}

class _DragTryState extends State<DragTry> {

  final _firestore = Firestore.instance;

  final List notAcknowledged = ['problem1', 'problem2', 'problem3'];
  final List acknowledged = [];
  final List completed = [];

  void getMessages() async {
    await for(var data in _firestore.collection('users').snapshots()){
      for(var message in data.documents){
        print(message.data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Draggable"),
        backgroundColor: Colors.black,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(70.0,110.0,70.0,110.0),
            height: 500.0,
            width: 292.0,
            child: Card(
              color: Color(0xffE5F2F1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    //height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: notAcknowledged.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Draggable(
                          child: Container(
                            child: Text('${notAcknowledged[index]}'),
                            padding: EdgeInsets.all(20.0),
                          ),
                          feedback: Material(
                            elevation: 5.0,
                            child: Container(
                              width: 284.0,
                              padding: const EdgeInsets.all(16.0),
                              color: Colors.yellow,
                              child: Text(notAcknowledged[index]),
                            ),
                          ),
                          childWhenDragging: Container(),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(70.0,110.0,70.0,110.0),
            width: 292.0,
            height: 500.0,
            child: Card(
              color: Color(0xffE5F2F1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 470,
                    child: DragTarget(
                      builder: (context, candidateData, rejectedData) {
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: acknowledged.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Container(
                              child: Text('${acknowledged[index]}'),
                              margin: EdgeInsets.all(10.0),
                              color: Colors.white,
                              padding: EdgeInsets.all(10.0),
                            );
                          },
                        );
                      },
                      onAccept: (data) {
                        acknowledged.add('${notAcknowledged[0]}');
                        notAcknowledged.removeAt(0);
                        setState((){
                          getMessages();
                        });
                        print("hello");
                        return null;
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(70.0,110.0,70.0,110.0),
            width: 292.0,
            height: 500.0,
            child: Card(
              color: Color(0xffE5F2F1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 470,
                    child: DragTarget(
                      builder: (context, candidateData, rejectedData) {
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: acknowledged.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Container(
                              child: Draggable(
                                child: Text('${acknowledged[index]}'),
                                feedback: Material(
                                  elevation: 5.0,
                                  child: Container(
                                    width: 284.0,
                                    padding: const EdgeInsets.all(16.0),
                                    color: Colors.yellow,
                                    child: Text('${acknowledged[index]}'),
                                  ),
                                ),
                              ),
                              margin: EdgeInsets.all(10.0),
                              color: Colors.white,
                              padding: EdgeInsets.all(10.0),
                            );
                          },
                        );
                      },
                      onAccept: (data) {
                        acknowledged.add('${notAcknowledged[0]}');
                        notAcknowledged.removeAt(0);
                        setState((){
                          getMessages();
                        });
                        print("hello");
                        return null;
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
