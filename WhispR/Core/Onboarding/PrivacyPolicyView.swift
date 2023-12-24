//
//  PrivacyPolicyView.swift
//  WhispR
//
//  Created by Amish on 17/07/2023.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Binding var policyAppear: Bool
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 25.0) {
                header
                image
                policy
            }
            .foregroundStyle(.white)
            .padding(.horizontal)
            backButton
        }
    }
}

#Preview {
    PrivacyPolicyView(policyAppear: .constant(true))
}

extension PrivacyPolicyView {
    var policy: some View {
        ScrollView(showsIndicators: false) {
            Text("At WhispR, we value your privacy and are committed to protecting your personal information. When you use our iOS chat application, we may collect certain non-personal usage data to improve the app's functionality and enhance your experience. Rest assured, we do not collect any personally identifiable information. We do not share your information with third parties. Your data is treated with utmost care and security, although no method of transmission or storage is 100% secure. If you have any questions or concerns, please reach out to us at whispR@mail.com. By using WhispR, you agree to the terms outlined in this Privacy Policy.")
                .multilineTextAlignment(.leading)
                .font(.Settings)
                .lineSpacing(3.0)
        }
    }
    
    var image: some View {
        Image(.privacy)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, alignment: .center)
            .shadow(color: .orange.opacity(0.5), radius: 50, x: 10.0, y: 10.0)
    }
    
    var header: some View {
        HStack(alignment: .center, spacing: 0.0) {
            Text("Privacy Policy for ")
            Text("WhispR:")
                .tracking(5.0)
                .foregroundStyle(
                    LinearGradient(colors: [Color.yellow, Color.orange, Color.pink, Color.cyan], startPoint: .leading, endPoint: .trailing)
                )
        }
        .font(Font.custom("LexendDeca-SemiBold", size: 17.0))
        .padding(.top, 20.0)
    }
    
    var backButton: some View {
        Button {
            policyAppear = false
        } label: {
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.white )
                .font(.system(size: 25.0))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding()
    }
}
