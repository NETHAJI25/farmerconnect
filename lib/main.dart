import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'navigation/main_shell.dart';
import 'screens/home_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/sell_products_screen.dart';
import 'screens/profile_screen.dart';
import 'services/app_data.dart';
import 'models/product.dart';

final ThemeProvider themeProvider = ThemeProvider();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: 'https://zsnyutuyfygkwlmjbiyv.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inpzbnl1dHV5Znlna3dsbWpiaXl2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODAwNjA0ODksImV4cCI6MjA5NTYzNjQ4OX0.hutUDmpgMtN1o7VX06k_CmgNZp6kSarhzdBRdv8hqpY',
    );
  } catch (_) {}

  _initAppData();

  runApp(const FarmConnectApp());
}

void _initAppData() {
  if (AppData.products.isNotEmpty) return;
  AppData.products.addAll([
    // Fruits
    Product(farmerName: "Ramesh", phone: "9876543210", address: "Coimbatore", category: "Fruits", productName: "Fresh Mangoes", price: 80, quantity: 50),
    Product(farmerName: "Priya", phone: "9876543212", address: "Ooty", category: "Fruits", productName: "Strawberries", price: 120, quantity: 30),
    Product(farmerName: "Senthil", phone: "9876543220", address: "Dindigul", category: "Fruits", productName: "Red Apples", price: 140, quantity: 60),
    Product(farmerName: "Meena", phone: "9876543221", address: "Kodaikanal", category: "Fruits", productName: "Organic Bananas", price: 40, quantity: 100),
    Product(farmerName: "Gopal", phone: "9876543222", address: "Krishnagiri", category: "Fruits", productName: "Fresh Grapes", price: 90, quantity: 45),
    Product(farmerName: "Lakshmi", phone: "9876543223", address: "Palani", category: "Fruits", productName: "Pomegranate", price: 160, quantity: 25),
    Product(farmerName: "Rajesh", phone: "9876543224", address: "Thanjavur", category: "Fruits", productName: "Papaya", price: 50, quantity: 80),
    // Vegetables
    Product(farmerName: "Suresh", phone: "9876543211", address: "Erode", category: "Vegetables", productName: "Organic Tomatoes", price: 40, quantity: 100),
    Product(farmerName: "Murugan", phone: "9876543215", address: "Salem", category: "Vegetables", productName: "Green Chillies", price: 30, quantity: 25),
    Product(farmerName: "Anjali", phone: "9876543225", address: "Ooty", category: "Vegetables", productName: "Spinach", price: 25, quantity: 60),
    Product(farmerName: "Karthik", phone: "9876543226", address: "Coimbatore", category: "Vegetables", productName: "Fresh Onions", price: 35, quantity: 120),
    Product(farmerName: "Devi", phone: "9876543227", address: "Mettupalayam", category: "Vegetables", productName: "Potatoes", price: 28, quantity: 150),
    Product(farmerName: "Sundar", phone: "9876543228", address: "Erode", category: "Vegetables", productName: "Brinjals", price: 32, quantity: 70),
    Product(farmerName: "Valli", phone: "9876543229", address: "Pollachi", category: "Vegetables", productName: "Cabbage", price: 22, quantity: 90),
    // Grains
    Product(farmerName: "Kumar", phone: "9876543213", address: "Thanjavur", category: "Grains", productName: "Basmati Rice", price: 90, quantity: 200),
    Product(farmerName: "Bharathi", phone: "9876543230", address: "Tiruvannamalai", category: "Grains", productName: "Toor Dal", price: 110, quantity: 80),
    Product(farmerName: "Mani", phone: "9876543231", address: "Ariyalur", category: "Grains", productName: "Whole Wheat", price: 38, quantity: 160),
    // Dairy
    Product(farmerName: "Lakshmi", phone: "9876543214", address: "Dindigul", category: "Dairy", productName: "Fresh Milk", price: 56, quantity: 40),
    Product(farmerName: "Gomathi", phone: "9876543232", address: "Avinashi", category: "Dairy", productName: "Curd", price: 45, quantity: 35),
    Product(farmerName: "Siva", phone: "9876543233", address: "Udumalaipettai", category: "Dairy", productName: "Ghee", price: 320, quantity: 20),
    // Herbs
    Product(farmerName: "Nirmala", phone: "9876543234", address: "Kodaikanal", category: "Herbs", productName: "Fresh Mint", price: 15, quantity: 50),
    Product(farmerName: "Selvi", phone: "9876543235", address: "Ooty", category: "Herbs", productName: "Coriander", price: 12, quantity: 60),
    // Poultry
    Product(farmerName: "Sekar", phone: "9876543236", address: "Namakkal", category: "Poultry", productName: "Farm Eggs", price: 72, quantity: 100),
    Product(farmerName: "Velan", phone: "9876543237", address: "Salem", category: "Poultry", productName: "Chicken", price: 180, quantity: 30),
  ]);
}

class FarmConnectApp extends StatelessWidget {
  const FarmConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, _) {
        return SelectionArea(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'FarmConnect',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const WelcomeScreen(),
            routes: {
              '/login': (context) => const LoginScreen(),
              '/signup': (context) => const SignupScreen(),
              '/home': (context) => const AppShell(),
            },
          ),
        );
      },
    );
  }
}

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return MainShell(
      screens: const [
        HomeScreen(),
        CategoriesScreen(),
        CartScreen(),
        SellProductsScreen(),
        ProfileScreen(),
      ],
    );
  }
}
