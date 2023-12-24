//
//  ContactRow.swift
//  WhispR
//
//  Created by Amish on 22/07/2023.
//

import SwiftUI

struct ContactRow: View {
    @State private var gradientColors: [Color] = [Color.pink, Color.orange, Color.cyan, Color.yellow]
    var user: UserModel
    
    var body: some View {
        let photoURL = URL(string: user.photo ?? "")
        HStack(spacing: 24.0) {
            ZStack {
                if let cacheImage = CacheService.shared.getImage(forKey: user.photo ?? "") {
                    cacheImage
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                } else {
                    AsyncImage(url: photoURL) { phase in
                        switch phase {
                        case AsyncImagePhase.empty:
                            ProgressView()
                        case AsyncImagePhase.success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .onAppear {
                                    CacheService.shared.setImage(image: image, forKey: user.photo ?? "")
                                }
                        case AsyncImagePhase.failure:
                            ZStack {
                                Circle()
                                    .foregroundStyle(.white)
                                Text(user.givenName?.prefix(1) ?? "")
                                    .foregroundStyle(.black)
                                    .bold()
                            }
                        @unknown default:
                            ZStack {
                                Circle()
                                    .foregroundStyle(.white)
                                Text(user.givenName?.prefix(1) ?? "")
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
            .frame(width: 54.0, height: 54.0)
            VStack(alignment: .leading, spacing: 4.0) {
                Text("\(user.givenName ?? "") \(user.lastName ?? "")")
                    .font(Font.Button)
                    .foregroundStyle(.white)
                Text("+\(user.phoneNumber ?? "")")
                    .font(Font.Body)
                    .foregroundStyle(.secondary)
                    .foregroundStyle(.white.opacity(0.75))
            }
            Spacer()
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ContactRow(user: UserModel(givenName: "Amish", lastName: "Tufail", phoneNumber: "+1231231234", photo: ""))
    }
}

extension ContactRow {
    
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
