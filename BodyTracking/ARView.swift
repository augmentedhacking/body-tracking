//
//  ARView.swift
//  BodyTracking
//
//  Created by Nien Lam on 11/9/23.
//  Copyright © 2023 Line Break, LLC. All rights reserved.
//
import SwiftUI
import ARKit
import RealityKit
import Combine

// SwiftUI Wrapper.
struct ARViewContainer: UIViewRepresentable {
    let viewModel: ViewModel
    
    func makeUIView(context: Context) -> CustomARView {
        CustomARView(frame: .zero, viewModel: viewModel)
    }
    
    func updateUIView(_ arView: CustomARView, context: Context) { }
}

// Custom ARView.
class CustomARView: ARView, ARSessionDelegate {
    var viewModel: ViewModel
    
    var arView: ARView { return self }
    
    var originAnchor: AnchorEntity!
    
    // Rigged character entity.
    var character: BodyTrackedEntity!
    
    // Dictionary for joint entities.
    var jointEntities = [SkeletonJoint:Entity]()
    

    init(frame: CGRect, viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        setupScene()
        
        setupEntities()
    }
    

    /// Setup scene configuration.
    func setupScene() {
        // Setup body tracking configuration.
        let configuration = ARBodyTrackingConfiguration()
        arView.renderOptions = [.disableDepthOfField, .disableMotionBlur]
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        // Set session delegate.
        arView.session.delegate = self
    }
    

    /// Define and attach entities.
    func setupEntities() {
        // Create an anchor at scene origin.
        originAnchor = AnchorEntity(world: .zero)
        arView.scene.addAnchor(originAnchor)
        
        // Load rigged model.
        character = try! ModelEntity.loadBodyTracked(named: "biped-robot")
        // character = try! ModelEntity.loadBodyTracked(named: "biped-rig-export")
        character.scale = [1, 1, 1]
//        originAnchor.addChild(character)

        // Create empty entities for all joints. Use to attach other entities.
        for joint in SkeletonJoint.allCases {
            let entity = Entity()
            jointEntities[joint] = entity
            originAnchor.addChild(entity)
        }

        /*
        // Add random colored boxes to joints.
        for joint in SkeletonJoint.mainJoints {
            let box = makeBoxEntity(name: "box", width: 0.2, height: 0.2, depth: 0.2, color: .randomHue)
            jointEntities[joint]?.addChild(box)
        }
         */
    }
    

    // Delegate method called when anchors are updated.
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
            
            // We can access the 3D skeleton here.
            let skeleton3D = bodyAnchor.skeleton
            
            // Transform for the anchor.
            let anchorTransform = bodyAnchor.transform
            
            // Update joint transforms.
            for joint in SkeletonJoint.allCases {
                jointEntities[joint]?.transform.matrix = anchorTransform * skeleton3D.modelTransform(for: joint.jointName)!
            }
            
            // Update rigged character position and orientation.
            let transform = Transform(matrix: anchorTransform)
            character.position = transform.translation
            character.orientation = transform.rotation
        }
    }
}
