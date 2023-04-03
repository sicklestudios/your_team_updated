import 'package:flutter/material.dart';
import 'package:yourteam/constants/colors.dart';
import 'package:yourteam/constants/constant_utils.dart';
import 'package:yourteam/methods/auth_methods.dart';
import 'package:yourteam/screens/auth/login_screen.dart';
class DeleteScreen extends StatefulWidget {
  const DeleteScreen({Key? key}) : super(key: key);

  @override
  State<DeleteScreen> createState() => _DeleteScreenState();
}

class _DeleteScreenState extends State<DeleteScreen> {
  String deleteString="PERMANENTLY DELETE";
  TextEditingController? _deleteFieldController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  _deleteFieldController=TextEditingController();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _deleteFieldController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar:AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          toolbarHeight: 100,
          foregroundColor: Colors.black,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
          elevation: 0,
          title: const Text("Delete Account"),
          ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text("Are you sure you want to delete your account? Please read how account deletion will take affect.",style: TextStyle(fontSize: 18),),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical:15.0),
                      child: Row(
                        children: const[
                           Text("Account",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                        ],
                      ),
                    ),
                    const Text("Deleting your account removes your information from our database. Please note that the media shared through chats is not deleted and your email cannot be reused to register a new account.",style: TextStyle(fontSize: 18),),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical:15.0),
                      child: Row(
                        children: const[
                           Text("Confirm Account Deletion",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22)),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Text("Enter ",style: TextStyle(fontSize: 18),),
                        Text(deleteString,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                        const Text(" to confirm:",style: TextStyle(fontSize: 18),),
                      ],
                    )
                    ,
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical:15.0),

                      child: TextFormField(
                        controller: _deleteFieldController,
                        onFieldSubmitted: (value) {},
                        onChanged: (val){
                          setState(() {

                          });
                        },
                        autofocus: false,
                        obscureText: false,
                        decoration:  InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          hintText: 'Enter $deleteString to confirm:',
                          filled: true,
                          fillColor: Colors.white,
                          hintStyle: const TextStyle(
                              color: Color.fromRGBO(
                                  102, 124, 150, 1),
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: _deleteFieldController!.text.trim()!=deleteString?null: () async{
                        showToastMessage("Deleting Account Please Wait!");
                        String res=await AuthMethods().deleteAccount();
                        if(res=="success")
                          {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const LoginScreen(),
                                ),
                                ModalRoute.withName(
                                    '/login'));
                          }
                        else {
                          showFloatingFlushBar(context, "Error", res);
                        }

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0, 0, 0, 0),
                        minimumSize: const Size(306, 54),
                      ),
                      child: const Text(
                        'Delete Account',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
