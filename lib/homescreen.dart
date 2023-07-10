import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/addnote.dart';
import 'package:todo_list_app/note.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);



  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {



  final ref = FirebaseDatabase.instance.ref('Note');
  final searchFilter = TextEditingController();
  final edittitleController = TextEditingController();
  final editdescriptionController = TextEditingController();
  bool isChecked = false;

  late final _tabController = TabController(length: 2, vsync: this);

  // static const List<Tab> myTabs = <Tab>[
  //   Tab(text: 'My Tasks',),
  //   Tab(text: 'Completed Tasks'),
  // ];


  @override

  void initState(){
    super.initState();

    // ref.onValue.listen((event) {
    //
    // });
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(

        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Todo List'),
          centerTitle: true,

          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 5,
            tabs: [
              Tab(icon: Icon(Icons.list_alt),text: 'My List',),
              Tab(icon: Icon(Icons.check_box),text: 'Completed List',)
            ],
          ),

        ),
        //resizeToAvoidBottomInset: true,
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[



            MyList(),
            // Expanded(
            //   child: FirebaseAnimatedList(
            //       query: ref,
            //       defaultChild: Text('Loading',style: TextStyle(color: Colors.white,fontSize: 34,fontWeight: FontWeight.bold),),
            //       itemBuilder: (context, snapshot, animation, index){
            //
            //         // final id = '1312';
            //         // final title = 'sasad';
            //         // final description = 'assax';
            //
            //
            //
            //
            //           return compList(id, description, title);
            //
            //
            //       }
            //   ),
            // ),
            CompletedList(),

    ],
          ),
        floatingActionButton: FloatingActionButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddNote()));
        },
          child: Icon(Icons.add),
        ),



      ),
    );
  }
  Future<void> showMyDialog(String title, String description, String id) async{
    edittitleController.text = title;
    editdescriptionController.text = description;
    return showDialog(
        context: context,
        builder : (BuildContext context){
          return Expanded(
            child: AlertDialog(
              title: Text('Update'),
              content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                  TextField(
                    maxLines: 2,
                      controller: edittitleController,
                      decoration: InputDecoration(
                        hintText: 'Enter title here...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 5,),
                    TextField(
                      maxLines: 15,
                      controller: editdescriptionController,
                      decoration: InputDecoration(
                        hintText: 'Enter description here...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),


              actions: [
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);

                    }, child: Text('Cancel')
                ),
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);

                      ref.child(id).update({
                        'title' : edittitleController.text.toLowerCase(),
                        'description' : editdescriptionController.text.toLowerCase(),
                      }).then((value){
                          Text('Note Updated');
                      }).onError((error, stackTrace){
                          error.toString();
                      });

                    }, child: Text('Update')
                ),

              ],
            ),
          );
        }
    );
  }

  MyList() {
    return Column(
      children: [
        SizedBox(height: 30,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            style: TextStyle(color: Colors.black),
            controller: searchFilter,
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(

                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onChanged: (String value){
              setState(() {

              });
            },
          ),
        ),
        SizedBox(height: 10,),
        Expanded(
          child: FirebaseAnimatedList(
              query: ref,
              defaultChild: Text('Loading',style: TextStyle(color: Colors.white,fontSize: 20,),),
              itemBuilder: (context, snapshot, animation, index){

                final title = snapshot.child('title').value.toString();
                final description = snapshot.child('description').value.toString();

                if(searchFilter.text.isEmpty){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(


                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1),
                        borderRadius: BorderRadius.circular(20.0),

                      ),
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle : Text(snapshot.child('description').value.toString()),
                      tileColor: Colors.yellowAccent,
                      trailing: PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              value : 1,
                              child: ListTile(
                                onTap: (){
                                  Navigator.pop(context);
                                  compList(title,description,snapshot.child('id').value.toString());
                                  //showMyDialog(title,description,snapshot.child('id').value.toString());
                                },
                                leading: Icon(Icons.bookmark_added_sharp),
                                title: Text('Mark as completed'),
                              )
                          ),
                          PopupMenuItem(
                              value : 1,
                              child: ListTile(
                                onTap: (){
                                  Navigator.pop(context);
                                  showMyDialog(title,description,snapshot.child('id').value.toString());
                                },
                                leading: Icon(Icons.edit),
                                title: Text('Edit'),
                              )
                          ),
                          PopupMenuItem(
                            value : 1,
                            child: ListTile(
                              onTap: (){
                                Navigator.pop(context);
                                ref.child(snapshot.child('id').value.toString()).remove();
                              },
                              leading: Icon(Icons.delete),
                              title: Text('Delete'),
                            ),
                          ),

                        ],
                      ),

                    ),
                  );
                }
                else if(title.toLowerCase().contains(searchFilter.text.toLowerCase().toLowerCase())){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(


                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1),
                        borderRadius: BorderRadius.circular(20.0),

                      ),
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle : Text(snapshot.child('description').value.toString()),
                      tileColor: Colors.yellowAccent,
                      trailing: PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              value : 1,
                              child: ListTile(
                                onTap: (){
                                  Navigator.pop(context);
                                  //showMyDialog(title,description,snapshot.child('id').value.toString());
                                },
                                leading: Icon(Icons.bookmark_added_sharp),
                                title: Text('Mark as completed'),
                              )
                          ),
                          PopupMenuItem(
                              value : 1,
                              child: ListTile(
                                onTap: (){
                                  Navigator.pop(context);
                                  showMyDialog(title,description,snapshot.child('id').value.toString());
                                },
                                leading: Icon(Icons.edit),
                                title: Text('Edit'),
                              )
                          ),
                          PopupMenuItem(
                            value : 1,
                            child: ListTile(
                              onTap: (){
                                Navigator.pop(context);
                                ref.child(snapshot.child('id').value.toString()).remove();
                              },
                              leading: Icon(Icons.delete),
                              title: Text('Delete'),
                            ),
                          ),

                        ],
                      ),

                    ),
                  );

                }
                else {
                  return Container();
                }


              }
          ),
        ),


      ],
    );




  }

  // Future<void> CompletedList(String id) async{
  //   Center(
  //           child: Text('Hello',style: TextStyle(color: Colors.white),),
  //         );
  // }

  CompletedList() {

    return Column(
      children: [
        SizedBox(height: 30,),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 10),
        //   child: TextFormField(
        //     style: TextStyle(color: Colors.black),
        //     controller: searchFilter,
        //     decoration: InputDecoration(
        //       hintText: 'Search',
        //       prefixIcon: Icon(Icons.search),
        //       filled: true,
        //       fillColor: Colors.white,
        //       border: OutlineInputBorder(
        //
        //         borderRadius: BorderRadius.circular(20),
        //       ),
        //     ),
        //     onChanged: (String value){
        //       setState(() {
        //
        //       });
        //     },
        //   ),
        // ),
        SizedBox(height: 10,),
        Expanded(
          child: FirebaseAnimatedList(
              query: ref,
              defaultChild: Text('Loading...',style: TextStyle(color: Colors.white,fontSize: 20,),),
              itemBuilder: (context, snapshot, animation, index){

                final title = snapshot.child('title').value.toString();
                final description = snapshot.child('description').value.toString();

                if(searchFilter.text.isEmpty){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(


                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1),
                        borderRadius: BorderRadius.circular(20.0),

                      ),
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle : Text(snapshot.child('description').value.toString()),
                      tileColor: Colors.yellowAccent,
                      trailing: PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              value : 1,
                              child: ListTile(
                                onTap: (){
                                  Navigator.pop(context);
                                  compList(title,description,snapshot.child('id').value.toString());
                                  //showMyDialog(title,description,snapshot.child('id').value.toString());
                                },
                                leading: Icon(Icons.bookmark_added_sharp),
                                title: Text('Mark as completed'),
                              )
                          ),
                          PopupMenuItem(
                              value : 1,
                              child: ListTile(
                                onTap: (){
                                  Navigator.pop(context);
                                  showMyDialog(title,description,snapshot.child('id').value.toString());
                                },
                                leading: Icon(Icons.edit),
                                title: Text('Edit'),
                              )
                          ),
                          PopupMenuItem(
                            value : 1,
                            child: ListTile(
                              onTap: (){
                                Navigator.pop(context);
                                ref.child(snapshot.child('id').value.toString()).remove();
                              },
                              leading: Icon(Icons.delete),
                              title: Text('Delete'),
                            ),
                          ),

                        ],
                      ),

                    ),
                  );
                }
                else if(title.toLowerCase().contains(searchFilter.text.toLowerCase().toLowerCase())){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(


                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1),
                        borderRadius: BorderRadius.circular(20.0),

                      ),
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle : Text(snapshot.child('description').value.toString()),
                      tileColor: Colors.yellowAccent,
                      trailing: PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              value : 1,
                              child: ListTile(
                                onTap: (){
                                  Navigator.pop(context);
                                  //showMyDialog(title,description,snapshot.child('id').value.toString());
                                },
                                leading: Icon(Icons.bookmark_added_sharp),
                                title: Text('Mark as completed'),
                              )
                          ),
                          PopupMenuItem(
                              value : 1,
                              child: ListTile(
                                onTap: (){
                                  Navigator.pop(context);
                                  showMyDialog(title,description,snapshot.child('id').value.toString());
                                },
                                leading: Icon(Icons.edit),
                                title: Text('Edit'),
                              )
                          ),
                          PopupMenuItem(
                            value : 1,
                            child: ListTile(
                              onTap: (){
                                Navigator.pop(context);
                                ref.child(snapshot.child('id').value.toString()).remove();
                              },
                              leading: Icon(Icons.delete),
                              title: Text('Delete'),
                            ),
                          ),

                        ],
                      ),

                    ),
                  );

                }
                else {
                  return Container();
                }


              }
          ),
        ),


      ],
    );



  }

  compList(String title, String description, String id) {
     return
       Column(
       children: [
         SizedBox(height: 30,),
         SizedBox(height: 10,),
         Expanded(
           child: FirebaseAnimatedList(
               query: ref,
               defaultChild: Text('Loading',style: TextStyle(color: Colors.white,fontSize: 34,fontWeight: FontWeight.bold),),
               itemBuilder: (context, snapshot, animation, index){

                 return Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: ListTile(


                     shape: RoundedRectangleBorder(
                       side: BorderSide(width: 1),
                       borderRadius: BorderRadius.circular(20.0),

                     ),
                     title: Text(id),
                     tileColor: Colors.yellowAccent,


                   ),
                 );
               }



           ),
         ),


       ],
     );
  }


}




// Stream Builder List

// Expanded(
// child: StreamBuilder(
// stream: ref.onValue,
// builder: (context,AsyncSnapshot<DatabaseEvent> snapshot){
//
// if(!snapshot.hasData){
//
// return Text('No data found');
// }
// else{
// Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
// List<dynamic> list = [];
// list.clear();
// list = map.values.toList();
//
// return ListView.builder(
// itemCount: snapshot.data!.snapshot.children.length,
// itemBuilder: (context,index){
// return ListTile(
// title: Text(list[index]['title']),
// subtitle: Text(list[index]['description']),
// );
// });
// }
//
// },
// )),
