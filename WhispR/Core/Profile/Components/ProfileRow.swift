//
//  ProfileRow.swift
//  WhispR
//
//  Created by Amish on 10/08/2023.
//

import SwiftUI

struct ProfileRow: View {
    @State private var angle: Double = 0
    var givenName: String = ""
    var lastName: String = ""
    var phoneNumber: String = ""
    var photo: String = ""
    @Binding var imageTapped: Bool
    @Binding var tappedImage: Image?
    @Binding var profilePhotoView: Bool
    var body: some View {
        HStack(alignment: .center, spacing: 16.0) {
            profilePicture
            VStack(alignment: .leading, spacing: 2) {
                Text("\(givenName) \(lastName)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .foregroundColor(.white)
                Text("+\(phoneNumber)")
                    .font(.footnote)
                    .foregroundColor(Color.white.opacity(0.7))
            }
            Spacer()
            glowIcon
        }
        .blurBackground()
    }
    
    var profilePicture: some View {
        ZStack {
            Image(systemName: "circle.fill")
                .resizable()
                .font(.system(size: 66))
                .angularGradientGlow(colors: [Color(#colorLiteral(red: 0.2274509804, green: 0.4, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.2156862745, green: 1, blue: 0.6235294118, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.9176470588, blue: 0.1960784314, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.2039215686, blue: 0.2745098039, alpha: 1))])
                .rotationEffect(Angle(degrees: angle))
                .frame(width: 66, height: 66)
                .blur(radius: 10)
                .onAppear {
                withAnimation(.linear(duration: 7)) {
                    self.angle += 350
                }
            }
            VStack {
                Section {
//                    let photoURL = URL(string: photo)
                    if let cacheImage = CacheService.shared.getImage(forKey: photo) {
                        cacheImage
                            .resizable()
                            .transition(.scale(scale: 0.5, anchor: .center)) // For animation
                            .onTapGesture {
                                withAnimation(.easeIn) {
                                    imageTapped = true
                                    tappedImage = cacheImage
                                    profilePhotoView = true
                                }
                            }
                    } else {
                        AsyncImage(url: URL(string: photo), transaction: Transaction(animation: .easeOut)) {
                            phase in // To deal with different cases
                            switch phase {
                            case .success(let image):
                                image.resizable()
                                    .transition(.scale(scale: 0.5, anchor: .center)) // For animation when an image loads
                                    .onAppear {
                                        CacheService.shared.setImage(image: image, forKey: photo)
                                        print("Downloaded")
                                    }
                            case .empty:
                                ProgressView()
                            case .failure(_):
                                ZStack {
                                    Circle()
                                        .foregroundStyle(.white)
                                    Text(givenName.prefix(1))
                                        .foregroundStyle(.black)
                                        .bold()
                                }
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }
                .frame(width: 66, height: 66)
                .cornerRadius(50)
            }
            .overlay(
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 2))
                    .foregroundColor(Color.white.opacity(0.7))
            )
        }
    }
    
    var glowIcon: some View {
        NavigationLink {
            EditProfileView()
        } label: {
            ZStack {
                AngularGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3960784314, green: 0.5254901961, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.2509803922, blue: 0.3137254902, alpha: 1)), Color(#colorLiteral(red: 0.4274509804, green: 1, blue: 0.7254901961, alpha: 1)), Color(#colorLiteral(red: 0.4274509804, green: 1, blue: 0.7254901961, alpha: 1))]), center: .center, startAngle: .init(degrees: -190), endAngle: .degrees(155))
                    .blur(radius: 8)
                    .shadow(radius: 30)
                    .frame(width: 36, height: 36)
                
                Image(systemName: "gear")
                    .linearGradientBackground(colors: [Color(#colorLiteral(red: 0.6196078431, green: 0.6784313725, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.5607843137, blue: 0.9803921569, alpha: 1))])
                    .frame(width: 36.0, height: 36)
                    .background(Color(#colorLiteral(red: 0.1019607843, green: 0.07058823529, blue: 0.2431372549, alpha: 1)).opacity(0.8))
                    .mask(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color.white.opacity(0.7), lineWidth: 1).blendMode(.overlay))
            }
        }
    }
}

//#Preview {
//    ProfileRow()
//}
