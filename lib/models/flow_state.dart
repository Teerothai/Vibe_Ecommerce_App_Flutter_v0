enum UserFlowType {
  checkoutPath,  // PostLogin_CheckoutPath
  deepLinkPath,  // PostLogin_DeepLinkPath
}

enum FlowStep {
  // Common steps
  otp,
  
  // CheckoutPath specific steps
  payment,
  personalInfo,
  contract,
  
  // DeepLinkPath specific steps
  lockedDashboard,
  personalInfoModal,
  contractModal,
  
  // Final state
  unlockedDashboard,
}

class FlowState {
  final UserFlowType flowType;
  final FlowStep currentStep;
  final bool isPersonalInfoCompleted;
  final bool isContractSigned;
  
  const FlowState({
    required this.flowType,
    required this.currentStep,
    this.isPersonalInfoCompleted = false,
    this.isContractSigned = false,
  });
  
  FlowState copyWith({
    UserFlowType? flowType,
    FlowStep? currentStep,
    bool? isPersonalInfoCompleted,
    bool? isContractSigned,
  }) {
    return FlowState(
      flowType: flowType ?? this.flowType,
      currentStep: currentStep ?? this.currentStep,
      isPersonalInfoCompleted: isPersonalInfoCompleted ?? this.isPersonalInfoCompleted,
      isContractSigned: isContractSigned ?? this.isContractSigned,
    );
  }
  
  bool get canAccessUnlockedDashboard {
    return currentStep == FlowStep.unlockedDashboard;
  }
  
  bool get needsModalGating {
    return flowType == UserFlowType.deepLinkPath && 
           (!isPersonalInfoCompleted || !isContractSigned);
  }
}