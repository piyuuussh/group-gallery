import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_gallery/controllers/BaseController.dart';
import 'package:group_gallery/controllers/auth_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        builder: (controller) {
          User? user = controller.getCurrentUser();
          if(controller.state == ViewState.busy){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Center(
              child: user != null
                  ? buildSignInWidgets(controller, user)
                  : buildSignOutWidgets(controller)
          );
        }
    );
  }

  Widget buildSignInWidgets(AuthController controller, User user){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(backgroundImage: NetworkImage(user.photoURL!)),
        const SizedBox(height: 20),
        Text(user.displayName!),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: controller.signOut,
          child: const Text("Logout"),
        )
      ],
    );
  }


  Widget buildSignOutWidgets(AuthController controller){
    return ElevatedButton(
      onPressed: controller.signInWithGoogle,
      child: const Text("Login"),
    );
  }
}
