//  Copyright © 2020 AS "Citadele Banka". All rights reserved.

import SwiftUI

public enum ActivityIndicatorColor {
    case red
    case white
}

private let delay: Double = 0.2
private let duration: Double = 0.5
private let circlesCount = 3

struct LoadingIndicator: View {

    @State var style: ActivityIndicatorColor = .red
    @State private var fades = [Double](repeating: 1, count: circlesCount)

    private var foreverAnimation: Animation {
        .easeInOut(duration: duration / 2)
        .delay(0.2)
        .repeatForever(autoreverses: true)
    }

    var body: some View {
        HStack(spacing: 0.0) {
            ForEach(0..<circlesCount) { i in
                Circle()
                    .fill(style == .red ? .red : .white)
                    .opacity(fades[i])
                    .animation(foreverAnimation, value: fades[i])
                    .onAppear { animate(at: i) }
            }
        }
        .frame(width: 39, height: 13)
    }

    private func animate(at index: Int) {

        if index == 0 {
            self.fades[0] = 0
            return
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + delay * Double(index) + delay
        ) {
            self.fades[index] = 0
        }
    }
}

#if DEBUG

struct LoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        Group {

            LoadingIndicator(style: .red)
                .environment(\.colorScheme, .light)
                .previewLayout(.fixed(width: 375, height: 100))
                .previewDisplayName("RED")

            LoadingIndicator(style: .white)
                .environment(\.colorScheme, .dark)
                .previewLayout(.fixed(width: 375, height: 100))
                .background(Color.gray)
                .previewDisplayName("WHITE")
        }
    }
}

#endif
