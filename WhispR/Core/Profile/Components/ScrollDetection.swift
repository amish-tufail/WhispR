//
//  ScrollDetection.swift
//  WhispR
//
//  Created by Amish on 10/08/2023.
//

import SwiftUI

struct ScrollDetection: View {
    @Binding var hasScrolled: Bool
    var body: some View {
        GeometryReader { proxy in
//                Text("\(proxy.frame(in: .named("scroll")).minY)")
            Color.clear.preference(key: ScrollPreferenceKey.self, value: proxy.frame(in: .named("scroll")).minY)
        }
        .frame(height: 0)
        .onPreferenceChange(ScrollPreferenceKey.self, perform: { value in
            withAnimation(.easeInOut) {
                if value < 50 {
                    hasScrolled = true
                } else {
                    hasScrolled = false
                }
            }
        })
    }
}

//#Preview {
//    ScrollDetection()
//}
