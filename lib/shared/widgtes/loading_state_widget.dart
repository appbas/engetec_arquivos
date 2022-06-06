import 'package:flutter/material.dart';

class LoadingStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;

  const LoadingStateWidget(
      {Key? key, required this.message, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 30,
            color: Theme.of(context).colorScheme.primary,
          ),
          Text(
            message,
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
