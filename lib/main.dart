import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/dashboard_screen.dart';
import 'utils/app_colors.dart';
import 'utils/flow_manager.dart';
import 'utils/deep_link_handler.dart';

void main() {
  runApp(const ShibaPhoneApp());
}

class ShibaPhoneApp extends StatefulWidget {
  const ShibaPhoneApp({super.key});

  @override
  State<ShibaPhoneApp> createState() => _ShibaPhoneAppState();
}

class _ShibaPhoneAppState extends State<ShibaPhoneApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  void _initializeApp() {
    // Reset flow state on app start
    FlowManager().resetFlow();
    
    // Set up deep link handling (in real app, this would use proper deep link packages)
    _setupDeepLinkHandling();
  }

  void _setupDeepLinkHandling() {
    // This is a simplified version. In a real app, you'd use packages like:
    // - uni_links
    // - app_links
    // - firebase_dynamic_links
    
    // For testing, you can simulate deep links through debug methods
  }

  // Method to simulate deep link for testing
  void simulateDeepLink() {
    final context = navigatorKey.currentContext;
    if (context != null) {
      DeepLinkHandler().simulateDeepLinkEntry(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shiba Phone',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        primaryColor: AppColors.mainPink,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainPink,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
      // Use initialRoute instead of home when defining routes
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}

// Extension to make deep link simulation available in debug mode
extension DeepLinkSimulation on _ShibaPhoneAppState {
  void testDeepLink() {
    simulateDeepLink();
  }
}