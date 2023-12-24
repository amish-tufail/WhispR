//
//  PhoneNumberView.swift
//  WhispR
//
//  Created by Amish on 16/07/2023.
//

import SwiftUI

struct PhoneNumberView: View {
    @Environment(AuthenticationViewModel.self) var authentication
    @State var phoneNumber: String = ""
    @State var animate: Bool = false
    @State var isEditing: Bool = false
    @State var didErrorOccured: Bool = false
    @State var errorMessage: String = ""
    @Binding var currentStep: OnboardingSteps
    
    var body: some View {
        ZStack {
            VStack {
                header
                textField
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
        PhoneNumberView(currentStep: .constant(.phoneNumber))
            .environment(AuthenticationViewModel())
    }
}



extension PhoneNumberView {
    var textField: some View {
        ZStack {
            GradientOverlay(cornerRadius: 12.0, color: .white)
            HStack {
                TextField("", text: $phoneNumber, prompt: Text("+92 123 1212345").foregroundStyle(.black.opacity(0.65)))
                    .foregroundStyle(.black)
                    .font(.Body)
                    .keyboardType(.phonePad)
                    .onTapGesture {
                        phoneNumber.append("+")
                    }
                    .onChange(of: phoneNumber) { oldValue, newValue in
                        if phoneNumber.count > 2 && phoneNumber.count < 4 {
                            phoneNumber.append(" ")
                            phoneNumber.append("(")
                        } else if phoneNumber.count > 7 && phoneNumber.count < 9 {
                            phoneNumber.append(")")
                            phoneNumber.append("-")
                        }
                    }
                Spacer()
                Button {
                    phoneNumber = ""
                    phoneNumber.append("+")
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.black)
                }
                .frame(width: 19.0, height: 19.0)
            }
            .padding()
        }
        .padding(.top, 34.0)
        .offset(x: animate ? 0.0 : -UIScreen.main.bounds.width)
        .animation(.easeInOut(duration: 0.55), value: animate)
    }
    
    var nextButton: some View {
        Button {
            authentication.sendPhoneNumber(phone: phoneNumber) { error in
                if error == nil {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentStep = .verification
                    }
                } else {
                    // Display error message to user
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
        .offset(x: animate ? 0.0 : -UIScreen.main.bounds.width)
        .animation(.easeInOut(duration: 0.55), value: animate)
    }
    
    var backButton: some View {
        Button {
            currentStep = .welcome
        } label: {
            OnboardingBackButtonLabel()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
        .offset(x: animate ? 0.0 : -UIScreen.main.bounds.width)
        .animation(.easeInOut(duration: 0.55), value: animate)
    }
    
    var header: some View {
        OnboardingHeader(title: "Verification", image: "person.fill.viewfinder", caption: "Enter you mobile number below. We'll send you a verification code after.")
            .offset(y: animate ? 0.0 : -UIScreen.main.bounds.height)
            .animation(.easeInOut(duration: 0.55), value: animate)
    }
    
    var image: some View {
        OnboardingImage(image: Image(.verfication), color: .orange)
            .offset(x: animate ? 0.0 : UIScreen.main.bounds.width)
            .animation(.easeInOut(duration: 0.75), value: animate)
    }
}
