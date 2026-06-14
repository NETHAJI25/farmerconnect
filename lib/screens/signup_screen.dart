import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../services/user_data.dart';
import '../services/supabase_service.dart';
import '../theme/app_theme.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  final districtController = TextEditingController();
  bool isLoading = false;
  bool obscurePassword = true;

  Future<void> registerUser() async {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty ||
        addressController.text.isEmpty ||
        districtController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await SupabaseService.supabase.from('users').insert({
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'password': passwordController.text.trim(),
        'address': addressController.text.trim(),
        'district': districtController.text.trim(),
      });

      UserData.name = nameController.text.trim();
      UserData.phone = phoneController.text.trim();
      UserData.address = addressController.text.trim();
      UserData.district = districtController.text.trim();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration Successful"),
          backgroundColor: AppTheme.primaryGreen,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration Failed: $e")),
      );
    }

    if (mounted) setState(() => isLoading = false);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    addressController.dispose();
    districtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_add, size: 40, color: AppTheme.primaryGreen),
            ),
            const SizedBox(height: 20),
            Text("Create Account", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Join FarmConnect as a farmer or buyer", style: TextStyle(color: AppTheme.textSecondary)),
            const SizedBox(height: 24),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name", prefixIcon: Icon(Icons.person)),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "Phone Number", prefixIcon: Icon(Icons.phone)),
            ),
            const SizedBox(height: 14),
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
            const SizedBox(height: 14),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: "Address", prefixIcon: Icon(Icons.location_on)),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: districtController,
              decoration: const InputDecoration(labelText: "District", prefixIcon: Icon(Icons.map)),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : registerUser,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text("Sign Up"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
