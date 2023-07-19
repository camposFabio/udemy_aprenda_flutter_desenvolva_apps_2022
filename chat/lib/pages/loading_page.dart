import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              backgroundColor:
                  Theme.of(context).primaryTextTheme.headlineMedium?.color,
            ),
            const SizedBox(height: 5),
            Text('Carregando..',
                style: TextStyle(
                    color: Theme.of(context)
                        .primaryTextTheme
                        .headlineMedium
                        ?.color)),
          ],
        ),
      ),
    );
  }
}
