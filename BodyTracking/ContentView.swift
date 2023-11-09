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

            // Move right hand label to screen space position.
            if let rightHandJointPos = viewModel.rightHandJointPos {
                Text("Right Hand")
                    .font(.title3).fontWeight(.medium)
                    .padding(10)
                    .background(Color.green)
                    .position(rightHandJointPos)
            }

            // Move left hand label to screen space position.
            if let leftHandJointPos = viewModel.leftHandJointPos {
                Text("Left Hand")
                    .font(.title3).fontWeight(.medium)
                    .padding(10)
                    .background(Color.blue)
                    .position(leftHandJointPos)
            }
        }
    }
}

#Preview {
    ContentView(viewModel: ViewModel())
}
