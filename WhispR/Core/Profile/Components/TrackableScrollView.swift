//
//  TrackableScrollView.swift
//  WhispR
//
//  Created by Amish on 10/08/2023.
//

import SwiftUI

struct TrackableScrollView<Content: View > : View {
    let axes: Axis.Set
    let offsetChanged: (CGPoint) -> Void
    let content: Content
    init(axes: Axis.Set = .vertical, offsetChanged: @escaping (CGPoint) -> Void = { _ in }, @ViewBuilder content: () -> Content) {
        self.axes = axes
        self.offsetChanged = offsetChanged
        self.content = content()
    }
    var body: some View {
        SwiftUI.ScrollView(axes) {
            GeometryReader { proxy in
                Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: proxy.frame(in: .named("scrollView")).origin)
            }
            .frame(width: 0, height: 0)
            content
        }
        .coordinateSpace(name: "scrollView")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: offsetChanged)
    }
}

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}