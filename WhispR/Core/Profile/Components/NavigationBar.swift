//
//  NavigationBar.swift
//  WhispR
//
//  Created by Amish on 10/08/2023.
//

import SwiftUI

struct NavigationBar: View {
    var title = ""
    @Binding var hasScrolled: Bool
    var body: some View {
        ZStack {
            Color.clear
                .background(.ultraThinMaterial)
                .blur(radius: 10)
                .opacity(hasScrolled ? 1 : 0)
            Text(title)
//                .font(.largeTitle.weight(.bold))
                .modifier(AnimatableFontModifier(size: hasScrolled ? 22 : 34, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .padding(.top, 20)
                .offset(y: hasScrolled ? -4 : 0) // To move the title a little bit up when scrolled
        }
        .frame(height: hasScrolled ? 44 : 70) // height of background
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

//#Preview {
//    NavigationBar()
//}
