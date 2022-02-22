//  Copyright © 2020 AS "Citadele Banka". All rights reserved.

import SwiftUI

public enum ActivityIndicatorColor {
    case red
    case white
}

fileprivate let delay: Double = 0.2
fileprivate let duration: Double = 0.5
fileprivate let circlesCount = 3

struct LoadingIndicator: View {

    @Environment(\.scenePhase) var scenePhase
    @State var style: ActivityIndicatorColor = .red
    @State private var fades = [Double](repeating: 1, count: circlesCount)
    @State var isAnimationStop: Bool = false
    
    private var foreverAnimation: Animation {
        isAnimationStop ? .default :
        .easeInOut(duration: duration / 2)
        .delay(delay)
        .repeatForever(autoreverses: true)
    }

    var body: some View {
        HStack(spacing: 0.0) {
            ForEach(0..<circlesCount) { i in
                Circle()
                    .fill(style == .red ? .red : .white)
                    .opacity(fades[i])
                    .onAppear { animate(at: i) }
                    .animation(foreverAnimation, value: fades[i])
            }
        }
        .frame(width: 39, height: 13)
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                isAnimationStop = false
                fades.indices.forEach { i in
                    animate(at: i)
                }
            case .background:
                isAnimationStop = true
                fades = [Double](repeating: 1, count: circlesCount)
            default: return
            }
        }
    }

    private func animate(at index: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay * Double(index) + delay) {
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
