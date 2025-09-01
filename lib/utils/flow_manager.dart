import 'package:flutter/material.dart';
import '../models/flow_state.dart';

class FlowManager extends ChangeNotifier {
  static final FlowManager _instance = FlowManager._internal();
  factory FlowManager() => _instance;
  FlowManager._internal();

  FlowState? _currentFlow;
  
  FlowState? get currentFlow => _currentFlow;
  
  void initializeCheckoutFlow() {
    _currentFlow = const FlowState(
      flowType: UserFlowType.checkoutPath,
      currentStep: FlowStep.otp,
    );
    notifyListeners();
  }
  
  void initializeDeepLinkFlow() {
    _currentFlow = const FlowState(
      flowType: UserFlowType.deepLinkPath,
      currentStep: FlowStep.otp,
    );
    notifyListeners();
  }
  
  void updateStep(FlowStep step) {
    if (_currentFlow != null) {
      _currentFlow = _currentFlow!.copyWith(currentStep: step);
      notifyListeners();
    }
  }
  
  void completePersonalInfo() {
    if (_currentFlow != null) {
      _currentFlow = _currentFlow!.copyWith(
        isPersonalInfoCompleted: true,
        currentStep: _getNextStepAfterPersonalInfo(),
      );
      notifyListeners();
    }
  }
  
  void completeContract() {
    if (_currentFlow != null) {
      _currentFlow = _currentFlow!.copyWith(
        isContractSigned: true,
        currentStep: FlowStep.unlockedDashboard,
      );
      notifyListeners();
    }
  }
  
  FlowStep _getNextStepAfterPersonalInfo() {
    if (_currentFlow!.flowType == UserFlowType.checkoutPath) {
      return FlowStep.contract;
    } else {
      // DeepLinkPath - check if contract is also completed
      return _currentFlow!.isContractSigned 
          ? FlowStep.unlockedDashboard 
          : FlowStep.contractModal;
    }
  }
  
  void resetFlow() {
    _currentFlow = null;
    notifyListeners();
  }
  
  String getNextScreenRoute() {
    if (_currentFlow == null) return '/home';
    
    switch (_currentFlow!.currentStep) {
      case FlowStep.otp:
        return '/login';
      case FlowStep.payment:
        return '/payment';
      case FlowStep.personalInfo:
        return '/profile';
      case FlowStep.contract:
        return '/contract';
      case FlowStep.lockedDashboard:
      case FlowStep.personalInfoModal:
      case FlowStep.contractModal:
      case FlowStep.unlockedDashboard:
        return '/dashboard';
    }
  }
}