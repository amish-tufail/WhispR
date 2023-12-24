//
//  VerificationView.swift
//  WhispR
//
//  Created by Amish on 16/07/2023.
//

import SwiftUI

struct VerificationView: View {
    @Environment(AuthenticationViewModel.self) var authentication
    @Environment(ContactsViewModel.self) var contacts
    @Environment(ChatViewModel.self) var chats
    @State private var gradientOffset: CGFloat = 0.0
    @State var optNumber: String = ""
    @State var didErrorOccured: Bool = false
    @State var errorMessage: String = ""
    @Binding var currentStep: OnboardingSteps
    @Binding var isOnboarding: Bool
    @State var animate: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                header
                otpView
                Spacer()
                image
                Spacer()
                nextButton
            }
            .foregroundStyle(.white)
            .padding(.horizontal)
            .overlay {
                backButton
            }
            .onAppear {
                animate = true
            }
            if didErrorOccured {
                Alert(didErrorOccured: $didErrorOccured, alertTitle: "Alert", alertMessage: errorMessage)
                    .zIndex(1.0)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VerificationView(currentStep: .constant(.verification), isOnboarding: .constant(false))
            .environment(AuthenticationViewModel())
            .environment(ContactsViewModel())
    }
}

extension VerificationView {
    var backButton: some View {
        Button {
            currentStep = .phoneNumber
        } label: {
            OnboardingBackButtonLabel()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
        .offset(x: animate ? 0.0 : -UIScreen.main.bounds.width)
        .animation(.easeInOut(duration: 0.55), value: animate)
    }
    
    var nextButton: some View {
        Button {
            authentication.verifyCode(code: optNumber) { error in
                if error == nil {
                    DatabaseServices.shared.checkUserProfile { exists in
                        if exists {
                            isOnboarding = false
//                            try? contacts.getLocalContacts()
//                            chats.getChats()
                        } else {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentStep = .profile
                            }                            
                        }
                    }
                } else {
                    // Display error to user
                    withAnimation(.easeOut) {
                        didErrorOccured = true
                    }
                    errorMessage = error?.localizedDescription ?? ""
                    print(error?.localizedDescription ?? "")
                }
            }
        } label: {
            OnboardingButtonLabel(text: "Next", image: "chevron.right")
        }
        .padding(.bottom, 87.0)
        .offset(x: animate ? 0.0 : UIScreen.main.bounds.width)
        .animation(.easeInOut(duration: 0.55), value: animate)
    }
    
    var header: some View {
        OnboardingHeader(title: "Verification", image: "person.fill.viewfinder", caption: "Enter the 6-digtit verification code we sent to your device.")
        .offset(y: animate ? 0.0 : -UIScreen.main.bounds.height)
        .animation(.easeInOut(duration: 0.55), value: animate)
    }
    
    var image: some View {
        OnboardingImage(image: Image(.otpVerification), color: .orange)
            .scaleEffect(0.9)
            .offset(x: animate ? 0.0 : -UIScreen.main.bounds.width)
            .animation(.easeInOut(duration: 0.75), value: animate)
    }
    
    var otpView: some View {
        OPTView(otpText: $optNumber)
            .padding(.top, 34.0)
            .offset(x: animate ? 0.0 : UIScreen.main.bounds.width)
            .animation(.easeInOut(duration: 0.55), value: animate)
    }
}

