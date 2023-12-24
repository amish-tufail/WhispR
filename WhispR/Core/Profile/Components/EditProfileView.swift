//
//  EditProfileView.swift
//  WhispR
//
//  Created by Amish on 11/08/2023.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    let generator = UISelectionFeedbackGenerator()
    @State var editingNameTextField = false
    @State var editingLastTextField = false
    @State var nameIconBounce = false
    @State var lastIconBounce = false
    @State var name = ""
    @State var last = ""
    @State var showImagePicker = false
    @State var inputImage: UIImage?
    var body: some View {
        ZStack(alignment: .top) {
            content
            Button {
                dismiss()
                generator.selectionChanged()
            } label: {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .font(.body.weight(.bold))
                    .foregroundColor(.white)
                    .padding(8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(20.0)
            .padding(.top, 15.0)
            .onAppear {
                let user = DatabaseServices.shared.mainUser
                name = user.givenName ?? ""
                last = user.lastName ?? ""
            }
        }
    }
}

#Preview {
    EditProfileView()
}

extension EditProfileView {
    var content: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Settings")
                        .foregroundColor(.white)
                        .font(Font.custom("LexendDeca-SemiBold", size: 34.0))
                        .padding(.top, 90)
                        .offset(y: -10.0)
                    Text("Manage your WhispR profile and account")
                        .foregroundColor(.white.opacity(0.7))
                        .font(Font.custom("LexendDeca-Regular", size: 14.0))
                        .offset(y: -10.0)
                    Button {
                        self.showImagePicker = true
                    } label: {
                        HStack(spacing: 12) {
                            TextfieldIcon(iconName: "person.crop.circle", passedImage: $inputImage, currentlyEditing: .constant(false))
                            Text("Choose Photo")
                                .font(Font.custom("LexendDeca-Regular", size: 16.0))
                                .gradientForeground(colors: [Color(#colorLiteral(red: 0.6196078431, green: 0.6784313725, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.5607843137, blue: 0.9803921569, alpha: 1))])
                            Spacer()
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                        .background(
                            Color.init(red: 26/255, green: 20/255, blue: 51/255)
                                .cornerRadius(16)
                        )
                    }
                    GradientTextfield(editingTextfield: $editingNameTextField, textfieldString: $name, iconBounce: $nameIconBounce, textfieldPlaceholder: "First Name", textfieldIconString: "textformat.alt")
                        .autocapitalization(.words)
                        .textContentType(.name)
                        .disableAutocorrection(true)
                    GradientTextfield(editingTextfield: $editingLastTextField, textfieldString: $last, iconBounce: $lastIconBounce, textfieldPlaceholder: "Last Name", textfieldIconString: "text.justifyleft")
                        .autocapitalization(.sentences)
                        .keyboardType(.default)
                    GradientButton(buttonTitle: "Save Settings") {
                        generator.selectionChanged()
                        DatabaseServices.shared.updateProfile(firstName: name, lastName: last, image: inputImage) { isSucess in
                            if isSucess {
                                dismiss()
                            }
                        }
//                        dismiss()
                    }
                    Spacer()
                }
                .padding()
                Spacer()
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $inputImage, isPickerShowing: $showImagePicker, source: .photoLibrary)
                    .ignoresSafeArea(edges: .bottom)
            }
        }
        .background(Color("settingsBackground"))
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .colorScheme(.dark)
    }
}
