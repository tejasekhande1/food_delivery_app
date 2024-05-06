import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/controller/userdetail_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_textfield.dart';
import '../more/my_order_view.dart';
import 'package:http/http.dart' as http;

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ImagePicker picker = ImagePicker();
  XFile? image;

  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();
Future<void > changeProfile()async{
    try{
      SharedPreferences sprf= await SharedPreferences.getInstance();
      print(txtConfirmPassword.text);
      print(txtPassword.text);
      var userid= sprf.getString("userId");
      print(userid);
      var response=await http.put(Uri.parse("http://192.168.1.22:3001/api/user/$userid"),
      body: {
        "name":txtName.text,
        "email":txtEmail.text,
        "mobile":txtMobile.text,
        "address":txtAddress.text,
        "password":txtPassword.text,
        "confirmedPassword ":txtConfirmPassword.text
      }
      );
   if(response.statusCode==200){
        Provider.of<Userdetailcontroller>(context,listen: false).changedata(name: txtName.text, email: txtEmail.text, pass: txtPassword.text, mobileno: txtMobile.text, add: txtAddress.text);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Update Successful")));
      }else{
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to Update")));
      }
    }catch (e){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something Went Wrong")));
    }
  }
  @override
  Widget build(BuildContext context) {
  txtName.text=Provider.of<Userdetailcontroller>(context).name;
  txtEmail.text=Provider.of<Userdetailcontroller>(context).email;
  txtMobile.text=Provider.of<Userdetailcontroller>(context).mobileno;
  txtAddress.text=Provider.of<Userdetailcontroller>(context).add;
  txtPassword.text=Provider.of<Userdetailcontroller>(context).pass;
  txtConfirmPassword.text=Provider.of<Userdetailcontroller>(context).pass;
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(
            height: 46,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Profile",
                  style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 20,
                      fontWeight: FontWeight.w800),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyOrderView()));
                  },
                  icon: Image.asset(
                    "assets/img/shopping_cart.png",
                    width: 25,
                    height: 25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: TColor.placeholder,
              borderRadius: BorderRadius.circular(50),
            ),
            alignment: Alignment.center,
            child: image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.file(File(image!.path),
                        width: 100, height: 100, fit: BoxFit.cover),
                  )
                : Icon(
                    Icons.person,
                    size: 65,
                    color: TColor.secondaryText,
                  ),
          ),
          // TextButton.icon(
          //   onPressed: () async {
          //     image = await picker.pickImage(source: ImageSource.gallery);
          //     setState(() {});
          //   },
          //   icon: Icon(
          //     Icons.edit,
          //     color: TColor.primary,
          //     size: 12,
          //   ),
          //   label: Text(
          //     "Edit Profile",
          //     style: TextStyle(color: TColor.primary, fontSize: 12),
          //   ),
          // ),
          Text(
            "Hi there ${Provider.of<Userdetailcontroller>(context).name}!",
            style: TextStyle(
                color: TColor.primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              "Sign Out",
              style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 11,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Name",
              hintText: "Enter Name",
              controller: txtName,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Email",
              hintText: "Enter Email",
              keyboardType: TextInputType.emailAddress,
              controller: txtEmail,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Mobile No",
              hintText: "Enter Mobile No",
              controller: txtMobile,
              keyboardType: TextInputType.phone,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Address",
              hintText: "Enter Address",
              controller: txtAddress,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              
              title: "Password",
              hintText: "* * * * * *",
              obscureText: true,
              controller: txtPassword,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Confirm Password",
              hintText: "* * * * * *",
              obscureText: true,
              controller: txtConfirmPassword,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RoundButton(title: "Save", onPressed: () {
              changeProfile();
            }),
          ),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    ));
  }
}
