import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../data/dummy/notification_item.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    NotificationItem notificationItem = NotificationItem();
    int itemlength = notificationItem.items.length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
        elevation: 1.0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text('Unread($itemlength)'),
              ],
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notificationItem.items.length,
        itemBuilder: (context, index) {
          final notification = notificationItem.items[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                //color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: NotificationTile(
                notification: notification,
                onUpdate: () {
                  setState(() {
                    itemlength = itemlength - 1;
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class NotificationTile extends StatefulWidget {
  final Map<String, dynamic> notification;
  final Function onUpdate;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onUpdate,
  });

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.notification.length.toString()),
      background: Container(color: Colors.blueAccent),
      onUpdate: (key) {
        setState(() {
          widget.onUpdate;
        });
      },
      child: ListTile(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Iconsax.notification_status,
            size: 40,
          ),
        ),
        title: Text(
          widget.notification['title'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(widget.notification['time'],
                style: const TextStyle(color: Colors.grey)),
            if (widget.notification['course'].isNotEmpty)
              Text(widget.notification['course'],
                  style: const TextStyle(color: Colors.grey)),
          ],
        ),
        trailing: const Icon(Icons.more_vert),
        onTap: () {
          // Handle tap
        },
      ),
    );
  }
}
