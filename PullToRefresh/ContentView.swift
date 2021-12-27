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
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Title")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding()
            .background(Color.orange.ignoresSafeArea(.all, edges: .top))
            
            ListView()
        }
        .background(Color.black.opacity(0.06).ignoresSafeArea())
        
    }
}

struct ListView: View {
    @State var arrayOfData: [String] = [String](repeating: "List item", count: 7)
        .enumerated()
        .map { "\($1) \($0)" }
    
    @State var offsetY: CGFloat = -10
    @State var startOffset: CGFloat = 0
    @State var offset: CGFloat = 0

    @State var isStarted: Bool = false
    @State var isReleased: Bool = false
    @State var isIgnored: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            GeometryReader { reader -> AnyView in

                DispatchQueue.main.async {
                    if startOffset == 0 {
                        startOffset = reader.frame(in: .global).minY
                    }
                    offset = reader.frame(in: .global).minY
                    
                    if offset - startOffset > 60 {
                        updateOffset(CGFloat(offset - startOffset) - 60 - 10)
                    }
                    
                    if offset - startOffset > 60 && !isStarted && !isReleased {
                        isStarted = true
                    }
                    
                    if offsetY == 65 && isStarted && !isReleased {
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
                Rectangle()
                    .frame(width: 40, height: 40)
                    .offset(y: -55)
                
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
            .offset(y: offsetY)
        }
    }
    
    func updateOffset(_ value: CGFloat) {
        DispatchQueue.main.async {
            if value > 64 {
                self.offsetY = 65
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
                    arrayOfData.append("Added Item List \(arrayOfData.count)")
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
