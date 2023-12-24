//
//  ProfileView.swift
//  WhispR
//
//  Created by Amish on 10/08/2023.
//

import SwiftUI
import SwiftUIX

struct ProfileView: View {
    @Environment(AuthenticationViewModel.self) var authentication
    @State var contentOffset = CGFloat(0)
    @State var hasScrolled: Bool = false
    @State private var imageTapped: Bool = false
    @State private var tappedImage: Image?
    @State var appear: Bool = false
    @Binding var isOnboarding: Bool
    @Binding var profilePhotoView: Bool
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ScrollView(showsIndicators: false) {
                    ScrollDetection(hasScrolled: $hasScrolled)
                    content
                        .padding(.top, 50)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .background(
                Color.black
                    .overlay {
                        Image("Blob 1 Dark")
                            .offset(x: appear ? 200.0 : 1000, y: -100)
                    }
            )
            .onAppear {
                withAnimation(.easeInOut) {
                    appear = true
                }
            }
            .overlay {
                NavigationBar(title: "Profile", hasScrolled: $hasScrolled)
                if imageTapped == true && tappedImage != nil {
                    ZStack {
                        VisualEffectBlurView(blurStyle: .systemMaterialDark)
                            .edgesIgnoringSafeArea(.all)
                            .overlay(
                                tappedImage!
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 12.0, style: .continuous)
                                    )
                                    .frame(width: UIScreen.main.bounds.width - 20.0 , height: UIScreen.main.bounds.height / 1.5)
                                    .padding(.horizontal, 50.0)
                            )
                    }
                    .zIndex(2.0)
                    .onTapGesture {
                        withAnimation(.easeIn) {
                            tappedImage = nil
                            imageTapped = false
                            profilePhotoView = false
                        }
                    }
                    
                }
            }
            .navigationBarBackButtonHidden()
        }
        
    }
}

//#Preview {
//    ProfileView(isOnboarding: .constant(false) )
//}

extension ProfileView {
    var content: some View {
        ZStack {
            let user = DatabaseServices.shared.mainUser
            VStack {
                ProfileRow(givenName: DatabaseServices.shared.getName(), lastName: user.lastName ?? "", phoneNumber: user.phoneNumber ?? "", photo: user.photo ?? "", imageTapped: $imageTapped, tappedImage: $tappedImage, profilePhotoView: $profilePhotoView)
                    .padding(.top, 10)
                VStack {
                    NavigationLink {
                        EditProfileView()
                    } label: {
                        MenuRow(title: "Edit Profile", leftIcon: "gearshape.fill", rightIcon: "chevron.right")
                    }
                    divider
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isOnboarding = true
                            authentication.logOut()
                            
                        }
                    } label: {
                        MenuRow(title:"Sign Out", leftIcon: "pip.exit")
                    }
                }
                .blurBackground()
                .padding(.top, 20)
                VStack {
                    NavigationLink {
                        FAQView()
                    } label: {
                        MenuRow(title: "FAQ / Contact", leftIcon: "questionmark", rightIcon: "chevron.right")
                    }
                    divider
                    
                    NavigationLink {
                        MainPrivacyPolicyView()
                    } label: {
                        MenuRow(title: "Privacy Policy", leftIcon: "doc.fill", rightIcon: "chevron.right")
                    }

                    divider
                    NavigationLink {
                        TermOfServiceView()
                    } label: {
                        MenuRow(title: "Terms of Sevice", leftIcon: "doc.fill", rightIcon: "chevron.right")
                    }
                }
                .blurBackground()
                .padding(.top, 20)
                
                VStack {
                    Button {
//                        DatabaseServices.shared.deactivateAccount {
//                            authentication.logOut()
//                            isOnboarding = true
//                        }
                    } label: {
                        MenuRow(title: "Delete Account", leftIcon: "exclamationmark.triangle.fill", textColor: .red)
                    }
                }
                .blurBackground()
                .padding(.top, 20)
                VStack {
                    Text("WhispR © 2023")
                    Text("Version 1.00")
                }
                .foregroundColor(.white)
                .opacity(0.7)
                .padding(.top, 20)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                .font(.footnote)
            }
            .foregroundColor(.white)
            .padding(.top, 20)
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
    }
    
    var divider: some View {
        Divider().background(Color.white.blendMode(.overlay))
    }
}
