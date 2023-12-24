//
//  MenuRow.swift
//  WhispR
//
//  Created by Amish on 10/08/2023.
//

import SwiftUI

struct MenuRow: View {
    var title: String = ""
    var leftIcon: String = ""
    var rightIcon: String = ""
    var textColor: Color = .white
    var body: some View {
        HStack(spacing: 12.0) {
            GradientIcon(icon: leftIcon)
            Text(title)
                .font(.subheadline, weight: .semibold)
                .foregroundStyle(textColor)
            Spacer()
            Image(systemName: rightIcon)
                .font(.system(size: 15, weight: .semibold))
                .opacity(0.3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    MenuRow()
}
