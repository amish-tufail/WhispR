//
//  ChatListView.swift
//  WhispR
//
//  Created by Amish on 22/07/2023.
//

import SwiftUI

struct ChatListView: View {
    @Environment(ChatViewModel.self) var chats
    @Environment(ContactsViewModel.self) var contacts
    @State var contentOffset = CGFloat(0)
    @State var hasScrolled: Bool = false
    @State private var offset = CGSize.zero
    @Binding var isChatting: Bool
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()
                .overlay {
                    if chats.chats.count > 0 {
                        Blob3Graphic(hasScrolled: $hasScrolled)
                    }
                }
            ScrollView {
                ScrollDetection(hasScrolled: $hasScrolled)
                content
                    .padding(.top, 60)
            }
        }
        .overlay({
            NavigationBar(title: "Chats", hasScrolled: $hasScrolled)
        })
        .onAppear {
            chats.getChats()
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ChatListView(isChatting: .constant(false))
            .environment(ChatViewModel())
            .environment(ContactsViewModel())
    }
}

extension ChatListView {
    var content: some View {
        ZStack {
            VStack {
                if chats.chats.count > 0 {
                    ForEach(chats.chats.sorted { $0.updated ?? Date() > $1.updated ?? Date()}) { chat in
                        Button {
                            chats.selectedChat = chat
                            isChatting = true
                        } label: {
                            ChatListRow(chat: chat, otherParticipants: contacts.getParticipants(ids: chat.participants))
                                .padding(.bottom, 10.0)
                        }
                    }
                    HStack(spacing: 0.0) {
                        Text("Your personal messages are ")
                            .foregroundStyle(.white)
                        Text("end-to-end-encrypted.")
                            .foregroundStyle(
                                LinearGradient(colors: [Color.yellow, Color.orange], startPoint: .leading, endPoint: .trailing)
                            )
                    }
                    .padding(.top, 20.0)
                    .font(.Caption)
                    .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    Spacer()
                    Image(.noChatsYet)
                    Text("Hmm... no chats here yet?")
                        .foregroundStyle(.white)
                        .font(Font.Title)
                        .padding(.top, 32.0)
                    Text("Chat a friend to get started!")
                        .foregroundStyle(.white)
                        .font(Font.TabBar)
                        .padding(.top, 8.0)
                    Spacer()
                }
            }
            .padding(.horizontal, 20.0)
            .padding(.top, 20)
        }
        
    }
    var divider: some View {
        Divider().background(Color.white.blendMode(.overlay))
    }
}


//struct ChatListView: View {
//    @Environment(ChatViewModel.self) var chats
//    @Environment(ContactsViewModel.self) var contacts
//    @Binding var isChatting: Bool
//
//    var body: some View {
//        VStack {
//            HStack {
//                Text("Chats")
//                    .foregroundStyle(.white)
//                    .font(Font.PageTitle)
//                Spacer()
////                Button {
////
////                } label: {
////                    Image(systemName: "gearshape.fill")
////                        .resizable()
////                        .frame(width: 20.0, height: 20.0)
////                        .foregroundStyle(.white)
////                }
//            }
//            .padding(.top, 20.0)
//            .padding(.horizontal)
//
//            if chats.chats.count > 0 {
//                List {
//                    ForEach(chats.chats) { chat in
//                        Button {
//                            chats.selectedChat = chat
//                            isChatting = true
//                        } label: {
//                            ChatListRow(chat: chat, otherParticipants: contacts.getParticipants(ids: chat.participants))
//                        }
//                    }
//                    HStack(spacing: 0.0) {
//                        Text("Your personal messages are ")
//                            .foregroundStyle(.white)
//                        Text("end-to-end-encrypted.")
//                            .foregroundStyle(
//                                LinearGradient(colors: [Color.yellow, Color.orange], startPoint: .leading, endPoint: .trailing)
//                            )
//                    }
//                    .font(.Caption)
//                    .listRowBackground(Color.clear)
//                    .frame(maxWidth: .infinity, alignment: .center)
//                    .listRowBackground(Color.clear)
//                }
//                .listStyle(.plain)
//            } else {
//                Spacer()
//                Image(.noChatsYet)
//                Text("Hmm... no chats here yet?")
//                    .foregroundStyle(.white)
//                    .font(Font.Title)
//                    .padding(.top, 32.0)
//                Text("Chat a friend to get started!")
//                    .foregroundStyle(.white)
//                    .font(Font.TabBar)
//                    .padding(.top, 8.0)
//                Spacer()
//            }
//        }
//        .onAppear {
//            chats.getChats()
//        }
//    }
//}
//
//#Preview {
//    ZStack {
//        Color.black.ignoresSafeArea()
//        ChatListView(isChatting: .constant(false))
//            .environment(ChatViewModel())
//            .environment(ContactsViewModel())
//    }
//}
