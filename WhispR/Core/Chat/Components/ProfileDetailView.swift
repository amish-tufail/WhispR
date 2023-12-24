//
//  ProfileDetailView.swift
//  WhispR
//
//  Created by Amish on 06/08/2023.
//

import SwiftUI
import SwiftUIX

struct ProfileDetailView: View {
    @State private var gradientColors: [Color] = [Color.pink, Color.orange, Color.cyan, Color.yellow]
    var givenName: String
    var lastName: String
    var url: String
    var phoneNumber: String
    @State private var imageTapped = false
    @State private var tappedImage: Image?
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            .padding(.top, 12.0)
            VStack(spacing: 20.0) {
                RoundedRectangle(cornerRadius: 22.0, style: .continuous)
                    .frame(width: 25.0, height: 3.0)
                    .foregroundStyle(.white.opacity(0.65))
                    .padding(.top, 12.0)
                    .padding(.bottom, 40.0)
                ZStack {
                    if let cacheImage = CacheService.shared.getImage(forKey: url) {
                        cacheImage
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .onTapGesture {
                        withAnimation(.easeIn) {
                            imageTapped = true
                            tappedImage = cacheImage
                        }
                    }
                } else {
                    AsyncImage(url: URL(string: url)) { phase in
                        switch phase {
                        case AsyncImagePhase.empty:
                            ProgressView()
                        case AsyncImagePhase.success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                            
                        case AsyncImagePhase.failure:
                            ZStack {
                                Circle()
                                    .foregroundStyle(.white)
                                Text(givenName.prefix(1))
                                    .foregroundStyle(.black)
                                    .bold()
                            }
                        @unknown default:
                            ZStack {
                                Circle()
                                    .foregroundStyle(.white)
                                Text(givenName.prefix(1))
                                    .foregroundStyle(.black)
                                    .bold()
                            }
                        }
                    }
                }
                    Circle()
                        .stroke(
                            LinearGradient(colors: gradientColors, startPoint: .top, endPoint: .bottom),
                            lineWidth: 1.0
                        )
                        .animation(.linear(duration: 3).repeatForever(), value: gradientColors)
                        .onAppear {
                            startAnimation()
                        }
                }
                .frame(width: 104.0, height: 104.0)
                VStack(spacing: 5.0) {
                    Text("\(givenName) \(lastName)")
                        .font(Font.ChatHeading)
                    .foregroundStyle(.white)
                    Text("+\(phoneNumber)")
                        .font(.Body)
                        .foregroundStyle(.white.opacity(0.65))
                }
                Spacer()
            }
            
            if imageTapped == true {
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
                                .frame(width: UIScreen.main.bounds.width - 20.0 , height: UIScreen.main.bounds.height / 3)
                                .padding(100.0)
                        )
                }
                .zIndex(2.0)
                .onTapGesture {
                    withAnimation(.easeIn) {
                        tappedImage = nil
                        imageTapped = false
                    }
                }
            }
            
        }
    }
}

//#Preview {
//    ProfileDetailView(givenName: "Amish", lastName: "Tufail", url: "", phoneNumber: "+92 123 1234567")
//}

extension ProfileDetailView {
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
