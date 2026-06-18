import 'package:flutter/material.dart';
import 'login_signup.dart';
import 'main_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ─── Form Key & Controllers ───────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // state to toggle password visibility
  bool _isPasswordObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ─── Validation Method Execution ──────────────────────────────────────────
  void _submitLoginForm() {
    if (_formKey.currentState!.validate()) {
      // Inputs are entirely valid! Route to home shell layout
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainShell()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: SingleChildScrollView( // Prevents layout overflows when the keyboard shows up
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey, // <-- Binds layout trees for centralized checks
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),

                  // ── App logo ───────────────────────────────────────────────────
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF333333), width: 1),
                      ),
                      child: const Icon(
                        Icons.calendar_today_outlined,
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'EventHub',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Discover & manage events',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),

                  const SizedBox(height: 40),

                  // ── Email field ────────────────────────────────────────────────
                  const Text(
                    'Email address',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextFormField( // <-- Swapped from TextField to TextFormField
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText: 'user@example.com',
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 4.0),
                        child: Icon(Icons.mail_outline, size: 20),
                      ),
                    ),
                    // Email matching patterns block
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email address';
                      }
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // ── Password field ─────────────────────────────────────────────
                  const Text(
                    'Password',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextFormField( // <-- Swapped from TextField to TextFormField
                    controller: _passwordController,
                    obscureText: _isPasswordObscured,
                    style: const TextStyle(color: Colors.white),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submitLoginForm(), // Allows validation submit on keyboard click
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 4.0),
                        child: Icon(Icons.lock_outline, size: 20),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordObscured ? Icons.visibility_off : Icons.visibility,
                          color: const Color(0xFF5A5A65),
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordObscured = !_isPasswordObscured;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  // ── Forgot password ────────────────────────────────────────────
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Sign-in button → MainShell ─────────────────────────────────
                  ElevatedButton(
                    onPressed: _submitLoginForm, // Calls unified validation sequence
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      minimumSize: const Size.fromHeight(54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Divider ────────────────────────────────────────────────────
                  Row(
                    children: const [
                      Expanded(child: Divider(color: Color(0xFF2C2C2C), thickness: 1)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('or', style: TextStyle(color: Colors.grey, fontSize: 14)),
                      ),
                      Expanded(child: Divider(color: Color(0xFF2C2C2C), thickness: 1)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Google SSO button ──────────────────────────────────────────
                  OutlinedButton(
  onPressed: () {
    // Force validation checks before allowing the Google action to proceed
    if (_formKey.currentState!.validate()) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainShell()),
        (route) => false,
      );
    }
  },
  style: OutlinedButton.styleFrom(
    minimumSize: const Size.fromHeight(54),
    side: const BorderSide(color: Color(0xFF2C2C2C), width: 1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    backgroundColor: const Color(0xFF1E1E1E).withValues(alpha: 0.3),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      Text(
        'G ',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
      ),
      SizedBox(width: 4),
      Text(
        'Continue with Google',
        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ],
  ),
),

                  const SizedBox(height: 40),

                  // ── Sign-up link ───────────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignUpScreen()),
                          );
                        },
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}