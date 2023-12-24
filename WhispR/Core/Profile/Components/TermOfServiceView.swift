//
//  TermOfServiceView.swift
//  WhispR
//
//  Created by Amish on 12/08/2023.
//

import SwiftUI

struct TermOfServiceView: View {
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
            NavigationBar(title: "Terms of Service", hasScrolled: $hasScrolled)
                .padding(.bottom, 20.0)
        }
        .navigationBarHidden(true)
        .padding(.bottom, 75.0)
    }
}

#Preview {
    TermOfServiceView()
}

extension TermOfServiceView {
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
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("Acceptance of Terms")
                        .font(Font.custom("LexendDeca-Bold", size: 18))
                    termServiceyRow(secondarText: "By accessing or using WhispR, you acknowledge that you have read, understood, and agree to be bound by these Terms of Service. If you do not agree with these terms, please do not use the app.")
                }
                .padding(.top, 20.0)
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("User Conduct")
                        .font(Font.custom("LexendDeca-Bold", size: 18))
                    termServiceyRow(mainText: "• Appropriate Use: ", secondarText: "You agree to use WhispR solely for lawful and appropriate purposes. You will not engage in any activities that violate any applicable laws or regulations.")
                    termServiceyRow(mainText: "• Respectful Communication:", secondarText: "You will use WhispR to communicate with others in a respectful and considerate manner. Any form of abusive, offensive, or inappropriate language or behavior is strictly prohibited.")
                    termServiceyRow(mainText: "• No Spam or Unauthorized Content:", secondarText: "You will not send unsolicited messages, spam, or any unauthorized content through WhispR.")
                    termServiceyRow(mainText: "• No Impersonation:", secondarText: "You will not impersonate another person, entity, or organization when using WhispR.")
                }
                .padding(.top, 20.0)
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("Intellectual Property")
                        .font(Font.custom("LexendDeca-Bold", size: 18))
                    termServiceyRow(mainText: "• Ownership:", secondarText: "WhispR and its content, including but not limited to text, images, graphics, logos, and software, are protected by intellectual property laws and are owned or licensed by us.")
                    termServiceyRow(mainText: "• Limited License:", secondarText: "We grant you a limited, non-exclusive, and non-transferable license to use WhispR for personal, non-commercial purposes.")
                }
                .padding(.top, 20.0)
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("Data Privacy")
                        .font(Font.custom("LexendDeca-Bold", size: 18))
                    termServiceyRow(mainText: "• Data Collection:", secondarText: "We collect non-personal usage data as outlined in our Privacy Policy. By using WhispR, you consent to the collection and use of this data as described.")
                    termServiceyRow(mainText: "• Third Parties:", secondarText: "We do not share your data with third parties for marketing or advertising purposes. Please review our Privacy Policy for more information.")
                }
                .padding(.top, 20.0)
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("Termination")
                        .font(Font.custom("LexendDeca-Bold", size: 18))
                    termServiceyRow(secondarText: "We reserve the right to terminate or suspend your access to WhispR at our discretion, without notice, if you violate these Terms of Service.")
                }
                .padding(.top, 20.0)
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("Changes to Terms")
                        .font(Font.custom("LexendDeca-Bold", size: 18))
                    termServiceyRow(secondarText: "We may update these Terms of Service from time to time. We will notify you of any changes by posting the updated Terms of Service on this page.")
                }
                .padding(.top, 20.0)
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("Contact Us")
                        .font(Font.custom("LexendDeca-Bold", size: 18))
                    termServiceyRow(secondarText: "If you have any questions, concerns, or inquiries about these Terms of Service, please contact us at WhispR@gmail.com.")
                }
                .padding(.top, 20.0)
                Text("By using WhispR, you agree to comply with and be bound by these Terms of Service.")
                    .font(Font.custom("LexendDeca-SemiBold", size: 15))
            }
            .padding(.trailing)
            .foregroundColor(.white)
        }
    }
    
    @ViewBuilder
    func termServiceyRow(mainText: String = "", secondarText: String) -> some View {
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
    
    var divider: some View {
        Divider().background(Color.white.opacity(0.65))
    }
}
