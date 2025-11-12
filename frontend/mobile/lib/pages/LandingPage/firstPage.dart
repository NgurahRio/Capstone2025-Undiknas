import 'package:flutter/material.dart';
import 'package:mobile/componen/buttonCostum.dart';
import 'package:mobile/pages/Auth/loginPage.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff3f9ff),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Image.asset('assets/l&n.png', height: 30),
              ),
          
              Image.asset('assets/pana.png'),

              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 30, left: 40, right: 40,),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Easy Tour Booking", 
                        style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold)
                      ),

                      Text("Enjoy a smooth journey with simple and secure online reservations.", 
                        style: TextStyle(
                          fontSize: 15,
                          color: const Color.fromARGB(255, 125, 125, 125),
                        )
                      ),

                      ButtonCostum(
                        text: "Start Now",
                        onPressed: (){
                          Navigator.pushAndRemoveUntil(
                            context, 
                            MaterialPageRoute(builder: (context) => LoginPage()), 
                            (route) => false
                          );
                        }, 
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}