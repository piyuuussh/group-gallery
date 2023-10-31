
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:group_gallery/controllers/BaseController.dart';
import 'package:group_gallery/controllers/firestore_controller.dart';
import 'package:group_gallery/routes/app_routes.dart';

class AuthController extends BaseController{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreController firestoreController = Get.find();

  void signInWithGoogle() async {
    setState(ViewState.busy);
    update();
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    print(userCredential.user.toString());
    setState(ViewState.idle);
    if(userCredential.additionalUserInfo?.isNewUser ?? false){
      firestoreController.saveUserToDB(userCredential.user);
    }
    Get.offAllNamed(AppRoutes.landing, arguments: 2);
  }

  Future<void> signOut() async{
    await _auth.signOut();
    Get.offAllNamed(AppRoutes.landing, arguments: 2);
  }

  User? getCurrentUser(){
    return _auth.currentUser;
  }

  bool isLoggedIn(){
    return _auth.currentUser != null;
  }
}