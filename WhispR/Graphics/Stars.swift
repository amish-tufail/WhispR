//
//  Stars.swift
//  Background1
//
//  Created by Aksonvady Phomhome on 2021-04-01.
//

import SwiftUI

struct Stars: View {
    @State private var animate: Bool = false
    @Binding var hasScrolled: Bool
    
    var body: some View {
        ZStack {
            ZStack {
                Star(hasScrolled: $hasScrolled)
                Star(hasScrolled: $hasScrolled).offset(x: animate ? -70 : -90, y: animate ? -100 : -80)
                Star(hasScrolled: $hasScrolled).offset(x: animate ? -320 : -300, y: animate ? -80 : -20)
                Star(hasScrolled: $hasScrolled).offset(x: animate ? -150 : -200, y: animate ? 75 : 140)
            }
            .animation(.easeIn(duration: 60.0).repeatForever(autoreverses: true), value: animate)
            ZStack {
                Star2(hasScrolled: $hasScrolled)
                Star2(hasScrolled: $hasScrolled).offset(x: animate ? 100 : 50, y: animate ? 140 : 110)
                Star2(hasScrolled: $hasScrolled).offset(x: animate ? 175 : 150, y: animate ? -75 : -110)
                Star2(hasScrolled: $hasScrolled).offset(x: animate ? 240 : 220, y: animate ? -30 : -50)
                Star2(hasScrolled: $hasScrolled).offset(x: animate ? 175 : 200, y: animate ? 100 : 70)
                Star2(hasScrolled: $hasScrolled).offset(x: animate ? 186 : 176, y: animate ? 200 : 100)
                Star2(hasScrolled: $hasScrolled).offset(x: animate ? 76 : 100, y: animate ? 36 : 20)
                Star2(hasScrolled: $hasScrolled).offset(x: animate ? 155 : 140, y: animate ? -76 : -20)
                Star2(hasScrolled: $hasScrolled).offset(x: animate ? 200 : 180, y: animate ? -135 : -70)
            }
            .animation(.easeIn(duration: 60.0).repeatForever(autoreverses: true), value: animate)
            
            ZStack {
                Star2(hasScrolled: $hasScrolled)
                Star2(hasScrolled: $hasScrolled).offset(x: animate ? 100 : 50, y: animate ? 124 : 110)
                Star2(hasScrolled: $hasScrolled).offset(x: animate ? 190 : 150, y: animate ? -55 : -110)
                Star2(hasScrolled: $hasScrolled).offset(x: animate ? 200 : 220, y: animate ? 50 : -50)
                Star2(hasScrolled: $hasScrolled).offset(x: animate ? 176 : 200, y: animate ? 100 : 70)
                Star2(hasScrolled: $hasScrolled).offset(x: animate ? 136 : 176, y: animate ? 55 : 100)
                Star2(hasScrolled: $hasScrolled).offset(x: animate ? 34 : 100, y: animate ? -20 : 20)
                Star2(hasScrolled: $hasScrolled).offset(x: animate ? 100 : 140, y: animate ? 40 : -20)
                Star2(hasScrolled: $hasScrolled).offset(x: animate ? 166 : 180, y: animate ? 10 : -70)
            }
            .offset(x: -200, y:-50)
            .animation(.easeIn(duration: 60.0).repeatForever(autoreverses: true), value: animate)
            
            ZStack {
                Star2(hasScrolled: $hasScrolled)
                Star2(hasScrolled: $hasScrolled).offset(x: animate ? 20 : 50, y: animate ? 10 : 110)
                Star2(hasScrolled: $hasScrolled).offset(x: animate ? 77 : 150, y: animate ? -190 : -110)
                Star2(hasScrolled: $hasScrolled).offset(x: animate ? 144 : 220, y: animate ? -50 : -50)
                Star2(hasScrolled: $hasScrolled).offset(x: animate ? 100 : 200, y: animate ? -70 : 70)
                Star2(hasScrolled: $hasScrolled).offset(x: animate ? 107 : 176, y: animate ? -100 : 100)
                Star2(hasScrolled: $hasScrolled).offset(x: animate ? -100 : 100, y: animate ? -40 : 20)
                Star2(hasScrolled: $hasScrolled).offset(x: animate ? -20 : 140, y: animate ? -90 : -20)
                Star2(hasScrolled: $hasScrolled).offset(x: animate ? -44 : 180, y: animate ? 10 : -70)
            }
            .offset(x: -220, y: 150)
            .animation(.easeIn(duration: 60.0).repeatForever(autoreverses: true), value: animate)
            
            ZStack {
                Star3(hasScrolled: $hasScrolled)
                Star3(hasScrolled: $hasScrolled).offset(x: animate ? 10 : 60, y: animate ? -10 : 10)
                Star3(hasScrolled: $hasScrolled).offset(x: animate ? 22 : 30, y: animate ? 75 : 90)
                Star3(hasScrolled: $hasScrolled).offset(x: animate ? 76 : 90, y: animate ? 100 : 140)
                Star3(hasScrolled: $hasScrolled).offset(x: animate ? 20 : -20, y: animate ? -100 : 100)
                Star3(hasScrolled: $hasScrolled).offset(x: animate ? -77 : -80, y: animate ? 100 : 180)
                Star3(hasScrolled: $hasScrolled).offset(x: animate ? -22 : -40, y: animate ? 100 : 120)
                Star3(hasScrolled: $hasScrolled).offset(x: animate ? 20 : -20, y: animate ? 20 : -20)
                Star3(hasScrolled: $hasScrolled).offset(x: animate ? 76 : 100, y: animate ? 110 : 70)
                Star3(hasScrolled: $hasScrolled).offset(x: animate ? 88 : 130, y: animate ? 11 : 120)
            }
            .animation(.easeIn(duration: 30.0).repeatForever(autoreverses: true), value: animate)
        }
        .onAppear {
           animate = true
        }
    }
}

struct Stars_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Stars(hasScrolled: .constant(false))
        }
    }
}
