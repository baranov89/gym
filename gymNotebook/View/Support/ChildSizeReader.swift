//
//  ChildSizeReader.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 11.10.2023.
//

import SwiftUI

struct ChildSizeReader<Content: View>: View {
    @Binding var height: CGFloat
    let content: () -> Content
    var body: some View {
        ZStack {
            content()
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .preference(key: HeightPreferenceKey.self, value: proxy.size.height)
                    }
                )
        }
        .onPreferenceChange(HeightPreferenceKey.self) { preferences in
            self.height = preferences
        }
    }
}

private struct HeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct  ChildSizeReader_Previews: PreviewProvider {
    static var previews: some View {
        ChildSizeReader(height: .constant(10)) {
            Text("qweqw")
        }
    }
}
