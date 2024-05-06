
import 'dart:convert';
import 'dart:math';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/controller/cart_controller.dart';
import 'package:food_delivery/controller/food_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import "package:flutter_slidable/flutter_slidable.dart";
import 'checkout_view.dart';

class MyOrderView extends StatefulWidget {
  const MyOrderView({super.key});

  @override
  State<MyOrderView> createState() => _MyOrderViewState();
}

class _MyOrderViewState extends State<MyOrderView> {
  List itemArr = [
  //   {"name": "Beef Burger", "qty": "1", "price": 16.0},
  //   {"name": "Classic Burger", "qty": "1", "price": 14.0},
  //   {"name": "Cheese Chicken Burger", "qty": "1", "price": 17.0},
  //   {"name": "Chicken Legs Basket", "qty": "1", "price": 15.0},
  //   {"name": "French Fires Large", "qty": "1", "price": 6.0}
  ];

  

  Future<void> deleteCart( var val,context)async{
    try{
      print(val);
      var response =await http.delete(Uri.parse("http://192.168.1.22:3001/api/cart/$val"));

      if(response.statusCode==200){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("delete Successful")));
      }else{
        print(response.body);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("aFailed to delete")));
      }
    }catch (e){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to delete")));
    }
  }


  Future getcart()async{
    try{
      SharedPreferences sprf=await SharedPreferences.getInstance();
      String? userid = sprf.getString("userId");
      var response= await http.get(Uri.parse("http://192.168.1.22:3001/api/cart?user_id=$userid"),);
      
      if(response.statusCode==200){
        Map data=jsonDecode(response.body);
        itemArr= await data['cart'];
        print(itemArr);
        setState(() {
          
        });

      }else{
        print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('aFailed')));

      }

    }catch (e){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed')));
    }
  }
  @override
  void initState(){
    super.initState();
    getcart();
  }
  @override
  Widget build(BuildContext context) {
    String getsubtotal(){
    var len=itemArr.length-1;
    num subtotal=0;
    while(len!=-1){
      subtotal+= (double.parse(Provider.of<Foodcontroller>(context).menuItemsArr[itemArr[len]['menu_item_id']]['price']))*(itemArr[len]['qty']);
      len--;
    }
    return "$subtotal";
  }
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        title: Text(
                      "My Order",
                      style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 20,
                          fontWeight: FontWeight.w800),
                    ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 500,
              child: ListView.builder(
                      itemCount: itemArr.length,
                      itemBuilder: (context,index) {
                        return Slidable(
                          endActionPane:  ActionPane(
                            motion:DrawerMotion(), 
                            children: [
                              Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                deleteCart(itemArr[index]['cart_id'],context);
                                              });
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(5),
                                              height: 32,
                                              width: 32,
                                              decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                    89, 57, 241, 1),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: const Icon(
                                                Icons.delete_outline,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                            ]),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                            decoration:const BoxDecoration(
                              border: Border(bottom: BorderSide(color: Color.fromARGB(133, 0, 0, 0)))
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.asset(Provider.of<Foodcontroller>(context).menuItemsArr[itemArr[index]['menu_item_id']]['image'],
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    )),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Provider.of<Foodcontroller>(context).menuItemsArr[itemArr[index]['menu_item_id']]['name'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: TColor.primaryText,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                "assets/img/rate.png",
                                                width: 10,
                                                height: 10,
                                                fit: BoxFit.cover,
                                              ),
                                              const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "4.9",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: TColor.primary, fontSize: 12),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            "(124 Ratings)",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: TColor.secondaryText, fontSize: 12),
                                          ),
                                            ],
                                          ),
                                          
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('\$${Provider.of<Foodcontroller>(context).menuItemsArr[itemArr[index]['menu_item_id']]['price']}x ${itemArr[index]['qty']} ')
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Food",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: TColor.secondaryText, fontSize: 12),
                                          ),
                                          Text(
                                            " . ",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: TColor.primary, fontSize: 12),
                                          ),
                                          Text(Provider.of<Foodcontroller>(context).menuItemsArr[itemArr[index]['menu_item_id']]['food_type'],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: TColor.secondaryText, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            "assets/img/location-pin.png",
                                            width: 13,
                                            height: 13,
                                            fit: BoxFit.contain,
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "No 03, 4th Lane, Newyork",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: TColor.secondaryText,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    ),
            ),
           
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Delivery Instructions",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.add, color: TColor.primary),
                          label: Text(
                            "Add Notes",
                            style: TextStyle(
                                color: TColor.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                    Divider(
                      color: TColor.secondaryText.withOpacity(0.5),
                      height: 1,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Sub Total",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        ),
                        
                         Text(getsubtotal(),
                          style: TextStyle(
                              color: TColor.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        )
                        
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Delivery Cost",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "\$2",
                          style: TextStyle(
                              color: TColor.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Divider(
                      color: TColor.secondaryText.withOpacity(0.5),
                      height: 1,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "\$${double.parse(getsubtotal())+2}",
                          style: TextStyle(
                              color: TColor.primary,
                              fontSize: 22,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    
                    const SizedBox(height: 20,),
                    RoundButton(
                        title: "Checkout",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CheckoutView(),
                            ),
                          );
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),);
  }
}
