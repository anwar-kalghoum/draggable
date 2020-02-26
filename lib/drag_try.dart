import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fireBase;

class DragTry extends StatefulWidget {
  @override
  createState() => _DragTryState();
}

class _DragTryState extends State<DragTry> {

  var _firestore = fireBase.firestore();
  final List notAcknowledged = ['problem1'];
  final List acknowledged = [];
  final List completed = [];
  var acknowledgedData1, acknowledgedData2;
  var dragStatus;

//  void getData() async{
//    final messages = await _firestore.collection('users').getDocuments();
//    for(var message in messages.documents){
//      notAcknowledged.add(message.data['displayName']);
//    }
//  }

//  getData() async{
//    var data1 = await _firestore.collection('users').get();
//    for(var i=0; i<data1.size;i++){
//      //print(data1.docs[i].get('description'));
//      notAcknowledged.add(data1.docs[i].get('displayName'));
//      print(data1.docs[i].get('displayName'));
//      print(notAcknowledged);
//    }
//    print(data1.getString())
//  }

  @override
  void initState() {
    super.initState();
    getData();
  }

//  void getMessages() async{
//    await for(var data in _firestore.collection('users').snapshots()){
//      for(var message in data.documents){
//        print(message.data);
//        notAcknowledged.add(message.data);
//      }
//    }
//  }

  Future getData() async{
    var data1 = await _firestore.collection('users').get();
    for(var i=0; i<data1.size;i++){
      //print(data1.docs[i].get('displayName'));
      notAcknowledged.add(data1.docs[i].get('displayName'));
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
                          onDragStarted: (){
                            acknowledgedData1 = notAcknowledged[index];
                            dragStatus = 'notAcknowledged';
                          },
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
                              return Draggable(
                                child: Container(
                                  child: Text('${acknowledged[index]}'),
                                  margin: EdgeInsets.all(10.0),
                                  color: Colors.white,
                                  padding: EdgeInsets.all(10.0),
                                ),
                                feedback: Material(
                                  elevation: 5.0,
                                  child: Container(
                                    width: 284.0,
                                    padding: const EdgeInsets.all(16.0),
                                    color: Colors.yellow,
                                    child: Text('${acknowledged[index]}'),
                                  ),
                                ),
                                onDragStarted: (){
                                  acknowledgedData2 = acknowledged[index];
                                  dragStatus = 'acknowledged';
                                },
                              );
                            },
                          );
                        },
                        onAccept: (data) {
                          acknowledged.add(acknowledgedData1);
                          notAcknowledged.remove(acknowledgedData1);
                          setState((){});
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
                          itemCount: completed.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Container(
                              child: Text('${completed[index]}'),
                              margin: EdgeInsets.all(10.0),
                              color: Colors.white,
                              padding: EdgeInsets.all(10.0),
                            );
                          },
                        );
                      },
                      onAccept: (data) {
                        if(dragStatus=='notAcknowledged'){
                          completed.add(acknowledgedData1);
                          notAcknowledged.remove(acknowledgedData1);
                        }
                        else{
                          completed.add(acknowledgedData2);
                          acknowledged.remove(acknowledgedData2);
                        }
                        setState((){});
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
