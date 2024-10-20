
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import 'db_services/database.dart';
import 'mainpage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController todoController =TextEditingController();
  bool suggest=false;
  bool Personal=true,College=false,Office=false;
  Stream?todostream;
  String? uid;


  @override
  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid;
    getontheLoad();

    // Show SnackBar hint for swipe-to-delete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Swipe left to delete a task"),
          duration: Duration(seconds: 3), // You can set the display time
        ),
      );
    });
  }

  getontheLoad() async {
    if (uid != null) {
      todostream = await DatabaseService().getTask(
          Personal ? "Personal" : College ? "College" : "Office", uid!);
      setState(() {});
    }
  }
  Widget getWork() {
    return StreamBuilder(
        stream: todostream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? Expanded(
            child: ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot docSnap = snapshot.data.docs[index];
                  return Dismissible(
                    key: Key(docSnap["Id"]),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: AlignmentDirectional.centerEnd,
                      child: Tooltip(
                          message: 'swipe left to delete',
                          child:Icon(Icons.delete,
                            color: Colors.white,
                          )
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Confirm Delete"),
                              content: Text(
                                  "Are you sure you want to delete this task?"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await DatabaseService().deleteTask(
                                        docSnap["Id"],
                                        Personal
                                            ? "Personal"
                                            : College
                                            ? "College"
                                            : "Office",
                                        uid!);
                                    Navigator.of(context).pop(true);
                                    getontheLoad(); // Refresh the list after deletion
                                  },
                                  child: Text("Delete"),
                                ),
                              ],
                            );
                          });
                    },
                    child: CheckboxListTile(
                      activeColor: Colors.lightGreen,
                      title: Text(
                        docSnap["work"],
                        style: TextStyle(
                          decoration: docSnap["Yes"]
                              ? TextDecoration.lineThrough
                              : null, // Optional: Strikethrough checked items
                        ),
                      ),
                      value: docSnap["Yes"], // Current checkbox value
                      onChanged: (newValue) async {
                        if (uid != null) {
                          await DatabaseService().tickMethod(
                              docSnap["Id"],
                              Personal
                                  ? "Personal"
                                  : College
                                  ? "College"
                                  : "Office",
                              uid!,
                              newValue! // Pass the new checkbox state (true or false)
                          );
                          getontheLoad(); // Refresh the stream to update the UI
                        }
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  );
                }),
          )
              : Center(child: CircularProgressIndicator());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("    TODO",style:TextStyle(color: Colors.white,fontSize: 25),)),
        actions: [
          IconButton(onPressed: ()async{
            bool shouldSignout=await showDialog(
                context: context,
                builder:(context)=>AlertDialog(
                  title:Text("Confirm Sign Out"),
                  content: Text("Are you sure you want to sign out?"),
                  actions: [
                    TextButton(onPressed:(){
                      Navigator.pop(context,false);
                    }, child:Text("Cancel")),
                    TextButton(onPressed: (){
                      Navigator.pop(context,true);
                    }, child:Text("Sign Out")
                    ),
                  ],
                )
            );
            if(shouldSignout??false){
              await FirebaseAuth.instance.signOut();
            }

          }, icon:Icon(Icons.logout,color: Colors.white,))
        ],
      ),
      floatingActionButton:FloatingActionButton(onPressed:
          (){
        openBox();
      },
        child: Icon(Icons.add,
            color: Colors.white,
            size:30),
        backgroundColor: Colors.deepPurpleAccent,
      ) ,
      body:Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        children: [
          SizedBox(height:10),
          Container(

            child: Text(   "Transform your 'to-dos' into 'ta-da's' with each tick!",style:TextStyle(color:Colors.black,
                fontSize: 20),),
          ),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Personal ? Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical:5),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child:Text("Personal",
                    style: TextStyle(
                      fontSize: 20,
                      color:Colors.black,
                      fontWeight: FontWeight.bold,
                    ),),
                ),
              ): GestureDetector(

                onTap:()async
                {
                  Personal = true;
                  College=false;
                  Office=false;
                  await getontheLoad();
                  setState(() {

                  });
                },
                child: Text("Personal", style:TextStyle(
                  fontSize:20,
                )),
              ),
              College ? Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical:5),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child:Text("College",
                    style: TextStyle(
                      fontSize: 20,
                      color:Colors.black,
                      fontWeight: FontWeight.bold,
                    ),),
                ),
              ): GestureDetector(
                onTap:()async
                {
                  Personal =false;
                  College=true;
                  Office=false;
                  await getontheLoad();
                  setState(() {

                  });
                },
                child: Text("College", style:TextStyle(
                  fontSize:20,
                )),
              ),
              Office ? Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical:5),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child:Text("Office",
                    style: TextStyle(
                      fontSize: 20,
                      color:Colors.black,
                      fontWeight: FontWeight.bold,
                    ),),
                ),
              ): GestureDetector(
                onTap:()async
                {
                  Personal = false;
                  College=false;
                  Office=true;
                  await getontheLoad();
                  setState(() {

                  });
                },
                child: Text("Office", style:TextStyle(
                  fontSize:20,
                )),
              ),


            ],
          ),
          SizedBox(height:8),

          getWork(),
        ],


      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'TODO',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Notes',
          ),
        ],
        onTap: (int index) {
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Mainpage()));
          } else {
          }
        },
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.blueGrey.shade50,
        elevation: 10,
      ),


    );
  }
  Future openBox(){
    return showDialog(context: context,
        builder:(context)=>AlertDialog(
          content: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },child: Icon(Icons.cancel_outlined),
                      ),
                      SizedBox(width: 60,),
                      Text("Add ToDo Task", style:TextStyle(
                        color:Colors.green,
                      )),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Text("Add Task"),
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        )
                    ),
                    child: TextField(

                      controller:todoController,
                      decoration:InputDecoration(
                        border: InputBorder.none,
                        hintText:"Enter the Task",
                      ) ,

                    ),

                  ),
                  SizedBox(height: 20,),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius:BorderRadius.circular(10)
                      ),
                      child:GestureDetector(
                        onTap: (){
                          String id=randomAlphaNumeric(10);
                          Map<String,dynamic>userTodo={
                            "work":todoController.text,
                            "Id":id,
                            "Yes":false,
                          };
                          if(uid !=null) {
                            Personal ? DatabaseService().addPersonalTask(
                                userTodo, id, uid!) : College ? DatabaseService()
                                .addCollegeTask(userTodo, id, uid!) : DatabaseService()
                                .addOfficeTask(userTodo, id, uid!);
                          } todoController.clear();
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text("ADD",
                            style: TextStyle(color: Colors.black),),
                        ),
                      ) ,
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
