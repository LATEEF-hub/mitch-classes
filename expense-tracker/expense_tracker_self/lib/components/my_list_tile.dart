import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyListTile extends StatelessWidget {
  final String title;
  final String trailing;
  final void Function(BuildContext)? onEditPressed;
  final void Function(BuildContext)? onDeletePressed;

  const MyListTile({
    super.key,
    required this.title,
    required this.trailing,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          //setting option
          SlidableAction(
            onPressed: onEditPressed,
            icon: Icons.settings,
            foregroundColor: Colors.white,
            backgroundColor: Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),

          //delete option
          SlidableAction(
            onPressed: onDeletePressed,
            icon: Icons.delete,
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
      child: SizedBox(
        height: 45,
        child: ListTile(
          title: Text(title),
          trailing: Text(trailing),
        ),
      ),
    );
  }
}
