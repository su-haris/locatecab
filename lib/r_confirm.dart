import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:locatecab/host_view.dart';
import 'package:locatecab/receiver_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'hostdetails.dart';
import 'package:local_notifications/local_notifications.dart';

class ConfirmReceiver extends StatefulWidget {
  String userId;
  String email;
  ConfirmReceiver({Key key, @required this.userId,@required this.email}) : super(key: key);
  @override
  _ConfirmReceiverState createState() => _ConfirmReceiverState(userId);
}

class _ConfirmReceiverState extends State<ConfirmReceiver> {

  String receiverStatus, acceptedHost;
  int i=0;
  String userId;
  _ConfirmReceiverState(this.userId);

  final databaseReference = FirebaseDatabase.instance.reference();




  @override
  Future initState() {
    super.initState();

    const AndroidNotificationChannel channel = const AndroidNotificationChannel(
        id: 'default_notification',
        name: 'Default',
        description: 'Grant this app the ability to show notifications',
        importance: AndroidNotificationChannelImportance.HIGH
    );

    LocalNotifications.createAndroidNotificationChannel(channel: channel);


    databaseReference.child("receiver").child(userId).child('receiver_status').onValue.listen((Event status) async {
      print(status.snapshot.value.toString());
      setState(() {
        receiverStatus = status.snapshot.value.toString();

      });
      if (acceptedHost!=null) {
        await LocalNotifications.createNotification(
            title: "Host Available",
            content: "You have been accepted by a host. Click to view Host details.",
            id: 0,
            androidSettings: new AndroidSettings(
                channel: channel
            ));
      }
    });

    databaseReference.child("receiver").child(userId).child('accepted_host').onValue.listen((Event status){
      print(status.snapshot.value.toString());
      setState(() {
        acceptedHost = status.snapshot.value.toString();
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:acceptedHost!="null"?(){}:() async {
        await databaseReference.child('receiver').child(userId).remove();
        SharedPreferences prefs= await SharedPreferences.getInstance();

        await prefs.remove(widget.email);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ReceiverView()));
      },
      child: Scaffold(

        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.orangeAccent,
          centerTitle: true,
          elevation: 0.0,
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
                child: new Text(
                  "Your Location is now live!",
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(50),
                child: new Text(
                  receiverStatus,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: new Image.asset('assets/images/movingcar.gif',
                    alignment: Alignment.center),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 35.0),
                child: Container(
                  width: 250.0,
                  height: 45.0,
                  child: RaisedButton(
                    onPressed: acceptedHost != "null"? ()=>
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HostDetails(acceptedHost,widget.email)),
                      ):null
                    ,
                    splashColor: Colors.red.withAlpha(700),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(70.0)),
                    color: Colors.orangeAccent.withAlpha(700),
                    child: Text(
                      "Get Host Details",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
