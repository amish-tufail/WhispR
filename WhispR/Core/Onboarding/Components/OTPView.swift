//
//  OTPView.swift
//  WhispR
//
//  Created by Amish on 17/07/2023.
//

import SwiftUI

struct OPTView: View {
    @Binding var otpText: String
    @FocusState private var isKeyboardShowing: Bool
    var body: some View {
        VStack {
            HStack {
                ForEach(0 ..< 6, id: \.self) { index in
                    OTPTextBox(index)
                }
            }
            .background(
                TextField("", text: $otpText.limit(6))
                // For Hiding the TextField
                    .frame(width: 1.0, height: 1.0)
                    .opacity(0.0001)
                    .blendMode(.screen)
                    .keyboardType(.phonePad)
                    .focused($isKeyboardShowing)
                    .textContentType(.oneTimeCode) // This is the one that will allow to show the code on our numpad
            )
            .contentShape(Rectangle()) // making whole HStack tapable
            .onTapGesture {
                isKeyboardShowing.toggle() // activating the Text Field
            }
        }
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button {
                    isKeyboardShowing = false
                } label: {
                    Text("Done")
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        OPTView(otpText: .constant(""))
    }
}

// This gives us the text boxe
extension OPTView {
    @ViewBuilder
    func OTPTextBox(_ index: Int) -> some View {
        let status = (isKeyboardShowing && otpText.count == index) // For highlighting
        ZStack {
            if otpText.count > index {
                // For putting the enterd no in text field in to the boxes
                let startIndex = otpText.startIndex
                let charIndex = otpText.index(startIndex, offsetBy: index)
                let charToString = String(otpText[charIndex])
                Text(charToString)
                    .foregroundStyle(.black) // Changes the color of input text
            } else {
                Text(" ")
            }
        }
        .frame(width: 45.0, height: 45.0)
        .background(
            RoundedRectangle(cornerRadius: 6.0, style: .continuous)
                .fill(.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 6.0, style: .continuous)
                        .stroke(
                            LinearGradient(colors: status ? [.black] : [ Color.pink, Color.cyan], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3.0
                        )
                        .animation(.easeIn(duration: 0.2), value: status)
                }
        )
        .frame(maxWidth: .infinity)
    }
}
//

// This is restrict the TextField to only 6 digits
extension Binding where Value == String {
    // We call this function in the TextField
    func limit(_ length: Int) -> Self {
        if self.wrappedValue.count > length {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(length))
            }
        }
        return self
    }
}

