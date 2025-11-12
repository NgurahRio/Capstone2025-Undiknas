import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final VoidCallback? onTapBack;
  final String? title;

  Header({
    super.key,
    this.onTapBack,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
          height: 85,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Stack( 
                alignment: Alignment.centerLeft,        
                children: [

                  onTapBack != null 
                    ? GestureDetector(
                        onTap: onTapBack,
                        child: Icon(Icons.arrow_back_ios),
                      )
                    : Image.asset('assets/l&n.png', scale: 2.3),
                  if(title != null && title!.isNotEmpty)
                    Center(
                      child: Text(
                        title!,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  Positioned(
                    right: 0,
                    child: GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(0xFF6189af)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 1),
                              child: Row(
                                children: [
                                  Image.asset('assets/icons/chatbot.png', scale: 0.9,),
                                  SizedBox(width: 5,),
                                  Text('Chat', style: TextStyle(color: Colors.white, fontSize: 18),),
                                ]
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ),
          ),
        ),
    );
  }
}