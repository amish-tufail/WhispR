//
//  OnboardingButtonLabel.swift
//  WhispR
//
//  Created by Amish on 17/07/2023.
//

import SwiftUI

struct OnboardingButtonLabel: View {
    var text: String
    var image: String?
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: .infinity, style: .continuous)
                .stroke(
                    LinearGradient(colors: [Color.yellow, Color.orange, Color.pink, Color.cyan], startPoint: .leading, endPoint: .trailing),
                    lineWidth: 2.0
                )
                .foregroundStyle(.buttonPrimary)
                .frame(height: 50.0)
            HStack(alignment: .firstTextBaseline) {
                Text(text)
                    .font(.Button)
                    .foregroundStyle(.textButton)
                if let image = image {
                    Image(systemName: image)
                        .foregroundStyle(
                            LinearGradient(colors: [Color.cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                }
            }
        }
    }
}

#Preview {
    OnboardingButtonLabel(text: "Get Started")
}
