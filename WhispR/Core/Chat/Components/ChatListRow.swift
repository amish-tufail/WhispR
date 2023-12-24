//
//  ChatListRow.swift
//  WhispR
//
//  Created by Amish on 30/07/2023.
//

import SwiftUI

struct ChatListRow: View {
    @Environment(ChatViewModel.self) var chats
    @State private var gradientColors: [Color] = [Color.pink, Color.orange, Color.cyan, Color.yellow]
    var chat: ChatModel
    var otherParticipants: [UserModel]?
    @State private var offset = CGSize.zero
    @State var change: Bool = false
    
    var body: some View {
        HStack(spacing: 20.0) {
            HStack(spacing: 24.0) {
                let participant = otherParticipants?.first
                if otherParticipants != nil && otherParticipants?.count == 1 {
                    if participant != nil {
                        ZStack {
                            let photoURL = URL(string: participant!.photo ?? "")
                            if let cacheImage = CacheService.shared.getImage(forKey: participant!.photo ?? "") {
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
                                                CacheService.shared.setImage(image: image, forKey: participant!.photo ?? "")
                                                print("Downloaded")
                                            }
                                    case AsyncImagePhase.failure:
                                        ZStack {
                                            Circle()
                                                .foregroundStyle(.white)
                                            Text(participant!.givenName?.prefix(1) ?? "")
                                                .foregroundStyle(.black)
                                                .bold()
                                        }
                                    @unknown default:
                                        ZStack {
                                            Circle()
                                                .foregroundStyle(.white)
                                            Text(participant!.givenName?.prefix(1) ?? "")
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
                                    //                            startAnimation()
                                }
                        }
                        .frame(width: 54.0, height: 54.0)
                        //            }
                        VStack(alignment: .leading, spacing: 4.0) {
                            if let otherParticipants = otherParticipants {
                                if otherParticipants.count == 1 {
                                    Text("\(participant!.givenName ?? "") \(participant!.lastName ?? "")")
                                        .font(Font.Button)
                                        .foregroundStyle(.white)
                                } else if otherParticipants.count == 2 {
                                    let participantTwo = otherParticipants[1]
                                    Text("\(participant!.givenName ?? ""), \(participantTwo.givenName ?? "")")
                                        .font(Font.Button)
                                        .foregroundStyle(.white)
                                } else if otherParticipants.count > 2 {
                                    let participantTwo = otherParticipants[1]
                                    Text("\(participant!.givenName ?? ""), \(participantTwo.givenName ?? "") + \(otherParticipants.count - 2) others")
                                        .font(Font.Button)
                                        .foregroundStyle(.white)
                                }
                            }
                            Text("\(chat.lastText ?? "")")
                                .font(Font.Body)
                                .foregroundStyle(.secondary)
                                .foregroundStyle(.white.opacity(0.75))
                                .lineLimit(1)
                        }
                        Spacer()
                        Text(chat.updated == nil ? "" : DateHelper.chatTimestampFrom(date: chat.updated!))
                            .font(Font.TabBar)
                            .foregroundStyle(.secondary)
                            .foregroundStyle(.white.opacity(0.75))
                    }
                } else if otherParticipants != nil && otherParticipants!.count > 1 {
                    HStack(spacing: 24.0) {
                        GroupProfilePicView(users: otherParticipants!)
                            .frame(width: 54.0, height: 54.0)
                        VStack(alignment: .leading, spacing: 4.0) {
                            if otherParticipants!.count == 2 {
                                let participantTwo = otherParticipants![1]
                                Text("\(participant!.givenName ?? ""), \(participantTwo.givenName ?? "")")
                                    .font(Font.Button)
                                    .foregroundStyle(.white)
                            } else if otherParticipants!.count > 2 {
                                let participantTwo = otherParticipants![1]
                                Text("\(participant!.givenName ?? ""), \(participantTwo.givenName ?? "") + \(otherParticipants!.count - 2) others")
                                    .font(Font.Button)
                                    .foregroundStyle(.white)
                            }
                            Text("\(chat.lastText ?? "")")
                                .font(Font.Body)
                                .foregroundStyle(.secondary)
                                .foregroundStyle(.white.opacity(0.75))
                                .lineLimit(1)
                        }
                        Spacer()
                        Text(chat.updated == nil ? "" : DateHelper.chatTimestampFrom(date: chat.updated!))
                            .font(Font.TabBar)
                            .foregroundStyle(.secondary)
                            .foregroundStyle(.white.opacity(0.75))
                    }
                }
            }
            if change {
                Button {
                    chats.deleteChat(chat: chat)
                } label: {
                    Image(systemName: "trash.fill")
                        .resizable()
                        .frame(width: 15.0, height: 15.0)
                        .foregroundStyle(.black)
                        .padding(10.0)
                        .background(
                            RoundedRectangle(cornerRadius: 8.0, style: .continuous)
                                .fill(.cyan)
                        )
                }
            }
        }
        .offset(x: offset.width)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    let translation = gesture.translation.width
                    
                    if translation < 0 {
                        // Dragging to the left
                        offset.width = translation
                        change = true
                    } else if translation > 0 && offset.width < 0 {
                        // Dragging to the right from the left-dragged position
                        let dragWidth = max(translation, -70.0)
                        offset.width = dragWidth
                        change = false
                    }
                }
                .onEnded { gesture in
                    let translation = gesture.translation.width
                    
                    if offset.width < -35.0 {
                        // Snap back to the left-dragged position
                        withAnimation(.spring()) {
                            offset.width = -70.0
                        }
                        change = true
                    } else {
                        // Snap back to the initial position
                        withAnimation(.spring()) {
                            offset = .zero
                        }
                        change = false
                    }
                }
        )

    }
}

//#Preview {
//    ChatListRow(chat: Chatmo)
//}

extension ChatListRow{
    
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
