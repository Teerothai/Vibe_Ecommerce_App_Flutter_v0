import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/flow_manager.dart';
import '../models/flow_state.dart';
import 'profile_screen.dart';
import 'contract_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Check if modal gating is needed after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowModals();
    });
  }

  void _checkAndShowModals() {
    final currentFlow = FlowManager().currentFlow;
    if (currentFlow == null) return;

    // Only show modals for DeepLinkPath when dashboard is locked
    if (currentFlow.flowType == UserFlowType.deepLinkPath && 
        currentFlow.needsModalGating) {
      
      if (!currentFlow.isPersonalInfoCompleted) {
        // Show Personal Info modal first
        _showPersonalInfoModal();
      } else if (!currentFlow.isContractSigned) {
        // Show Contract modal second
        _showContractModal();
      }
    }
  }

  void _showPersonalInfoModal() {
    showDialog(
      context: context,
      barrierDismissible: false, // Cannot dismiss by tapping outside
      builder: (context) => PopScope(
        canPop: false, // Disable back navigation
        child: Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.85,
            child: const ProfileScreen(isModal: true),
          ),
        ),
      ),
    ).then((_) {
      // After profile modal is dismissed, check if contract modal is needed
      setState(() {});
      Future.delayed(const Duration(milliseconds: 300), () {
        _checkAndShowModals();
      });
    });
  }

  void _showContractModal() {
    showDialog(
      context: context,
      barrierDismissible: false, // Cannot dismiss by tapping outside
      builder: (context) => PopScope(
        canPop: false, // Disable back navigation
        child: Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.85,
            child: const ContractScreen(isModal: true),
          ),
        ),
      ),
    ).then((_) {
      // After contract modal is dismissed, refresh the dashboard
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FlowManager(),
      builder: (context, child) {
        final currentFlow = FlowManager().currentFlow;
        final isDashboardLocked = currentFlow?.needsModalGating ?? false;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: isDashboardLocked ? null : () {}, // Disabled when locked
              ),
            ],
          ),
          body: Stack(
            children: [
              // Main Dashboard Content
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.mainPink, AppColors.lightPink],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: const Icon(
                                  Icons.pets,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isDashboardLocked ? 'Almost there!' : 'Welcome back!',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      isDashboardLocked 
                                          ? 'Complete setup to access all features'
                                          : 'Ready to explore new phones?',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Quick Actions
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2,
                      children: [
                        _buildQuickActionCard(
                          context,
                          icon: Icons.person_outline,
                          title: 'Complete Profile',
                          subtitle: 'Fill your details',
                          color: AppColors.purple,
                          isEnabled: !isDashboardLocked,
                          onTap: isDashboardLocked ? null : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfileScreen(),
                              ),
                            );
                          },
                        ),
                        _buildQuickActionCard(
                          context,
                          icon: Icons.description_outlined,
                          title: 'Sign Contract',
                          subtitle: 'Digital agreement',
                          color: AppColors.teal,
                          isEnabled: !isDashboardLocked,
                          onTap: isDashboardLocked ? null : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ContractScreen(),
                              ),
                            );
                          },
                        ),
                        _buildQuickActionCard(
                          context,
                          icon: Icons.shopping_bag_outlined,
                          title: 'My Orders',
                          subtitle: 'Track purchases',
                          color: AppColors.yellow,
                          isEnabled: !isDashboardLocked,
                          onTap: isDashboardLocked ? null : () {},
                        ),
                        _buildQuickActionCard(
                          context,
                          icon: Icons.chat_outlined,
                          title: 'Support Chat',
                          subtitle: 'Get help',
                          color: AppColors.mainPink,
                          isEnabled: !isDashboardLocked,
                          onTap: isDashboardLocked ? null : () {},
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Recent Activity
                    const Text(
                      'Recent Activity',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildActivityItem(
                      icon: Icons.phone_android,
                      title: 'iPhone 15 Pro viewed',
                      subtitle: '2 hours ago',
                      color: AppColors.purple,
                      isEnabled: !isDashboardLocked,
                    ),
                    _buildActivityItem(
                      icon: Icons.favorite,
                      title: 'Samsung Galaxy S24 liked',
                      subtitle: '1 day ago',
                      color: AppColors.mainPink,
                      isEnabled: !isDashboardLocked,
                    ),
                    _buildActivityItem(
                      icon: Icons.search,
                      title: 'Searched for "Google Pixel"',
                      subtitle: '2 days ago',
                      color: AppColors.teal,
                      isEnabled: !isDashboardLocked,
                    ),
                  ],
                ),
              ),
              
              // Lock Overlay (when dashboard is locked)
              if (isDashboardLocked)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.all(32),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppColors.yellow.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: const Icon(
                              Icons.lock_outline,
                              size: 32,
                              color: AppColors.brown,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Setup Required',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Please complete your profile and sign the contract to access your dashboard.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.darkGray,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildSetupStep(
                                'Profile',
                                currentFlow?.isPersonalInfoCompleted ?? false,
                              ),
                              Container(
                                width: 20,
                                height: 2,
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                color: AppColors.lightGray,
                              ),
                              _buildSetupStep(
                                'Contract',
                                currentFlow?.isContractSigned ?? false,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSetupStep(String label, bool isCompleted) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isCompleted ? AppColors.success : AppColors.lightGray,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isCompleted ? Icons.check : Icons.circle_outlined,
            size: 16,
            color: isCompleted ? Colors.white : AppColors.darkGray,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isCompleted ? AppColors.success : AppColors.darkGray,
            fontWeight: isCompleted ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isEnabled,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.5,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.darkGray,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isEnabled,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.5,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.darkGray,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}