import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resident/app_export.dart';

class ErrorScreen extends StatelessWidget {
  // final String errorMessage;
  // final VoidCallback onRetry;

  //ErrorScreen({required this.errorMessage, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/error_image.png',
                scale: 1,
              ),
              const SizedBox(height: 16),
              const Text(
                'Restoring Service!!!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "If App dosen't start after few minutes. Click the button below.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              )

              // ElevatedButton(
              //   onPressed: () {

              //   child: Text('Retry'),
              // ),
            ],
          ),
        ),
        persistentFooterAlignment: AlignmentDirectional.bottomCenter,
        persistentFooterButtons: [
          SizedBox(
            width: displaySize.width * 0.7,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppColors.appGold,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: () async {
               Phoenix.rebirth(context);
              },
              child: Text(
                'Try again',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.whiteA700),
              ),
            ),
          )
        ]);
  }
}

class NoConnectionScreen extends StatelessWidget {
  // final String errorMessage;
  // final VoidCallback onRetry;

  //ErrorScreen({required this.errorMessage, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.wifi_slash,
                color: Colors.grey.shade200,
                size: 32,
              ),
              const SizedBox(height: 16),
              const Text(
                "Poor Coonnection",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Please check your connection and try again",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // ElevatedButton(
              //   onPressed: () {

              //   child: Text('Retry'),
              // ),
            ],
          ),
        ),
        persistentFooterAlignment: AlignmentDirectional.bottomCenter,
        persistentFooterButtons: [
          SizedBox(
            width: displaySize.width * 0.7,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppColors.appGold,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: () async {
                 Phoenix.rebirth(context);
               
              },
              child: Text(
                'Try again',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.whiteA700),
              ),
            ),
          )
        ]);
  }
}
