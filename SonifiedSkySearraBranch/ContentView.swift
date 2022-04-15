//
//  ContentView.swift
//  SonifiedSkySearraBranch
//
//  Created by seseadmin on 3/18/22.
//

import SwiftUI
import RealityKit
import UIKit
import CoreMotion
import IntentsUI
import CoreLocation

class ViewController: UIViewController, INUIAddVoiceShortcutButtonDelegate {
    func present(_ addVoiceShortcutViewController: INUIAddVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        <#code#>
    }
    
    func present(_ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        <#code#>
    }
    
    let motionManager = CMMotionManager ()
   
    override func viewDidLoad() {
        super.viewDidLoad()
    
        motionManager.startAccelerometerUpdates(to: <#OperationQueue#>)
        {_,_ in
    }
        motionManager.startGyroUpdates()
        motionManager.startMagnetometerUpdates()
        motionManager.startDeviceMotionUpdates()
        
    }
        
        func addSiriButton(to view: UIView) {
            if #available(iOS 12.0, *) {
                let button = INUIAddVoiceShortcutButton(style: .whiteOutline)
                button.delegate = self
                button.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(button)
                view.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
                view.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
                

            }
    }

struct ContentView : View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
}
