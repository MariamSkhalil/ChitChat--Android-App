import 'package:chitchat/components/my_button.dart';
import 'package:chitchat/components/my_textfield.dart';
import 'package:chitchat/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatelessWidget {
  
  //Email and Password text Controller
  final TextEditingController _emailController =TextEditingController();
  final TextEditingController _pwController =TextEditingController();
  //tap to go to Register page
  final void Function()? onTap;

  //LOGIN METHOD
  void login(BuildContext context) async{
    final authService= AuthService();
    //try to login
    try{
      await authService.signInWithEmailPassword(_emailController.text, _pwController.text,);
    } catch (e){
      // ignore: use_build_context_synchronously
      showDialog(context: context,
       builder: (context)=>AlertDialog(
        title: Text(e.toString()),
      ));
    }
    //catch errors
  }
   LoginPage({super.key, required this.onTap});
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
          
          const SizedBox(height: 25,),
          //email textfield
          MyTextField(hintText: "Email" , obscureText: false, controller: _emailController, focusNode: null,),

          const SizedBox(height: 10,),
          //pw textfield
          MyTextField(hintText: "Password", obscureText: true, controller: _pwController, focusNode: null,),
          
          const SizedBox(height: 25,),
          //login button
          MyButton(text:"Login",
           onTap:()=> login(context)),
          
          const SizedBox(height: 25,),
          //register now
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
               const Text("Not a member? "),
               GestureDetector(
                onTap: onTap,
                child: const Text(
                  "Register now",
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