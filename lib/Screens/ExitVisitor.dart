import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/CommonUtils.dart/LogoutConfirmationDialog.dart';
import 'package:project/Screens/Guard.dart';
import 'package:project/Screens/Login.dart';

class ExitVisitorScreen extends StatefulWidget {
  const ExitVisitorScreen({super.key});

  @override
  State<ExitVisitorScreen> createState() => _ExitVisitorScreenState();
}

class _ExitVisitorScreenState extends State<ExitVisitorScreen> {
  TextEditingController controller_searchPhoneNo=TextEditingController();
  TextEditingController enterTime_controller=TextEditingController();
  TextEditingController exitTime_controller=TextEditingController();
  var date = DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();

  Future<Null> _selectEnterTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    if(picked != null && picked != _time) {
      print('Time selected: ${_time.toString()}');
      setState((){
        _time = picked;
        enterTime_controller.text=_time.format(context);
      });
    }
  }
  Future<Null> _selectExitTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    if(picked != null && picked != _time) {
      print('Time selected: ${_time.toString()}');
      setState((){
        _time = picked;
        exitTime_controller.text=_time.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context){
                          return GuardScreen();
                        })
                      );
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue,width: 2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(Icons.arrow_back,color: Colors.blue,)
                        ),
                      ),
                    )
                  ),
                  // SizedBox(width: 800),
                  GestureDetector(
                    onTap: () {
                      showLogoutConfirmationDialog(context);
                      // Navigator.of(context).pushReplacement(
                      //   MaterialPageRoute(builder: (context){
                      //     return Login();
                      //   })
                      // );
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        height: 25,
                        // width: 200,
                        // width: double.infinity,
                        child: Text('Logout',style: TextStyle(fontSize: 20,color: Colors.blue),textAlign: TextAlign.right,)
                      ),
                    )
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Text('Exit Visitor',style: TextStyle(fontSize: 30,color: Colors.blue),),
              SizedBox(height: 30,),
              Container(
                height: 50,
                width: 600,
                child: TextFormField(
                  controller: controller_searchPhoneNo,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    // border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                    hintText: 'Search Phone No.',
                    hintStyle: TextStyle(color: Colors.blue),
                    suffixIcon: Icon(Icons.search,color: Colors.blue,),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40,),
              Container(
                padding: EdgeInsets.zero,
                // decoration: BoxDecoration(border: Border.all()),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 1.0),
                    child: Text(DateFormat('EEEE, d MMM, yyyy').format(date),style: TextStyle(fontSize: 20,color: Colors.blue),
                    // child: Text(
                    //   'Text Right',
                    //   style: TextStyle(
                    //       fontFamily: 'Poppins',
                    //       fontStyle: FontStyle.normal,
                    //       fontWeight: FontWeight.w500,
                    //       fontSize: 19,
                    //       color: Colors.blue),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Container(
                padding: EdgeInsets.zero,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: TextButton(
                      onPressed: (){
                        enterTime_controller.text=_time.format(context);
                        setState(() {
                          _selectEnterTime(context);  
                        });
                      }, 
                      child: Text("Enter Time",style: TextStyle(fontSize: 20,color: Colors.blue),)
                    ),
                  ),
                ),
              ),
              TextFormField(
                controller: enterTime_controller,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  hintText: '9:30 AM',
                  hintStyle: TextStyle(fontSize: 15,color: Colors.blue),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 1,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Container(
                padding: EdgeInsets.zero,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: TextButton(
                      onPressed: (){
                        exitTime_controller.text=_time.format(context);
                        setState(() {
                          _selectExitTime(context);  
                        });
                      }, 
                      child: Text("Exit Time",style: TextStyle(fontSize: 20,color: Colors.blue),)
                    ),
                  ),
                ),
              ),
              TextFormField(
                controller: exitTime_controller,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  hintText: '11:00 AM',
                  hintStyle: TextStyle(fontSize: 15,color: Colors.blue),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 1,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              GestureDetector(
                  // onTap: (){
                  //   Navigator.of(context).pushReplacement(
                  //     MaterialPageRoute(builder: (context){
                  //       return ;
                  //     })
                  //   );
                  // },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      height: 50,
                      width: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Text('Visit Completed',style: TextStyle(fontSize: 20,color: Colors.white),),
                      ),
                    ),
                  )
                ),
            ]
          ),
        )
      )
    );
  }
}