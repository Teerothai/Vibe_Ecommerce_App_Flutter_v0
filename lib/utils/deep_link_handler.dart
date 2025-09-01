import 'package:flutter/material.dart';
import 'flow_manager.dart';
import '../screens/login_screen.dart';

class DeepLinkHandler {
  static final DeepLinkHandler _instance = DeepLinkHandler._internal();
  factory DeepLinkHandler() => _instance;
  DeepLinkHandler._internal();

  void handleDeepLink(BuildContext context, String deepLinkUrl) {
    // Parse deep link to determine if it's a valid SHIBA phone deep link
    if (_isValidShibaDeepLink(deepLinkUrl)) {
      // Initialize DeepLink flow
      FlowManager().initializeDeepLinkFlow();
      
      // Navigate to login screen for OTP verification
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(isDeepLinkEntry: true),
        ),
        (route) => false, // Clear navigation stack
      );
    }
  }

  bool _isValidShibaDeepLink(String url) {
    // Simple validation - in real app, this would be more sophisticated
    return url.contains('shibaphone://') || 
           url.contains('shiba-phone.app') ||
           url.contains('shiba.link');
  }

  void simulateDeepLinkEntry(BuildContext context) {
    // For testing purposes - simulates receiving a deep link
    handleDeepLink(context, 'shibaphone://dashboard?user_id=123');
  }
}