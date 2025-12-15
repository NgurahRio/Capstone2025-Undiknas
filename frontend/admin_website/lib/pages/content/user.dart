import 'package:admin_website/components/CardCostum.dart';
import 'package:admin_website/components/DeletePopup.dart';
import 'package:admin_website/components/HeaderCostum.dart';
import 'package:admin_website/components/Table/ActionButton.dart';
import 'package:admin_website/components/Table/TabelContent.dart';
import 'package:admin_website/components/Table/TableHeader.dart';
import 'package:admin_website/models/user_model.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  TextEditingController searchUser = TextEditingController();

  List<User> userSearch = [];
  List<User> users = [];
  bool isLoading = true;

  Future<void> loadUsers() async {
    try {
      final data = await getUsers();
      setState(() {
        users = data;
        userSearch = data;
        isLoading = false;
      });
    } catch (e) {
      isLoading = false;
      debugPrint(e.toString());
    }
  }

  void _searchFunction() {
    String query = searchUser.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        userSearch = users;
      } else {
        userSearch = users.where((user) {
          return user.username.toLowerCase().contains(query) ||
                user.email.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadUsers();
    searchUser.addListener(_searchFunction);
  }

  void bannedUser(int id) {
    showPopUpDelete(
      context: context, 
      text: "User", 
      onDelete: () async{
        try {
          await deleteUser(id);
          setState(() {
            users.removeWhere((item) => item.id_user == id);
            searchUser.clear();
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("User berhasil dihapus"),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Gagal menghapus user: ${e.toString()}"),
            ),
          );
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                HeaderCostum(controller: searchUser),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 35),
                  child: Text(
                    "Manage Users",
                    style: TextStyle(fontSize: 20),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Text(
                    "Admin",
                    style: TextStyle(fontSize: 20),
                  ),
                ),

                CardCostum(
                  content: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            TableHeader(title: "Name"),
                            TableHeader(title: "Email"),
                            TableHeader(title: "Role"),
                          ],
                        ),
                      ),

                      const Divider(height: 1,),

                      ...userSearch.where((u) => u.roleId.id_role == 2).toList().asMap().entries.map((entry) {
                        final index = entry.key;
                        final user = entry.value;

                        final bool isEven = index % 2 == 0;

                        return Container(
                          color: isEven ? Colors.white : const Color(0xFFEDF6FF),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                TableContent(title: user.username),
                                TableContent(title: user.email),
                                TableContent(title: user.roleId.role_name),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  )
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    "User",
                    style: TextStyle(fontSize: 20),
                  ),
                ),

                CardCostum(
                  content: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            TableHeader(title: "Name"),
                            TableHeader(title: "Email", flex: 2,),
                            TableHeader(title: "Role"),
                            TableHeader(title: "Action"),             
                          ],
                        ),
                      ),

                      const Divider(height: 1,),

                      ...userSearch.where((u) => u.roleId.id_role == 1).toList().asMap().entries.map((entry) {
                        final index = entry.key;
                        final user = entry.value;

                        final bool isEven = index % 2 == 0;

                        return Container(
                          color: isEven ? Colors.white : const Color(0xFFEDF6FF),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                TableContent(title: user.username),
                                TableContent(title: user.email, flex: 2,),
                                TableContent(title: user.roleId.role_name),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Actionbutton(
                                        isDelete: true,
                                        label: "Banned", 
                                        onTap: () => bannedUser(user.id_user), 
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  )
                )

              ],
            ),
          ),
        )
      ),
    );
  }
}