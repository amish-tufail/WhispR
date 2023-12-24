//
//  MainPrivacyPolicyView.swift
//  WhispR
//
//  Created by Amish on 10/08/2023.
//

import SwiftUI

struct MainPrivacyPolicyView: View {
    @State var hasScrolled: Bool = false
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                ScrollDetection(hasScrolled: $hasScrolled)
                content
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 100.0)
                    .padding(.leading, 20.0)
            }
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .bold()
                    .imageScale(.large)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(20.0)
            .padding(.top, 15.0)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(
            Color.black
        )
        .overlay {
            NavigationBar(title: "Privacy Policy", hasScrolled: $hasScrolled)
                .padding(.bottom, 20.0)
        }
        .navigationBarHidden(true)
        .padding(.bottom, 75.0)
    }
}

#Preview {
    MainPrivacyPolicyView()
}

extension MainPrivacyPolicyView {
    var content: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16.0) {
                HStack(spacing: 0.0) {
                    Text("• Last Updated: ")
                        .font(Font.custom("LexendDeca-SemiBold", size: 14))
                    Text("August 11, 2023")
                        .multilineTextAlignment(.leading)
                        .font(Font.custom("LexendDeca-Regular", size: 14))
                        .lineSpacing(8.0)
                }
                Text("Welcome to WhispR! We value your privacy and are committed to protecting your personal information. This Privacy Policy explains how we collect, use, and safeguard your data when you use our iOS chat application. By using WhispR, you consent to the practices described in this Privacy Policy.")
                    .font(Font.custom("LexendDeca-Regular", size: 14))
                    .lineSpacing(8.0)
                    .padding(.top, 5.0)
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("Information We Collect")
                        .font(Font.custom("LexendDeca-Bold", size: 18))
                    privacyRow(mainText: "• Non-Personal Usage Data: ", secondarText: "When you use WhispR, we may collect certain non-personal usage data, such as app usage patterns, interactions, and technical information. This data is collected to improve the app's functionality, enhance your experience, and troubleshoot technical issues. This information is collected in an anonymized and aggregated form and does not personally identify you.")
                    
                }
                .padding(.top, 20.0)
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("How We Use Your Data")
                        .font(Font.custom("LexendDeca-Bold", size: 18))
                    privacyRow(mainText: "• App Enhancement: ", secondarText: "We use the non-personal usage data to analyze app usage patterns, identify areas for improvement, and enhance the app's features and performance.")
                }
                .padding(.top, 20.0)
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("Data Security")
                        .font(Font.custom("LexendDeca-Bold", size: 18))
                    privacyRow(mainText: "• Security Measures: ", secondarText: "We take data security seriously. Your data is treated with utmost care and is protected using industry-standard security measures. However, please note that no method of data transmission or storage is 100% secure.")
                    
                }
                .padding(.top, 20.0)
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("Information Sharing")
                        .font(Font.custom("LexendDeca-Bold", size: 18))
                    privacyRow(mainText: "• Third Parties: ", secondarText: "We do not share your information with third parties for marketing or advertising purposes.")
                    
                }
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("Your Choices")
                        .font(Font.custom("LexendDeca-Bold", size: 18))
                    privacyRow(mainText: "• Data Access and Deletion: ", secondarText: "You have the right to access and request deletion of the non-personal usage data we collect. To do so, please contact us at WhispR@gmail.com.")
                    
                }
                .padding(.top, 20.0)
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("Contact Us")
                        .font(Font.custom("LexendDeca-Bold", size: 18))
                    privacyRow(secondarText: "If you have any questions, concerns, or requests regarding your data or this Privacy Policy, please reach out to us at WhispR@gmail.com.")
                    
                }
                .padding(.top, 20.0)
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("Changes to this Privacy Policy")
                        .font(Font.custom("LexendDeca-Bold", size: 18))
                    privacyRow(secondarText: "We may update this Privacy Policy from time to time. We will notify you of any changes by posting the updated Privacy Policy on this page.")
                    
                }
                .padding(.top, 20.0)
                .padding(.bottom, 20.0)
                Text("By using WhispR, you agree to the terms outlined in this Privacy Policy.")
                    .font(Font.custom("LexendDeca-SemiBold", size: 15))
            }
            .padding(.trailing)
            .foregroundColor(.white)
        }
    }
    
    @ViewBuilder
    func privacyRow(mainText: String = "", secondarText: String) -> some View {
        VStack(alignment: .leading, spacing: 10.0) {
            if mainText != "" {
                Text("\(mainText)")
                    .font(Font.custom("LexendDeca-SemiBold", size: 14))
            }
            Text(secondarText)
                .multilineTextAlignment(.leading)
                .font(Font.custom("LexendDeca-Regular", size: 14))
                .lineSpacing(8.0)
        }
        .padding(.top, 5.0)
    }
}
