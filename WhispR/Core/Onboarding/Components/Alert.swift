//
//  Alert.swift
//  WhispR
//
//  Created by Amish on 10/08/2023.
//

import SwiftUI
import AudioToolbox

struct Alert: View {
    let generator = UISelectionFeedbackGenerator()
    let vibration = UINotificationFeedbackGenerator() // For Alert Haptics
    @Environment(\.colorScheme) var colorScheme
    @Binding var didErrorOccured: Bool
    var alertTitle: String = ""
    var alertMessage: String = ""
    @State var appear: Bool = false
    
    var body: some View {
        ZStack {
            Color.clear.background(.ultraThinMaterial).ignoresSafeArea()
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.system(size: 35))
                    .foregroundColor(.systemBlue.opacity(0.7))
                
                Text(alertTitle)
                    .foregroundColor(.primary)
                    .font(.title2, weight: .bold)
                VStack(spacing: 30) {
                    Text("\(alertMessage)")
                        .foregroundColor(.secondary)
                        .font(.footnote)
                    Button {
                        withAnimation {
                            didErrorOccured = false
                        }
                        generator.selectionChanged()
                    } label: {
                        Text("Continue")
                            .frame(maxWidth: .infinity)
                            .gradientForeground(colors: [.pink, .blue, .purple, .pink])
                    }
                    .font(.headline)
                    .buttonStyle(.angular)
                    .tint(.blue)
                    .controlSize(.large)
                    .shadow(color: Color("Shadow").opacity(0.2), radius: 30, x: 0, y: 30)
                }
            }
            .padding()
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
            .strokeStyle(cornerRadius: 30)
            .padding()
            .offset(y: 240)
            .opacity(appear ? 1 : 0)
            .offset(y: appear ? 0 : 560)
            .onAppear {
                withAnimation(.easeOut) {
                    appear = true
                }
                vibration.notificationOccurred(.error)
            }
            .onDisappear {
                withAnimation(.easeOut) {
                    appear = false
                }
            }
        }
    }
}


#Preview {
    Alert(didErrorOccured: .constant(true))
}

extension View {
    public func gradientForeground(colors: [Color]) -> some View {
        self.overlay(
            LinearGradient(
                colors: colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
        )
            .mask(self)
    }
}

struct StrokeModifier: ViewModifier {
    var cornerRadius: CGFloat
    @Environment(\.colorScheme) var colorScheme // For dark mode we are doing this
    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(
                    .linearGradient(
                        colors: [
                            .white.opacity(colorScheme == .dark ? 0.1 : 0.3),
                            .black.opacity(colorScheme == .dark ? 0.3 : 0.1)
                        ], startPoint: .top, endPoint: .bottom
                    )
                )
                .blendMode(.overlay)
        ) // This is for that gradient type effect at the borders
    }
}

extension View {
    func strokeStyle(cornerRadius: CGFloat =  30.0) -> some View {
        modifier(StrokeModifier(cornerRadius: cornerRadius))
    }
}



struct AngularButtonStyle: ButtonStyle {
    @State var angle = 0.0
    @Environment(\.controlSize) var controlSize // ControlSize are pre-set Environment Object which help to style button
    var extraPadding: CGFloat { // To provide padding of the button based on the phone screen size
        switch controlSize {
             
        case .mini:
            return 0;
        case .small:
            return 0
        case .regular:
            return 4
        case .large:
            return 12
        case .extraLarge:
            return 14
        @unknown default:
            return 0
        }
    }
    
    var cornerRadius: CGFloat {
        switch controlSize {
            
        case .mini:
            return 12
        case .small:
            return 12
        case .regular:
            return 16
        case .large:
            return 20
        case .extraLarge:
            return 22
        @unknown default:
            return 12
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 10 + extraPadding)
            .padding(.vertical, 4 + extraPadding)
//            .background(Color(.systemBackground))
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.linearGradient(colors: [Color(.systemBackground), Color(.systemBackground).opacity(0.6)], startPoint: .top, endPoint: .bottom))
                    .blendMode(.softLight)
            )
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.angularGradient(colors: [.pink, .purple, .blue, .pink], center: .center, startAngle: .degrees(-90), endAngle: .degrees(270)))
                    .blur(radius: cornerRadius)
            )
//            .cornerRadius(cornerRadius) // No need as used in background
            .strokeStyle(cornerRadius: cornerRadius)
    }
}

extension ButtonStyle where Self == AngularButtonStyle {
    static var angular: Self {
        return .init()
    }
}
