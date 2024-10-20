import 'package:flutter/material.dart';
import 'functions/authfunction.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final _formkey = GlobalKey<FormState>();
  bool isLogin = true; // Set to true for the login page to be shown first
  String email = " ";
  String password = " ";
  String username = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Center(
          child: Text(
            "Welcome",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
      body: Form(
        key: _formkey,
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              !isLogin
                  ? TextFormField(
                key: ValueKey('Username'),
                decoration: InputDecoration(hintText: "Enter Username"),
                validator: (value) {
                  if (value.toString().length < 3) {
                    return 'Username is too short';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  setState(() {
                    username = value!;
                  });
                },
              )
                  : Container(),
              TextFormField(
                key: ValueKey('email'),
                decoration: InputDecoration(hintText: "Enter email"),
                validator: (value) {
                  if (!(value.toString().contains("@"))) {
                    return 'Invalid email';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  setState(() {
                    email = value!;
                  });
                },
              ),
              TextFormField(
                obscureText: true,
                key: ValueKey('Password'),
                decoration: InputDecoration(hintText: "Password"),
                validator: (value) {
                  if (value.toString().length < 6) {
                    return 'Password is too short';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  setState(() {
                    password = value!;
                  });
                },
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      _formkey.currentState!.save();
                      isLogin
                          ? signin(context, email, password)
                          : signup(context, email, password);
                    }
                  },
                  child: isLogin ? Text("Login") : Text("Signup"),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin; // Toggle between login and signup
                  });
                },
                child: isLogin
                    ? Text("Don't have an account? Signup")
                    : Text("Already signed up? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
