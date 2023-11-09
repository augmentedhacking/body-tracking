//
//  BodyTrackingApp.swift
//  BodyTracking
//
//  Created by Nien Lam on 11/9/23.
//  Copyright © 2023 Line Break, LLC. All rights reserved.
//

import SwiftUI

@main
struct BodyTrackingApp: App {
    @StateObject var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
                .statusBar(hidden: true)
        }
    }
}
