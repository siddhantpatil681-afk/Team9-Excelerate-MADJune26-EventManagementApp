import 'package:flutter/material.dart';
import 'login_signup.dart';
import 'profile_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 3),
              
       
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
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              
              const Spacer(flex: 2),

              
              const Text(
                'Email address',
                style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'user@example.com',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Icon(Icons.mail_outline, size: 20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
             
              const Text(
                'Password',
                style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              const TextField(
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '••••••••',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Icon(Icons.lock_outline, size: 20),
                  ),
                ),
              ),
              
           
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

         
              ElevatedButton(
                onPressed: () {

                  Navigator.push(
               context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
               );

                },
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
              
              
              Row(
                children: const [
                  Expanded(child: Divider(color: Color(0xFF2C2C2C), thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'or',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                  Expanded(child: Divider(color: Color(0xFF2C2C2C), thickness: 1)),
                ],
              ),
              
              const SizedBox(height: 20),

              
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  side: const BorderSide(color: Color(0xFF2C2C2C), width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: const Color(0xFF1E1E1E).withValues(alpha:0.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'G ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Continue with Google',
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              
              const Spacer(flex: 3),

              
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
    );
  }
}