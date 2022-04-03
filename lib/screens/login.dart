import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/database/email.dart';
import 'package:untitled/screens/mainpage.dart';



import 'register.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  static Future<User?> loginUsingEmailPassword({required String email, required String password, required BuildContext context}) async{
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try{
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
    }on FirebaseAuthException catch(e){
      if(e.code == "user-not-found"){
        print("No user");
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passController = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40,),
                Text(
                  '           Welcome Dude \n       Login to your Account',
                  style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 150.0,
                ),

                TextField(
                  controller: _emailController,
                  maxLengthEnforced: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    suffixIcon: TextButton(
                      child: Text("Send OTP"),
                      onPressed: (){

                      },
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),

                  ),


                ),


                SizedBox(
                  height: 40.0,
                ),
                TextField(
                  controller: _passController,
                  maxLengthEnforced: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                ),


                SizedBox(
                  height: 50.0,
                ),

                Center(child: MaterialButton(
                    onPressed: () async {
                      User? user = await loginUsingEmailPassword(email: _emailController.text, password: _passController.text, context: context);
                      Email.text = _emailController.text;
                      print(user);
                      _emailController.clear();
                      _passController.clear();
                      if(user != null){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
                      }
                    },
                    child: Text('Log in'),
                  textColor: Colors.white,
                    color: Colors.red,
                  hoverColor: Colors.black,
                  minWidth: double.infinity,
                  height: 44.0,
                )),


                SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('New here?'),
                    GestureDetector(
                      child: Text(
                        'Click here to signup',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder:(context)=> Registration(),
                        ));
                      },
                    )
                  ],
                )


              ],
            ),
          ),
        ),
      ),
    );
  }
}
