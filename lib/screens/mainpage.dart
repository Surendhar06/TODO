import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/database/db.dart';

import 'package:untitled/database/email.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({key}) : super(key: key);

  @override
  _homeScreenState createState() => _homeScreenState();
}

class _homeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  List<TaskModel> tasks = [];
  List<TaskModel> list = [];
  late TaskModel currentTask;
  bool _validate = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose(){
    _nameController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Todohelper _todoHelper = Todohelper();

    void getData() async{
      List<TaskModel> list = await _todoHelper.getAllTask();
      setState(() {
        tasks = list;
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Center(child: Text("Todo App",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26,color: Colors.black),)),

              ),
        drawer: Drawer(
          child: new ListView(
              children: <Widget>[
new UserAccountsDrawerHeader(
          accountName: Text('Todo App',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
          accountEmail: Text('todo@gmail.com'),

          decoration: new BoxDecoration(
              color: Colors.green
          ),
        ),
                InkWell(
                  onTap: (){ Navigator.push(context, MaterialPageRoute(
                    builder:(context)=> HomeScreen(),
                  )); },

                  child: ListTile(
                    title: Text('Home Page'),
                    leading: Icon(Icons.home),
                  ),
                ),

  ]
          ),
        ),
        body: SafeArea(
          child: Container(
            color: Colors.white10,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
SizedBox(height: 20,),

                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                     labelText: 'Enter task',
                      errorText: _validate ? 'Value Can\'t Be Empty' : null,
                      border: OutlineInputBorder()),
                ),
                SizedBox(height: 16.0,),
                TextField(
                  controller: _bodyController,
                  decoration: InputDecoration(
                      labelText: 'Enter body',
                      errorText: _validate ? 'Value Can\'t Be Empty' : null,
                      border: OutlineInputBorder()),
                ),

SizedBox(height: 25,),

                Row(
                  children: [
                    SizedBox(width: 20,),
                    RaisedButton(onPressed: (){
                      setState(() {
                        _nameController.text.isEmpty ? _validate = true : _validate = false;
                      });
                      currentTask = TaskModel(taskTitle: _nameController.text, id: 2, taskBody: _bodyController.text, taskDate: DateTime.now().toIso8601String());
                      if(_validate) return;
                      else _todoHelper.insertTask(currentTask);
                      _nameController.clear();
                      _bodyController.clear();
                      getData();
                    }, child: Text('Insert'),color: Colors.tealAccent,),
                      SizedBox(width: 20,),

                    RaisedButton(onPressed: () async{
                      getData();
                    }, child: Text('Display'),color: Colors.green,),
                       SizedBox(width: 20,),

                    RaisedButton(onPressed: (){
                      _todoHelper.deleteAllTask();
                      getData();
                    }, child: Text('Clear'),color: Colors.blueAccent),
                  ],
                ),
SizedBox(height: 20,),
Text('Content : ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.black)),
                SizedBox(height: 10,),
                Expanded(
                    child:Card(

                      elevation: 10.0,
                      child: ListView.separated(
                          itemBuilder: (context,index){
                            return ListTile(
                              tileColor: Colors.white10,
                              leading: Text("${index+1}"),
                              title: Column(children: [
                                Text("${tasks[index].taskTitle}",style: TextStyle(fontWeight: FontWeight.bold),),
                                Text("${tasks[index].taskBody}"),
                              ],),
                              subtitle: Text("${tasks[index].taskDate}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green),),

                              trailing: GestureDetector(child: Icon(Icons.delete),onTap: (){
                                _todoHelper.deleteTask(tasks[index].id);
                                getData();
                              },),
                            );
                          },
                          separatorBuilder: (context, index) => Divider(),
                          itemCount: tasks.length),
                    ))
              ],
            ),
          ),

        ),
            floatingActionButton: FloatingActionButton(onPressed: () {
              FirebaseAuth.instance.signOut();
              setState(() {
                Email.text = '';
              });
              Navigator.pop(context);
            },child: Icon(Icons.logout),),
    );
  }
}
