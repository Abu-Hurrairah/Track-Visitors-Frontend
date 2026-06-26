import 'package:flutter/material.dart';
import 'package:project/CommonUtils.dart/LogoutConfirmationDialog.dart';
import 'package:project/Global/DirectorGlobal.dart';
import 'package:project/Tasks/LastWeekVisitors.dart';
import 'package:project/Tasks/SearchTodayVisitor.dart';
import 'package:project/Tasks/ShowBlockVisitors.dart';
import 'package:project/Tasks/TodayVisitors.dart';

class DirectorDashBoardScreen extends StatefulWidget {
  const DirectorDashBoardScreen({super.key});

  @override
  State<DirectorDashBoardScreen> createState() => _DirectorDashBoardScreenState();
}

class _DirectorDashBoardScreenState extends State<DirectorDashBoardScreen> {

  String directorName = DirectorGlobal.directorGlobal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Director DashBoard'),),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showLogoutConfirmationDialog(context);
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(builder: (context){
                    //     return Login();
                    //   })
                    // );
                  });
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    height: 25,
                    width: double.infinity,
                    child: Text('Logout',style: TextStyle(fontSize: 20,color: Colors.blue),textAlign: TextAlign.right,)
                  ),
                )
              ),
              SizedBox(height: 15,),
              Text('Welcome, ${directorName}',style: TextStyle(fontSize: 30,color: Colors.blue),),
              SizedBox(height: 5,),
              Text('Director',style: TextStyle(fontSize: 20,color: Colors.blue),),
              SizedBox(height: 30,),
              Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(
                    MaterialPageRoute(builder: (context){
                      return TodayVisitorsScreen();
                    })
                  );
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        height: 170,
                        width: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 126, 214, 255),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.today,size: 60,color: Colors.white,),
                            SizedBox(height: 15,),
                            Text('Today Visitors',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
                          ]
                        ),
                      ),
                    )
                  ),
                  SizedBox(width: 20,),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context){
                          return LastWeekVisitorsScreen();
                        })
                      );
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        height: 170,
                        width: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 126, 214, 255),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              child: Image.asset('asset/images/searchlisticon.png',fit: BoxFit.fill,)
                            ),
                            SizedBox(height: 15,),
                            Text('Last Week Visitors',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
                          ]
                        ),
                      ),
                    )
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context){
                          return const SearchTodayVisitorScreen();
                        })
                      );
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        height: 170,
                        width: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 126, 214, 255),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search,size: 60,color: Colors.white,),
                            SizedBox(height: 15,),
                            Text('Search Visitor Today',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
                          ]
                        ),
                      ),
                    )
                  ),
                  SizedBox(width: 20,),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context){
                          return ShowBlockVisitorsScreen();
                        })
                      );
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        height: 170,
                        width: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 126, 214, 255),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.block,size: 60,color: Colors.white,),
                            SizedBox(height: 15,),
                            Text('Show Block Visitors',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
                          ]
                        ),
                      ),
                    )
                  ),
                ],
              ),
              // ElevatedButton(
              //   onPressed: (){
              //     Navigator.of(context).push(
              //       MaterialPageRoute(builder: (context){
              //         return TodayVisitorsScreen();
              //       })
              //     );
              //   }, 
              //   child: Text('Today Visitors')
              // ),
              // SizedBox(height: 15,),
              // ElevatedButton(
              //   onPressed: (){
              //     Navigator.of(context).push(
              //       MaterialPageRoute(builder: (context){
              //         return LastWeekVisitorsScreen();
              //       })
              //     );
              //   }, 
              //   child: Text('Last Week Visitors')
              // ),
              // SizedBox(height: 15,),
              // ElevatedButton(
              //   onPressed: (){

              //   }, 
              //   child: Text('Search Visitor Today')
              // ),
              // SizedBox(height: 15,),
              // ElevatedButton(
              //   onPressed: (){
              //     Navigator.of(context).push(
              //       MaterialPageRoute(builder: (context){
              //         return ShowBlockVisitorsScreen();
              //       })
              //     );
              //   }, 
              //   child: Text('Show Block Visitors')
              // ),
            ],
          ),
        ),
      ),
    );
  }
}