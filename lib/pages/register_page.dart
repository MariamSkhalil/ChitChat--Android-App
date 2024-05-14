import 'package:chitchat/services/auth/auth_service.dart';
import 'package:chitchat/components/my_button.dart';
import 'package:chitchat/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class RegisterPage extends StatelessWidget {
      //Email and Password text Controller
  final TextEditingController _emailController =TextEditingController();
  final TextEditingController _pwController =TextEditingController();
  final TextEditingController _cpwController =TextEditingController();
    //tap to go to Register page
  final void Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  //Register Method
  void register(BuildContext context){
    //get auth service 
    final auth= AuthService();
    //if pws match, create user successfully
    if(_cpwController.text == _pwController.text){
      try{
        auth.signUpWithEmailPassword(_emailController.text, _pwController.text);
         }catch (e){
            showDialog(context: context,
              builder: (context)=>AlertDialog(
              title: Text(e.toString()),
      ));
          }
    }// pws dont match, tell the user to check his password
    else{
       showDialog(context: context,
              builder: (context)=>const AlertDialog(
              title: Text("Oops! Passwords don't match, check again!"),
      ));
    }
  }
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
       child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //LOGO
          SvgPicture.asset('logo/vertical-logo.svg',height: 120,width: 120,),
          
          const SizedBox(height: 10,),
          //"Welcome back"
          Text(
            "Let's create an account for you",
            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 18
                            ),
          ),
          const SizedBox(height: 25,),
          //email textfield
          MyTextField(hintText: "Email" , obscureText: false, controller: _emailController, focusNode: null,),

          const SizedBox(height: 10,),
          //pw textfield
          MyTextField(hintText: "Password", obscureText: true, controller: _pwController, focusNode: null,),

          const SizedBox(height: 10,),
          //cpw textfield
          MyTextField(hintText: "Confirm Password", obscureText: true, controller: _cpwController, focusNode: null,),
          
          const SizedBox(height: 25,),
          //register button
          MyButton(text:"Register", onTap:()=> register(context),),
          
          const SizedBox(height: 25,),
          //register now
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
               const Text("Already have an account? "),
               GestureDetector(
                onTap: onTap,
                child: const Text(
                "Login",
                 style: TextStyle(
                  fontWeight: FontWeight.bold),
                  )
                ),
               ]
              ),

        ],
      )
    )
  );
  }
}