import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/flow_manager.dart';
import '../models/flow_state.dart';
import 'dashboard_screen.dart';

class ContractScreen extends StatefulWidget {
  final bool isModal;

  const ContractScreen({super.key, this.isModal = false});

  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen> {
  bool _agreedToTerms = false;
  bool _agreedToPrivacy = false;
  bool _isLoading = false;

  void _signContract() async {
    if (!_agreedToTerms || !_agreedToPrivacy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to all terms and conditions'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate contract signing
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isLoading = false;
    });

    // Mark contract as completed
    FlowManager().completeContract();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contract signed successfully!'),
        backgroundColor: AppColors.success,
      ),
    );

    // Navigate based on context
    _navigateAfterContractSigning();
  }

  void _navigateAfterContractSigning() {
    final currentFlow = FlowManager().currentFlow;
    
    if (widget.isModal) {
      // If this is a modal in DeepLinkPath, pop back to dashboard
      // The dashboard will unlock since both modals are now completed
      Navigator.pop(context);
    } else {
      // If this is part of CheckoutPath flow, navigate to unlocked dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Contract'),
        automaticallyImplyLeading: !widget.isModal, // No back button for modals
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.teal.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Icon(
                            Icons.description,
                            size: 40,
                            color: AppColors.teal,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Service Agreement',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.isModal 
                              ? 'Please sign the contract to complete setup'
                              : 'Please review and sign the digital contract',
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.darkGray,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Contract Content
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SHIBA Phone Service Agreement',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '1. Service Terms',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'By purchasing a device through SHIBA Phone, you agree to our installment payment plan and service terms. Monthly payments are due on the same date each month.',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '2. Payment Terms',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Installment payments are automatically charged to your selected payment method. Late payments may incur additional fees.',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '3. Device Protection',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Your device is covered under manufacturer warranty. Additional protection plans are available for purchase.',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '4. Cancellation Policy',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'You may cancel your service within 14 days of purchase. Early termination fees may apply for installment plans.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Checkboxes
                  CheckboxListTile(
                    value: _agreedToTerms,
                    onChanged: (value) {
                      setState(() {
                        _agreedToTerms = value ?? false;
                      });
                    },
                    title: const Text(
                      'I agree to the Terms and Conditions',
                      style: TextStyle(fontSize: 14),
                    ),
                    activeColor: AppColors.mainPink,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  
                  CheckboxListTile(
                    value: _agreedToPrivacy,
                    onChanged: (value) {
                      setState(() {
                        _agreedToPrivacy = value ?? false;
                      });
                    },
                    title: const Text(
                      'I agree to the Privacy Policy',
                      style: TextStyle(fontSize: 14),
                    ),
                    activeColor: AppColors.mainPink,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Digital Signature Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.mainPink),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.draw,
                          size: 40,
                          color: AppColors.mainPink,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Digital Signature',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Your digital signature will be applied when you sign the contract',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.darkGray,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Action
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _signContract,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Sign Contract',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}