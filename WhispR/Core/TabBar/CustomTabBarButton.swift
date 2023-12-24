//
//  CustomTabBarButton.swift
//  WhispR
//
//  Created by Amish on 15/07/2023.
//

import SwiftUI

struct CustomTabBarButton: View {
    @State private var buttonPressed: Bool = false
    var buttontext: String
    var image: String
    @Binding var selectedTab: Tab
    var isActive: Bool
    var body: some View {
        Button {
            animateButton()
            if buttontext == "Chats" {
                selectedTab = .chats
            } else {
                selectedTab = .contacts
            }
        } label: {
            buttonLabel
        }
        .tint(Color(.background))
    }
}

#Preview {
    CustomTabBarButton(buttontext: "Chats", image: "chats", selectedTab: .constant(.chats), isActive: true)
}

extension CustomTabBarButton {
    var buttonLabel: some View {
        GeometryReader { proxy in
            let size = proxy.size
            if isActive {
                Rectangle()
                    .clipShape(
                        .rect(
                            topLeadingRadius: 20.0,
                            bottomLeadingRadius: 20.0,
                            bottomTrailingRadius: 20.0,
                            topTrailingRadius: 20.0,
                            style: .continuous
                        )
                    )
                    .foregroundStyle(.cyan)
                    .frame(width: size.width / 3, height: 2.5)
                    .padding(.leading, size.width / 3)
                    .offset(y: 3.5)
            }
            VStack(alignment: .center, spacing: 4.0) {
                Image(image)
                    .resizable()
                    .renderingMode(.template)
                    .opacity(buttonPressed ? 0.5 : 1.0)
                    .scaleEffect(buttonPressed ? 0.85 : 1.0)
                    .frame(width: 20.0, height: 20.0)
                Text(buttontext)
                    .scaleEffect(buttonPressed ? 0.9 : 1.0)
                    .font(.TabBar)
            }
            .frame(width: size.width, height: size.height)
        }
    }
    func animateButton()  {
        return  withAnimation(.easeInOut(duration: 0.35)) {
            buttonPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                withAnimation(.easeInOut(duration: 0.35)) {
                    buttonPressed = false
                }
            }
        }
    }
}
