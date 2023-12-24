//
//  RootView.swift
//  WhispR
//
//  Created by Amish on 15/07/2023.
//

import SwiftUI

struct RootView: View {
    @Environment(AuthenticationViewModel.self) var authentication
    @Environment(ContactsViewModel.self) var contacts
    @Environment(ChatViewModel.self) var chats
    @Environment(\.scenePhase) var scenePhase // For detecting app state
    @State var selectedTab: Tab = .chats
    @State var isOnboarding: Bool = false
    @State var isChatting: Bool = false
    @State var newChat: Bool = false
    @State private var participants: [UserModel] = []
    @State var profilePhotoView: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            switch selectedTab {
            case .chats:
                ChatListView(isChatting: $isChatting)
            case .contacts:
                ProfileView(isOnboarding: $isOnboarding, profilePhotoView: $profilePhotoView)
            }
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab, newChat: $newChat)
                    .offset(y: isChatting ? 300.0 : 0.0)
                    .opacity(isChatting ? 0.0 : 1.0)
                    .offset(y: profilePhotoView ? 300.0 : 0.0)
                    .opacity(profilePhotoView ? 0.0 : 1.0)
            }
            if isOnboarding {
                OnboardingContainerView(isOnboarding: $isOnboarding)
                    .transition(.move(edge: .bottom))
            }
        }
        .onAppear {
            Task {
                isOnboarding = !authentication.isUserLoggedIn()
            }
            if !isOnboarding {
                do {
                    try contacts.getLocalContacts()
                } catch {
                    print(error)
                }
            }
            
        }
        .fullScreenCover(isPresented: $newChat) {
            // Here we get the participant and then call for its chat
//            if let participant = participants.first {
//                chats.getChatFor(contact: participant)
//            }
            chats.getChatFor(contact: participants)
        } content: {
            ContactsView(isChatting: $isChatting, newChat: $newChat, participants: $participants)
        }
//        .fullScreenCover(isPresented: $isOnboarding) {
//
//        }
        .fullScreenCover(isPresented: $isChatting) {
            ConversationView(isChatting: $isChatting, participants: $participants)
        }
        .onChange(of: scenePhase) { oldValue, newPhase in // To stop real time listener
            if newPhase == .active {
                
            } else if newPhase == .inactive {
                
            } else if newPhase == .background  {
                chats.closeChatListViewListener()
            }
        }
    }
}

//#Preview {
//    RootView()
//        .environment(AuthenticationViewModel())
//}

