import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AddGuard extends StatefulWidget {
  const AddGuard({super.key});

  @override
  State<AddGuard> createState() => _AddGuardState();
}

class _AddGuardState extends State<AddGuard> {
  TextEditingController controller_guardName=TextEditingController();
  TextEditingController controller_userName=TextEditingController();
  TextEditingController controller_password=TextEditingController();
  bool isObscure=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Guard',style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),),),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text('Add Guard',style: TextStyle(fontSize: 30,color: Colors.blue,fontWeight: FontWeight.bold),),
                SizedBox(height: 60,),
                Container(
                  height: 130,
                  width: 130,
                  child: Image.asset('asset/images/logo.png',fit: BoxFit.fill,),
                ),
                SizedBox(height: 35,),
                TextFormField(
                  controller: controller_guardName,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    // border: OutlineInputBorder(),
                    hintText: 'Guard Name',
                    labelText: 'Guard Name',
                    prefixIcon: Icon(Icons.person,size: 30,),
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: controller_userName,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    // border: OutlineInputBorder(),
                    hintText: 'User Name',
                    labelText: 'User Name',
                    prefixIcon: Icon(Icons.person,size: 30,),
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: controller_password,
                  style: TextStyle(fontSize: 20),
                  obscureText: isObscure,
                  decoration: InputDecoration(
                    // border: OutlineInputBorder(),
                    hintText: 'Password',
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock,size: 30,),
                    suffixIcon: IconButton(
                      onPressed: (){
                        isObscure=!isObscure;
                        setState(() {
                          
                        });
                      }, 
                      icon: isObscure?Icon(Icons.visibility):Icon(Icons.visibility_off))
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
                        child: Text('Add Guard',style: TextStyle(fontSize: 20,color: Colors.white),),
                      ),
                    ),
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}