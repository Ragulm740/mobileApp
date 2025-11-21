import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:mobile_app/screens/dashboard_screen.dart';
import 'package:mobile_app/utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _otpController = TextEditingController();
  
  bool _isOtpEnabled = false;
  bool _isLoading = false;
  bool _isOtpSent = false;
  String? _generatedOtp;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _otpController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _validateMobileNumber() {
    final mobile = _mobileController.text;
    if (Validators.isValidMobile(mobile)) {
      setState(() {
        _isOtpEnabled = true;
      });
    } else {
      setState(() {
        _isOtpEnabled = false;
        _isOtpSent = false;
      });
    }
  }

  Future<void> _sendOtp() async {
    if (!Validators.isValidMobile(_mobileController.text)) {
      _showError('Please enter a valid mobile number');
      return;
    }

    setState(() => _isLoading = true);
    
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Generate mock OTP
    _generatedOtp = '1234';
    
    setState(() {
      _isLoading = false;
      _isOtpSent = true;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP sent successfully! Use: $_generatedOtp'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (!_isOtpSent) {
      _showError('Please send OTP first');
      return;
    }

    final enteredOtp = _otpController.text;
    
    setState(() => _isLoading = true);
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() => _isLoading = false);

    // Mock OTP validation
    if (enteredOtp == _generatedOtp) {
      // Save user data
      final box = await Hive.openBox('user_data');
      await box.put('isLoggedIn', true);
      await box.put('userName', 'John Doe');
      await box.put('mobile', _mobileController.text);
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    } else {
      _showError('Invalid OTP. Please try again.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo/Icon
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.lock_outline,
                              size: 48,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Title
                          Text(
                            'Welcome Back',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Login to continue',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Mobile Number Field
                          TextFormField(
                            controller: _mobileController,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            onChanged: (value) => _validateMobileNumber(),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            decoration: InputDecoration(
                              labelText: 'Mobile Number',
                              hintText: 'Enter 10 digit mobile number',
                              prefixIcon: const Icon(Icons.phone),
                              counterText: '',
                              suffixIcon: _isOtpEnabled
                                  ? const Icon(Icons.check_circle, color: Colors.green)
                                  : null,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter mobile number';
                              }
                              if (!Validators.isValidMobile(value)) {
                                return 'Please enter valid 10 digit number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          // Send OTP Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _isOtpEnabled && !_isLoading ? _sendOtp : null,
                              icon: const Icon(Icons.send),
                              label: Text(_isOtpSent ? 'Resend OTP' : 'Send OTP'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // OTP Field
                          TextFormField(
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            maxLength: 4,
                            enabled: _isOtpSent,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            decoration: InputDecoration(
                              labelText: 'OTP',
                              hintText: 'Enter 4 digit OTP',
                              prefixIcon: const Icon(Icons.password),
                              counterText: '',
                              helperText: _isOtpSent ? 'OTP: $_generatedOtp' : null,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter OTP';
                              }
                              if (value.length != 4) {
                                return 'OTP must be 4 digits';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          
                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isOtpSent && !_isLoading ? _login : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Login'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}