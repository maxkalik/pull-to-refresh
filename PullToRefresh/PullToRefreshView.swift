//
//  PullToRefreshView.swift
//  PullToRefresh
//
//  Created by Maksim Kalik on 2/6/22.
//

import SwiftUI

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
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            .background(Color.red.ignoresSafeArea(.all, edges: .top))

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
                .cornerRadius(10)
                .padding(20)
            }
            .pullToRefreshable {
                arrayOfData.append("Added List Item \(arrayOfData.count)")
            }
            
        }
        .background(Color.black.opacity(0.06).ignoresSafeArea())   
    }
}
