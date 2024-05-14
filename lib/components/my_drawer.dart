import 'package:chitchat/services/auth/auth_service.dart';
import 'package:chitchat/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  
  void logout(){
    //get auth service
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Column(children: [
            //logo
          DrawerHeader(
            child: Center(
              child: SvgPicture.asset('logo/mobile-logo.svg',height: 80,width: 80,)
              ),
          ),

        //home list tile
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: ListTile(
            title: const Text("H O M E"),
            leading: const Icon(Icons.home),
            onTap: (){
              //pop the drawer
              Navigator.pop(context);
            },
          ),
        ),

        //settings list tile
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: ListTile(
            title: const Text("S E T T I N G S"),
            leading: const Icon(Icons.settings),
            onTap: (){
              //pop the drawer
              Navigator.pop(context);
              //navigate to settings page
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage(),
              ),
              );
            },
          ),
        ),

       ],
      ),

        //logout list tile
        Padding(
          padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
          child: ListTile(
            title: const Text("L O G O U T"),
            leading: const Icon(Icons.logout),
            onTap: logout,
          ),
        ),
        ],
      ),

    );
  }
}