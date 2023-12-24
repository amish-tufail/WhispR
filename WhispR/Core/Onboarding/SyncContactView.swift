//
//  SyncContactView.swift
//  WhispR
//
//  Created by Amish on 16/07/2023.
//

import SwiftUI

struct SyncContactView: View {
    @Environment(ContactsViewModel.self) var contacts
    @Binding var currentStep: OnboardingSteps
    @Binding var isOnboarding: Bool
    @State var animate: Bool = false
    var body: some View {
        VStack {
            Spacer()
            image
            header
            Spacer()
            continueButton
        }
        .padding(.horizontal)
        .foregroundStyle(.white)
        .overlay {
            backButton
        }
        .onAppear {
            animate = true
            try? contacts.getLocalContacts()
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        SyncContactView(currentStep: .constant(.contacts), isOnboarding: .constant(true))
            .environment(ContactsViewModel())
    }
}

extension SyncContactView {
    var backButton: some View {
        Button {
            currentStep = .profile
        } label: {
            OnboardingBackButtonLabel()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
        .offset(x: animate ? 0.0 : -UIScreen.main.bounds.width)
        .animation(.easeInOut(duration: 0.55), value: animate)
    }
    
    var continueButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.5)) {
                isOnboarding = false
            }
        } label: {
            OnboardingButtonLabel(text: "Continue")
        }
        .padding(.bottom, 87.0)
        .offset(y: animate ? 0.0 : UIScreen.main.bounds.height)
        .animation(.easeInOut(duration: 0.55), value: animate)
    }
    
    var header: some View {
        OnboardingHeader(title: "Awesome!", caption: "Continue to start chatting with your friends & family.")
        .offset(x: animate ? 0.0 : UIScreen.main.bounds.width)
        .animation(.easeInOut(duration: 0.55), value: animate)
    }
    
    var image: some View {
        Image(.onboardingAllSet)
            .offset(x: animate ? 0.0 : -UIScreen.main.bounds.width)
            .animation(.easeInOut(duration: 0.55), value: animate)
            .shadow(color: .cyan.opacity(0.55), radius: 50, x: 10.0, y: 10.0)
    }
}
