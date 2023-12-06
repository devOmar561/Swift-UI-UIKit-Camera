//
//  PreviewView.swift
//  ID3D iOS mid-level SwiftUI Test 03
//
//  Created by Elliott on 5/22/21.
//

import AVFoundation
import Foundation
import UIKit

class PreviewView: UIView {
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    /// Convenience wrapper to get layer as its statically known type.
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}
