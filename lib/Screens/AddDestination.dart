import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AddDestination extends StatefulWidget {
  const AddDestination({super.key});

  @override
  State<AddDestination> createState() => _AddDestinationState();
}

class _AddDestinationState extends State<AddDestination> {
  TextEditingController controller_destinationName=TextEditingController();
  TextEditingController controller_nearByCamera=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Add Destination',style: TextStyle(fontSize: 30,color: Colors.blue,fontWeight: FontWeight.bold),),
              SizedBox(height: 80,),
              Container(
                height: 130,
                width: 130,
                child: Image.asset('asset/images/logo.png',fit: BoxFit.fill,),
              ),
              SizedBox(height: 35,),
              TextFormField(
                controller: controller_destinationName,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  // border: OutlineInputBorder(),
                  hintText: 'Destination Name',
                  labelText: 'Destination Name',
                  prefixIcon: Icon(Icons.location_on,size: 30,),
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: controller_nearByCamera,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  // border: OutlineInputBorder(),
                  hintText: 'Near By Camera',
                  labelText: 'Near By Camera',
                  // prefixIcon: Icon(Icons.camera,size: 30,),
                ),
              ),
              SizedBox(height: 50,),
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
                      child: Text('Add Destination',style: TextStyle(fontSize: 20,color: Colors.white),),
                    ),
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}