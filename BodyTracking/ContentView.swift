//
//  ContentView.swift
//  BodyTracking
//
//  Created by Nien Lam on 11/9/23.
//  Copyright © 2023 Line Break, LLC. All rights reserved.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            // AR View.
            ARViewContainer(viewModel: viewModel)
        }
    }
}

#Preview {
    ContentView(viewModel: ViewModel())
}
