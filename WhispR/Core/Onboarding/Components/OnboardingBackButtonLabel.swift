//
//  OnboardingBackButtonLabel.swift
//  WhispR
//
//  Created by Amish on 17/07/2023.
//

import SwiftUI

struct OnboardingBackButtonLabel: View {
    var body: some View {
        Image(systemName: "chevron.left")
            .foregroundStyle(
                LinearGradient(colors: [Color.pink, Color.cyan], startPoint: .top, endPoint: .bottom)
            )
            .fontWeight(.semibold)
            .imageScale(.large)
    }
}

#Preview {
    OnboardingBackButtonLabel()
}
