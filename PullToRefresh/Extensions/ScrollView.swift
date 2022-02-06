//
//  ScrollView.swift
//  PullToRefresh
//
//  Created by Maksim Kalik on 2/6/22.
//

import SwiftUI


extension ScrollView {
    func pullToRefreshable(_ action: @escaping () -> Void) -> some View {
        modifier(Refreshable(action))
    }
}
