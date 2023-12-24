//
//  FAQView.swift
//  WhispR
//
//  Created by Amish on 11/08/2023.
//

import SwiftUI

struct FAQView: View {
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
            NavigationBar(title: "FAQ's", hasScrolled: $hasScrolled)
                .padding(.bottom, 20.0)
        }
        .navigationBarHidden(true)
        .padding(.bottom, 75.0)
    }
}

#Preview {
    FAQView()
}

extension FAQView {
    var content: some View {
        ZStack {
            VStack(spacing: 16.0) {
                VStack(alignment: .leading) {
                    faqRow(title: "• What is WhispR?", text: "WhispR is an iOS chat application that allows you to communicate with friends, family, and colleagues in a secure and convenient way.")
                    divider
                        .padding(.vertical, 10.0)
                    faqRow(title: "How do you protect my privacy?", text: "At WhispR, we are committed to safeguarding your personal information. We collect only non-personal usage data to improve the app's functionality and enhance your experience. We do not collect any personally identifiable information, and we take industry-standard security measures to protect your data.")
                    divider
                        .padding(.vertical, 10.0)
                    faqRow(title: "What information do you collect?", text: "We collect certain non-personal usage data, such as app usage patterns, interactions, and technical information. This data is collected in an anonymized and aggregated form and does not personally identify you.")
                    divider
                        .padding(.vertical, 10.0)
                    faqRow(title: " How do you use my data?", text: "We use the non-personal usage data to analyze app usage patterns, identify areas for improvement, and enhance the app's features and performance.")
                    divider
                        .padding(.vertical, 10.0)
                    faqRow(title: "Do you share my information with third parties?", text: "No, we do not share your information with third parties for marketing or advertising purposes.")
                    divider
                        .padding(.vertical, 10.0)
                    faqRow(title: "Can I access or delete my data?", text: "Yes, you have the right to access and request deletion of the non-personal usage data we collect. To do so, please contact us at WhispR@gmail.com.")
                    divider
                        .padding(.vertical, 10.0)
                    faqRow(title: "Is my data secure?", text: "While we take industry-standard security measures to protect your data, please note that no method of data transmission or storage is 100% secure.")
                    divider
                        .padding(.vertical, 10.0)
                    faqRow(title: "How can I contact you?", text: "If you have any questions, concerns, or requests regarding your data or our Privacy Policy, please reach out to us at WhisPR@gmail.com.")
                    divider
                        .padding(.vertical, 10.0)
                    faqRow(title: "Can the Privacy Policy change?", text: "Yes, we may update the Privacy Policy from time to time. We will notify you of any changes by posting the updated Privacy Policy on our website.")
                    divider
                        .padding(.vertical, 10.0)
                    faqRow(title: "How do I agree to the Privacy Policy?", text: "By using WhispR, you agree to the terms outlined in our Privacy Policy.")
                }
                .padding(.bottom, 16)
                Text("Have any question?")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.subheadline)
                    .opacity(0.7)
                
                Link(destination: URL(string: "WhisPR@gmail.com")!, label: {
                    SecondaryButton()
                        .padding(.top, 16)
                })
            }
            .padding(.bottom, 20.0)
            .padding(.trailing)
        }
    }
    @ViewBuilder
    func faqRow(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 16.0) {
            Text(title)
                .font(Font.custom("LexendDeca-Bold", size: 14))
            
            Text(text)
                .font(Font.custom("LexendDeca-Regular", size: 14))
                .opacity(0.7)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var divider: some View {
        Divider().background(Color.white.opacity(0.65))
    }
}
