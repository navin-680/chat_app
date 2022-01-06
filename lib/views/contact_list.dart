import 'package:chatapp/controller/ccontact_controller.dart';
import 'package:chatapp/widgets/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConatctList extends StatelessWidget {
   ConatctList({Key? key}) : super(key: key);
  ContactController contactController=Get.put(ContactController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Contacts',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: contactController.onTapSearch,
            ),
            IconButton(
              color: Colors.white,
              onPressed: contactController.sync,
              icon: Icon(Icons.sync),
            )
          ],
        ),
        body: Obx(()=> Container(
            padding: EdgeInsets.all(5),
            child: contactController.isProcessing
                ? Center(
              child: CircularProgressIndicator(),
            )
                : contactController.contactList.length > 0
                ? ListView.separated(
              itemCount: contactController.contactList.length,
              itemBuilder: (context, int i) {
                return ListTile(
                  leading: ProfileImage(
                    path: contactController.contactList[i].imageUrl,
                  ),
                  title: Text(contactController.contactList[i].name!),
                  trailing: Icon(Icons.message),
                  onTap: () => contactController.onContactTap(contactController.contactList[i]),
                );
              },
              separatorBuilder: (context, int i) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * .03,
                );
              },
            )
                : Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline),
                  Text("No contacts")
                ],
              ),
            ),
          ),
        ));
  }


}
