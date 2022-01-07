import 'package:chatapp/controller/ccontact_controller.dart';
import 'package:chatapp/widgets/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConatctList extends StatelessWidget {
  ConatctList({Key? key}) : super(key: key);
  ContactController contactController = Get.put(ContactController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            "Contacts",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: contactController.onTapSearch,
            ),
            IconButton(
              color: Colors.black,
              onPressed: contactController.sync,
              icon: const Icon(Icons.sync),
            )
          ],
          backgroundColor: Colors.white,
        ),
        body: Obx(
          () => Container(
            padding: const EdgeInsets.all(5),
            child: contactController.isProcessing.value
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.black,),
                  )
                : contactController.contactList.isNotEmpty
                    ? ListView.separated(
                        itemCount: contactController.contactList.length,
                        itemBuilder: (context, int i) {
                          return ListTile(
                            leading: ProfileImage(
                              path: contactController.contactList[i].imageUrl,
                            ),
                            title: Text(contactController.contactList[i].name!),
                            trailing: const Icon(Icons.message),
                            onTap: () => contactController
                                .onContactTap(contactController.contactList[i]),
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
                          children: const [
                            Icon(Icons.error_outline),
                            Text("No contacts")
                          ],
                        ),
                      ),
          ),
        ));
  }
}
