//
//  GroupProfilePicView.swift
//  WhispR
//
//  Created by Amish on 07/08/2023.
//

import SwiftUI

struct GroupProfilePicView: View {
    @State private var gradientColors: [Color] = [Color.pink, Color.orange, Color.cyan, Color.yellow]
    var users: [UserModel]
    
    var body: some View {
        let offset = Int(30 / users.count) * -1
        ZStack {
            ForEach(Array(users.enumerated()), id: \.element) { index, user in
                ZStack {
                    if let cacheImage = CacheService.shared.getImage(forKey: user.photo ?? "") {
                        cacheImage
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .offset(x: CGFloat(offset * index))
                    } else {
                        AsyncImage(url: URL(string: user.photo ?? "")) { phase in
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
                                    .offset(x: CGFloat(offset * index))
                                
                            case AsyncImagePhase.failure:
                                ZStack {
                                    Circle()
                                        .foregroundStyle(.white)
                                    Text(user.givenName?.prefix(1) ?? "")
                                        .foregroundStyle(.black)
                                        .bold()
                                }
                                .offset(x: CGFloat(offset * index))
                            @unknown default:
                                ZStack {
                                    Circle()
                                        .foregroundStyle(.white)
                                    Text(user.givenName?.prefix(1) ?? "")
                                        .foregroundStyle(.black)
                                        .bold()
                                }
                                .offset(x: CGFloat(offset * index))
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
            }
        }
        .offset(x: CGFloat((users.count - 1) * abs(offset)) / 2)
    }
}

#Preview {
    GroupProfilePicView(users: [])
}

extension GroupProfilePicView {
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
