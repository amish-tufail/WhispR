//
//  CustomTabBar.swift
//  WhispR
//
//  Created by Amish on 15/07/2023.
//

import SwiftUI

enum Tab: Int {
    case chats = 0
    case contacts = 1
}

struct CustomTabBar: View {
    @Environment(ChatViewModel.self) var chats
    @State private var gradientColors: [Color] = [Color.pink, Color.orange, Color.cyan, Color.yellow]
    @State private var newChatPressed: Bool = false
    @Binding var selectedTab: Tab
    @Binding var newChat: Bool
    
    var body: some View {
        HStack(alignment: .center) {
            CustomTabBarButton(buttontext: "Chats", image: "chat", selectedTab: $selectedTab, isActive: selectedTab == .chats)
            newChatButton
            CustomTabBarButton(buttontext: "Profile", image: "person", selectedTab: $selectedTab, isActive: selectedTab == .contacts)
        }
        .frame(height: 52.0)
        .frame(maxWidth: 450.0) // For iPads
        .background(
            RoundedRectangle(cornerRadius: .infinity, style: .continuous)
                .fill(.white)
                .overlay {
                    RoundedRectangle(cornerRadius: .infinity, style: .continuous)
                        .stroke(
                            LinearGradient(colors: gradientColors, startPoint: .leading, endPoint: .trailing)
                            ,
                            lineWidth: 1.5
                        )
                        .animation(.linear(duration: 3).repeatForever(), value: gradientColors)
                        .onAppear {
                            startAnimation()
                        }
                }
        )
        .padding()
        .background {
            Rectangle()
                .fill(.black)
                .ignoresSafeArea()
                .offset(y: 42.0)
        }
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.chats), newChat: .constant(false))
}

extension CustomTabBar {
    var newChatButton: some View {
        Button {
            animateNewChatButton()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
                chats.clearSelectedChat()
                newChat = true
            }
        } label: {
            VStack(alignment: .center, spacing: 4.0) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaleEffect(newChatPressed ? 1.2 : 1.0)
                    .frame(width: 28.0, height: 28.0)
                Text("New Chat")
                    .scaleEffect(newChatPressed ? 0.9 : 1.0)
                    .font(.TabBar)
            }
        }
        .offset(y: newChatPressed ? -10.0 : 0.0)
        .tint(Color(.background))
    }
    
    func animateNewChatButton()  {
        return  withAnimation(.easeInOut(duration: 0.35)) {
            newChatPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                withAnimation(.easeInOut(duration: 0.35)) {
                    newChatPressed = false
                }
            }
        }
    }
    
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

