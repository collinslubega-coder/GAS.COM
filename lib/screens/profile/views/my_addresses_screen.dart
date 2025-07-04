import 'package:flutter/material.dart';
import 'package:gas_com/constants.dart';
import 'package:gas_com/services/user_data_service.dart';
import 'package:provider/provider.dart';

class MyAddressesScreen extends StatelessWidget {
  const MyAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataService>(
      builder: (context, userDataService, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("My Addresses"),
          ),
          body: userDataService.addresses.isEmpty
              ? const Center(
                  child: Text(
                    "You have no saved addresses.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(defaultPadding),
                  itemCount: userDataService.addresses.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: defaultPadding),
                  itemBuilder: (context, index) {
                    final address = userDataService.addresses[index];
                    return ListTile(
                      tileColor: Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadious),
                      ),
                      leading: Icon(
                        Icons.location_on_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(address),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: errorColor),
                        onPressed: () {
                          // Show a confirmation dialog before deleting
                          showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                title: const Text('Delete Address'),
                                content: const Text('Are you sure you want to delete this address?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Delete'),
                                    onPressed: () {
                                      userDataService.removeAddress(address);
                                      Navigator.of(dialogContext).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}