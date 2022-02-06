//
//  ContentView.swift
//  PullToRefresh
//
//  Created by Maksim Kalik on 12/27/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        PullToRefreshView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct PullToRefreshView: View {
    
    @State var arrayOfData: [String] = [String](repeating: "List item number: ", count: 7)
        .enumerated()
        .map { "\($1) \($0)" }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Pull to Refresh")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding()
            .background(Color.yellow.ignoresSafeArea(.all, edges: .top))

            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(arrayOfData, id: \.self) { value in
                        HStack {
                            Text(value)
                            Spacer()
                        }
                        .padding()
                    }
                }
                .background(Color.white)
            }
            .pullToRefreshable {
                arrayOfData.append("Added List Item \(arrayOfData.count)")
            }
            
        }
        .background(Color.black.opacity(0.06).ignoresSafeArea())
        
    }
}

fileprivate var PULL_HEIGHT: CGFloat = 60

struct Refreshable: ViewModifier {

    @State var offsetY: CGFloat = -10
    @State var startOffset: CGFloat = 0
    @State var offset: CGFloat = 0

    @State var isStarted: Bool = false
    @State var isReleased: Bool = false
    @State var isIgnored: Bool = false
    
    var action: () -> Void
    
    init(_ action: @escaping () -> Void) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            GeometryReader { reader -> AnyView in

                DispatchQueue.main.async {
                    if startOffset == 0 {
                        startOffset = reader.frame(in: .global).minY
                    }
                    offset = reader.frame(in: .global).minY
                    
                    if offset - startOffset > PULL_HEIGHT {
                        updateOffset(CGFloat(offset - startOffset) - PULL_HEIGHT)
                    }
                    
                    if offset - startOffset > PULL_HEIGHT && !isStarted && !isReleased {
                        isStarted = true
                    }
                    
                    if offsetY == PULL_HEIGHT && isStarted && !isReleased {
                        isReleased = true
                        updateData()
                    }
                    
                    if offset == startOffset && isStarted && isReleased && isIgnored {
                        isIgnored = false
                        updateData()
                    }
                    
                    if offset == startOffset && isStarted && !isReleased  {
                        withAnimation(.linear) {
                            offsetY = -10
                        }
                    }
                }
                return AnyView(Color.black.frame(width: 0, height: 0))
            }
            .frame(width: 0, height: 0)
            
            ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                LoadingIndicator()
                    .offset(y: -(offset / 2 - 20))
                content
            }
            .offset(y: offsetY)
        }
    }
    
    func updateOffset(_ value: CGFloat) {
        DispatchQueue.main.async {
            if value > PULL_HEIGHT - 1 {
                self.offsetY = PULL_HEIGHT
            } else {
                if isStarted && !isReleased {
                    self.offsetY = value
                }
            }
        }
    }
    
    func updateData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.linear) {
                if offset == startOffset {
                    action()
                    isStarted = false
                    isReleased = false
                    offsetY = -10
                } else {
                    isIgnored = true
                }
            }
        }
    }
}

extension ScrollView {
    func pullToRefreshable(_ action: @escaping () -> Void) -> some View {
        modifier(Refreshable(action))
    }
}
