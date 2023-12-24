//
//  CreateProfileView.swift
//  WhispR
//
//  Created by Amish on 16/07/2023.
//

import SwiftUI

struct CreateProfileView: View {
    @Environment(AuthenticationViewModel.self) var authentication
    @State private var gradientColors: [Color] = [Color.pink, Color.orange, Color.cyan, Color.yellow]
    @Binding var currentStep: OnboardingSteps
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var animate: Bool = false
    @State var selectedImage: UIImage?
    @State var isPhotoPickerShowing: Bool = false
    @State var isSourceMenuShowing: Bool = false
    @State var source: UIImagePickerController.SourceType = .photoLibrary
    @State var isnextButtonDisabled: Bool = false
    
    var body: some View {
        VStack {
            header
            Spacer()
            photoSection
            Spacer()
            textFields
            Spacer()
            nextButton
        }
        .padding(.horizontal)
        .foregroundStyle(.white)
        .overlay {
            backButton
        }
        .onAppear {
            animate = true
        }
        .confirmationDialog("From where?", isPresented: $isSourceMenuShowing) {
            Button {
                self.source = .photoLibrary
                isPhotoPickerShowing = true
            } label: {
                Text("Photo Library")
            }
            Button {
                self.source = .camera
                isPhotoPickerShowing = true
            } label: {
                Text("Take Photo")
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        CreateProfileView(currentStep: .constant(.profile), source: .photoLibrary)
            .environment(AuthenticationViewModel())
    }
}


extension CreateProfileView {
    var photoLabel: some View {
        ZStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
            } else {
                Circle()
                    .foregroundStyle(.white)
                Image(systemName: "camera.viewfinder")
                    .imageScale(.medium)
                    .foregroundStyle(
                        .black
                    )
            }
            Circle()
                .stroke(
                    LinearGradient(colors: gradientColors, startPoint: .top, endPoint: .bottom),
                    lineWidth: 3.0
                )
                .animation(.linear(duration: 3).repeatForever(), value: gradientColors)
                .onAppear {
                    startAnimation()
                }
        }
        .frame(width: 70.0, height: 70.0)
    }
    
    var nextButton: some View {
        Button {
            isnextButtonDisabled = true
            DatabaseServices.shared.setUserProfile(firstName: firstName, lastName: lastName, image: selectedImage) { isSuccess in
                if isSuccess {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentStep = .contacts
                    }
                } else {
                    // Display error to user
                }
                isnextButtonDisabled = false
            }
        } label: {
            OnboardingButtonLabel(text: isnextButtonDisabled ? "Uploading" : "Save", image: isnextButtonDisabled ? "timelapse" : "square.and.arrow.down")
        }
        .padding(.bottom, 87.0)
        .disabled(isnextButtonDisabled)
        .offset(y: animate ? 0.0 : UIScreen.main.bounds.height)
        .animation(.easeInOut(duration: 0.55), value: animate)
    }
    
    var backButton: some View {
        Button {
            currentStep = .verification
        } label: {
            OnboardingBackButtonLabel()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
        .offset(x: animate ? 0.0 : -UIScreen.main.bounds.width)
        .animation(.easeInOut(duration: 0.55), value: animate)
    }
    
    var textFields: some View {
        VStack(spacing: 20.0) {
            ZStack {
                GradientOverlay(cornerRadius: 12.0, color: .white)
                TextField("", text: $firstName, prompt: Text("Given Name").foregroundStyle(.black.opacity(0.65)))
                    .font(.Body)
                    .foregroundStyle(.black)
                    .padding()
            }
            ZStack {
                GradientOverlay(cornerRadius: 12.0, color: .white)
                TextField("", text: $lastName, prompt: Text("Last Name").foregroundStyle(.black.opacity(0.65)))
                    .font(.Body)
                    .foregroundStyle(.black)
                    .padding()
            }
        }
        .offset(x: animate ? 0.0 : -UIScreen.main.bounds.width)
        .animation(.easeInOut(duration: 0.55), value: animate)
    }
    
    var photoSection: some View {
        HStack(spacing: 20.0) {
            OnboardingImage(image: Image(.profile), color: .cyan)
                .frame(width: 200.0, height: 200.0)
                .offset(x: animate ? 0.0 : -UIScreen.main.bounds.width)
                .animation(.easeInOut(duration: 0.55), value: animate)
            Button {
                isSourceMenuShowing = true
            } label: {
                photoLabel
            }
            .offset(x: animate ? 0.0 : UIScreen.main.bounds.width)
            .animation(.easeInOut(duration: 0.85), value: animate)
        }
        .sheet(isPresented: $isPhotoPickerShowing) {
            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPhotoPickerShowing, source: source)
                .ignoresSafeArea(edges: .bottom)
        }
    }
    
    var header: some View {
        OnboardingHeader(title: "Setup your profile", caption: "Just a few more details to get started.")
            .offset(y: animate ? 0.0 : -UIScreen.main.bounds.height)
            .animation(.easeInOut(duration: 0.55), value: animate)
    }
    
    // This function already exist in GradientOverlay file, but here for circle photo we needed to add this and the @State gradient up in the start
    func startAnimation() {
        let timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            withAnimation {
                // Rotate the array of colors to create the animation effect
                gradientColors.rotate()
            }
        }
        timer.fire()
    }
}



