//
//  GradientOverlay.swift
//  WhispR
//
//  Created by Amish on 17/07/2023.
//

import SwiftUI

struct GradientOverlay: View {
    @State private var gradientColors: [Color] = [Color.pink, Color.orange, Color.cyan, Color.yellow]
    var cornerRadius: CGFloat
    var height: CGFloat? = 56.0
    var color: Color? = .black
    var lineWidth: CGFloat = 3.0
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(color!)
            .frame(height: height)
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        LinearGradient(colors: gradientColors, startPoint: .leading, endPoint: .trailing)
                        ,
                        lineWidth: lineWidth
                    )
                    .foregroundStyle(.buttonPrimary)
                    .frame(height: height)
                    .animation(.linear(duration: 3).repeatForever(), value: gradientColors)
                    .onAppear {
                        startAnimation()
                    }
            }
    }
}

#Preview {
    GradientOverlay(cornerRadius: 12.0)
}

extension GradientOverlay {
    func startAnimation() {
        let timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            withAnimation {
                // Rotate the array of colors to create the animation effect
                gradientColors.rotate()
            }
        }
        timer.fire()
    }
}

// Extension to rotate an array in place
extension Array {
    mutating func rotate() {
        guard count > 1 else { return }
        append(removeFirst())
    }
}
