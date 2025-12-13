import 'package:admin_website/components/CardCostum.dart';
import 'package:admin_website/components/TextFieldCostum.dart';
import 'package:admin_website/layout/responsive.dart';
import 'package:admin_website/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeaderCostum extends StatefulWidget {
  final TextEditingController controller;
  final bool isSearch;

  const HeaderCostum({
    required this.controller,
    super.key,
    this.isSearch = true,
  });

  @override
  State<HeaderCostum> createState() => _HeaderCostumState();
}

class _HeaderCostumState extends State<HeaderCostum> {
  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthService>(context, listen: false);
    final isDesktop = Responsive.isDesktop(context);

    return CardCostum(
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              spacing: 30,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text("Dashboard"),

                if(widget.isSearch)
                  SearchFieldCostum(
                    controller: widget.controller, 
                    hintText: "search"
                  )
              ],
            ),
        
            Wrap(
              spacing: 5,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(isDesktop
                  ? "${auth.loggedUser?.userName} | Travora Manager"
                  : "${auth.loggedUser?.userName}"
                ),
        
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: Colors.black54,
                    width: 1
                  )
                ),
                child: const Icon(
                  Icons.person_outline, 
                  color: Colors.black54,
                  size: 30,
                ),
              )
              ],
            )
          ],
        ),
      ),
    );
  }
}