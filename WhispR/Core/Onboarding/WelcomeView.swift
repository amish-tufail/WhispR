 //
//  WelcomeView.swift
//  WhispR
//
//  Created by Amish on 16/07/2023.
//

import SwiftUI

struct WelcomeView: View {
    @State var animate: Bool = false
    @State var policyAppear: Bool = false
    @Binding var currentStep: OnboardingSteps
    
    var body: some View {
        VStack {
            Spacer()
            headerImage
            mainText
            Spacer()
            getStartedButton
            privacyPolicy
        }
        .foregroundStyle(.white)
        .padding(.horizontal)
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        WelcomeView(currentStep: .constant(.welcome))
    }
}

extension WelcomeView {
    var privacyPolicy: some View {
        HStack(spacing: 0.0) {
            Text("By tapping 'Get Started' you agree to our ")
            Text("Privacy Policy.")
                .underline()
                .foregroundStyle(
                    LinearGradient(colors: [Color.yellow, Color.orange], startPoint: .leading, endPoint: .trailing)
                )
                .onTapGesture {
                    policyAppear = true
                }
                .sheet(isPresented: $policyAppear) {
                    PrivacyPolicyView(policyAppear: $policyAppear)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.automatic)
                }
        }
        .offset(y: animate ? 0.0 : UIScreen.main.bounds.height)
        .font(.Caption)
        .padding(.top, 14.0)
        .padding(.bottom, 61.0)
        .animation(.easeInOut(duration: 0.75), value: animate)
    }
    
    var getStartedButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.5)) {
                currentStep = .phoneNumber
            }
        } label: {
            OnboardingButtonLabel(text: "Get Started", image: "person.fill.viewfinder")
        }
        .frame(maxWidth: 440.0) // For IPADS
        .offset(y: animate ? 0.0 : UIScreen.main.bounds.height)
        .animation(.easeInOut(duration: 0.55), value: animate)
    }
    
    var mainText: some View {
        VStack(alignment: .leading, spacing: 25.0) {
            VStack(alignment: .leading, spacing: 7.0) {
                Text("Welcome to")
                Text("WhispR")
                    .tracking(25)
                    .foregroundStyle(
                        LinearGradient(colors: [Color.yellow, Color.orange, Color.pink, Color.cyan], startPoint: .leading, endPoint: .trailing)
                    )
                    .animation(.easeInOut(duration: 0.75), value: animate)
            }
            .font(Font.custom("LexendDeca-Bold", size: 34))
            Text("Simple and fuss-free chat experience.")
                .font(.Settings)
                .foregroundStyle(.white.opacity(0.75))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 32.0)
        .offset(x: animate ? 0.0 : -UIScreen.main.bounds.width)
        .animation(.easeInOut(duration: 0.55), value: animate)
    }
    
    var headerImage: some View {
        OnboardingImage(image: Image(.welcome), color: .orange)
            .offset(y: animate ? 0.0 : -UIScreen.main.bounds.height)
            .animation(.easeInOut(duration: 0.55), value: animate)
    }
}
