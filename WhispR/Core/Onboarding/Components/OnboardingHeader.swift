//
//  OnboardingHeader.swift
//  WhispR
//
//  Created by Amish on 17/07/2023.
//

import SwiftUI

struct OnboardingHeader: View {
    var title: String
    var image: String?
    var caption: String
    var body: some View {
        Group {
            HStack(alignment: .center) {
                Text(title)
                    .font(.Title)
                if let image = image {
                    Image(systemName: image)
                        .imageScale(.large)
                        .foregroundStyle(
                            LinearGradient(colors: [Color.pink, Color.cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                }
            }
            .padding(.top, 52.0)
            Text(caption)
                .font(.Body)
                .padding(.top, 12.0)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    OnboardingHeader(title: "Verification", caption: "Enter you mobile number below. We'll send you a verification code after.")
}
