import 'package:chat/components/messages.dart';
import 'package:chat/components/new_message.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:chat/core/services/notification/chat_notification_service.dart';
import 'package:chat/pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cod3r chat'),
        actions: [
          PopupMenuButton(
            //color: Colors.white,
            icon: const Icon(
              Icons.more_vert,
            ),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(
                      Icons.exit_to_app,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('Sair'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'logout') {
                AuthService().logout();
              }
            },
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const NotificationPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.notifications),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: CircleAvatar(
                  backgroundColor: Colors.red.shade800,
                  maxRadius: 10,
                  child: Text(
                    '${Provider.of<ChatNotificationService>(context).itemsCount}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: const SafeArea(
        child: Column(
          children: [
            Expanded(child: Messages()),
            NewMessage(),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Provider.of<ChatNotificationService>(context, listen: false).add(
      //       ChatNotification(
      //           title: 'title', body: DateTime.now().toIso8601String()),
      //     );
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
