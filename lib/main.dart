import 'dart:convert';
import 'package:chat/models/user_model.dart';
import 'package:chat/whatsapp_home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';
import 'common.dart';
import 'db/db.dart';
import 'globals.dart' as globals;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("app_settings");
  runApp(new MyApp());
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlobalValues(
          child: new MaterialApp(
        title: "WhatsApp",
        theme: new ThemeData(
            primaryColor: new Color(0Xff075E54),
            accentColor: new Color(0Xff25D366),
            primaryColorLight: new Color(0XffDCF8C6)),
        
        home: new MyHomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController user = new TextEditingController();
  TextEditingController pass = new TextEditingController();

  String msg = '';

  Future<List> _login() async {
    final response = await http.post(GlobalConfiguration().getString("apiUrl")+"/login", body: {
      "userName": user.text,
      "password": pass.text,
    });

    var datauser = json.decode(response.body);
 
    if (datauser.length == 0) {
      setState(() {
        msg = "Login Fail";
      });
    } else {      
      var currentUser = new UserModel(
        userId: datauser[0]['UserId'],
        name: datauser[0]['userName'],
        isCurrentUser: 1,
        userType: 'customer');
        globals.isLoggedIn=true;
        globals.currentUser = currentUser;
      DBProvider.db.addUser(currentUser).then((data){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WhatsAppHome()));    
      });  
    }

    return datauser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                "Username",
                style: TextStyle(fontSize: 18.0),
              ),
              TextField(
                controller: user,
                decoration: InputDecoration(hintText: 'Username'),
              ),
              Text(
                "Password",
                style: TextStyle(fontSize: 18.0),
              ),
              TextField(
                controller: pass,
                obscureText: true,
                decoration: InputDecoration(hintText: 'Password'),
              ),
              RaisedButton(
                child: Text("Login"),
                onPressed: () {
                  _login();
                },
              ),
              Text(
                msg,
                style: TextStyle(fontSize: 20.0, color: Colors.red),
              )
            ],
          ),
        ),
      ),
    );
  }
}
