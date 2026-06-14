import 'package:flutter/material.dart';
import 'signup_screen.dart';
import '../services/supabase_service.dart';
import '../services/current_user.dart';
import '../services/user_data.dart';
import '../main.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool obscurePassword = true;

  Future<void> loginUser() async {
    if (phoneController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter Phone and Password")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await SupabaseService.supabase
          .from('users')
          .select()
          .eq('phone', phoneController.text.trim())
          .eq('password', passwordController.text.trim());

      if (result.isNotEmpty) {
        CurrentUser.name = result[0]['name'];
        CurrentUser.phone = result[0]['phone'];
        CurrentUser.address = result[0]['address'];
        CurrentUser.district = result[0]['district'];
        UserData.name = result[0]['name'];
        UserData.phone = result[0]['phone'];
        UserData.address = result[0]['address'];
        UserData.district = result[0]['district'];

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AppShell()),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid Phone Number or Password")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Error: $e")),
      );
    }

    if (mounted) setState(() => isLoading = false);
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, size: 48, color: AppTheme.primaryGreen),
            ),
            const SizedBox(height: 24),
            Text("Welcome Back", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Login to your FarmConnect account", style: TextStyle(color: AppTheme.textSecondary)),
            const SizedBox(height: 32),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: obscurePassword,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => obscurePassword = !obscurePassword),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : loginUser,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text("Login"),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignupScreen()),
                );
              },
              child: RichText(
                text: TextSpan(
                  text: "New User? ",
                  style: TextStyle(color: AppTheme.textSecondary),
                  children: const [
                    TextSpan(
                      text: "Register",
                      style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
