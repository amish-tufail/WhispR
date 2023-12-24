//
//  OnboardingContainerView.swift
//  WhispR
//
//  Created by Amish on 16/07/2023.
//

import SwiftUI

enum OnboardingSteps: Int {
    case welcome = 0
    case phoneNumber = 1
    case verification = 2
    case profile = 3
    case contacts = 4
}

struct OnboardingContainerView: View {
    @State var currentStep: OnboardingSteps = .welcome
    @State var animate: Bool = false
    @Binding var isOnboarding: Bool
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            switch currentStep {
            case .welcome:
                WelcomeView(currentStep: $currentStep)
//                    .transition(.move(edge: .bottom))
            case .phoneNumber:
                PhoneNumberView(currentStep: $currentStep)
//                    .transition(.move(edge: .bottom))
            case .verification:
                VerificationView(currentStep: $currentStep, isOnboarding: $isOnboarding)
//                    .transition(.move(edge: .bottom))
            case .profile:
                CreateProfileView(currentStep: $currentStep)
//                    .transition(.move(edge: .bottom))
            case .contacts:
                SyncContactView(currentStep: $currentStep, isOnboarding: $isOnboarding)
//                    .transition(.move(edge: .bottom))
            }
        }
    }
}

#Preview {
    OnboardingContainerView(isOnboarding: .constant(true))
}
