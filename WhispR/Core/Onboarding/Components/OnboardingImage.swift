//
//  OnboardingImage.swift
//  WhispR
//
//  Created by Amish on 17/07/2023.
//

import SwiftUI

struct OnboardingImage: View {
    
    var image: Image
    var color: Color
    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .shadow(color: color.opacity(0.5), radius: 50, x: 10.0, y: 10.0)
    }
}

#Preview {
    OnboardingImage(image: Image(.welcome), color: .orange)
}
