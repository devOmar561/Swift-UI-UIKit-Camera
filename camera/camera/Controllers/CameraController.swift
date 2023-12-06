//
//  CameraController.swift
//  ID3D iOS mid-level SwiftUI Test 03
//
//  Created by Elliott on 5/21/21.
//

import AVFoundation
import Foundation
import Photos
import UIKit

class CameraController: UIViewController {

    /// view to "flash" during photo capture
    @IBOutlet weak var flash: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var preview: PreviewView!

    let captureSession = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()

    // capture delegate variables
    private(set) var requestedPhotoSettings: AVCapturePhotoSettings?
    lazy var context = CIContext()
    private var photoData: Data?
    private var photo: AVCapturePhoto?
    private var livePhotoCompanionMovieURL: URL?
    private var portraitEffectsMatteData: Data?
    private var semanticSegmentationMatteDataArray = [Data]()
    private var maxPhotoProcessingTime: CMTime?
    private var selectedSemanticSegmentationMatteTypes = [AVSemanticSegmentationMatte.MatteType]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try self.configureSession()
            self.captureSession.startRunning()
        } catch {
            self.showError(at: #function, in: #file, error: error)
        }
    }
    
    func configureSession() throws {
        captureSession.beginConfiguration()
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                  for: .video, position: .unspecified)
        guard
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
            captureSession.canAddInput(videoDeviceInput)
        else { throw CameraError.captureSessionInputFailed }
        captureSession.addInput(videoDeviceInput)
        
        guard captureSession.canAddOutput(photoOutput) else { throw CameraError.captureSessionOutputFailed }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
        captureSession.commitConfiguration()
        
        self.preview.videoPreviewLayer.session = self.captureSession
    }
    
    @IBAction func button_TouchUpInside(_ sender: Any) {

        // For non-RAW photos
        // Capture HEIF photos when supported.
        var photoSettings = AVCapturePhotoSettings()
        if  self.photoOutput.availablePhotoCodecTypes.contains(.hevc) {
            photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
        }

        // Setup photo preview settings.
        if !photoSettings.__availablePreviewPhotoPixelFormatTypes.isEmpty {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoSettings.__availablePreviewPhotoPixelFormatTypes.first!]
        }

        photoSettings.isPortraitEffectsMatteDeliveryEnabled = self.photoOutput.isPortraitEffectsMatteDeliveryEnabled

        DispatchQueue.main.async {
            // Give haptic feedback when starting
            TapticGenerator.impact(.heavy)
            
            // Tell the output to capture the photo
            self.photoOutput.capturePhoto(with: photoSettings, delegate: self)

            // Animate photo capture
            let duration = 0.1
            // fade in
            UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseInOut], animations: {() -> Void in
                self.flash.alpha = 0.99 // if this is set to 1.0, Metal will instantly hide this subview, so the fade out animation won't run or will flash
            }, completion: {(finished: Bool) -> Void in
                // fade out
                UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseInOut], animations: {() -> Void in
                    self.flash.alpha = 0.0
                }, completion:  {(finished: Bool) -> Void in
                })
            })
        }
    }
}

//MARK: AVCapturePhotoCaptureDelegate
extension CameraController: AVCapturePhotoCaptureDelegate {
    /// - Tag: WillBeginCapture
    func photoOutput(_ output: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        if resolvedSettings.livePhotoMovieDimensions.width > 0 && resolvedSettings.livePhotoMovieDimensions.height > 0 {
        }
        maxPhotoProcessingTime = resolvedSettings.photoProcessingTimeRange.start + resolvedSettings.photoProcessingTimeRange.duration
    }
    
    /// - Tag: WillCapturePhoto
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        
        guard let maxPhotoProcessingTime = maxPhotoProcessingTime else {
            return
        }
        
        // Show a spinner if processing time exceeds one second.
        let oneSecond = CMTime(seconds: 1, preferredTimescale: 1)
        if maxPhotoProcessingTime > oneSecond {
        }
    }
    
    func handleMatteData(_ photo: AVCapturePhoto, ssmType: AVSemanticSegmentationMatte.MatteType) {
        
        // Find the semantic segmentation matte image for the specified type.
        guard var segmentationMatte = photo.semanticSegmentationMatte(for: ssmType) else { return }
        
        // Retrieve the photo orientation and apply it to the matte image.
        if let orientation = photo.metadata[String(kCGImagePropertyOrientation)] as? UInt32,
            let exifOrientation = CGImagePropertyOrientation(rawValue: orientation) {
            // Apply the Exif orientation to the matte image.
            segmentationMatte = segmentationMatte.applyingExifOrientation(exifOrientation)
        }
        
        var imageOption: CIImageOption!
        
        // Switch on the AVSemanticSegmentationMatteType value.
        switch ssmType {
            case .hair:
                imageOption = .auxiliarySemanticSegmentationHairMatte
            case .skin:
                imageOption = .auxiliarySemanticSegmentationSkinMatte
            case .teeth:
                imageOption = .auxiliarySemanticSegmentationTeethMatte
            default:
                print("This semantic segmentation type is not supported!")
                return
        }
        
        guard let perceptualColorSpace = CGColorSpace(name: CGColorSpace.sRGB) else {
            self.showError(at: #function, in: #file, error: PhotoOutputError.cannotCreateColorSpaceSRGB)
            return
        }
        
        // Create a new CIImage from the matte's underlying CVPixelBuffer.
        let ciImage = CIImage( cvImageBuffer: segmentationMatte.mattingImage,
                               options: [imageOption: true,
                                         .colorSpace: perceptualColorSpace])
        
        // Get the HEIF representation of this image.
        guard let imageData = context.heifRepresentation(of: ciImage,
                                                         format: .RGBA8,
                                                         colorSpace: perceptualColorSpace,
                                                         options: [.depthImage: ciImage]) else {
            self.showError(at: #function, in: #file, error: PhotoOutputError.cannotCreateImageHEIF)
            return
        }
        
        // Add the image data to the SSM data array for writing to the photo library.
        semanticSegmentationMatteDataArray.append(imageData)
    }
    
    /// - Tag: DidFinishProcessingPhoto
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let e = error {
            print("Error capturing photo: \(e)")
            self.showError(at: #function, in: #file, error: e)
            return
        } else {
            // date photo data
            photoData = photo.fileDataRepresentation()

            // save photo
            self.photo = photo
        }
        
        // A portrait effects matte gets generated only if AVFoundation detects a face.
        if var portraitEffectsMatte = photo.portraitEffectsMatte {
            if let orientation = photo.metadata[ String(kCGImagePropertyOrientation) ] as? UInt32 {
                portraitEffectsMatte = portraitEffectsMatte.applyingExifOrientation(CGImagePropertyOrientation(rawValue: orientation)!)
            }
            let portraitEffectsMattePixelBuffer = portraitEffectsMatte.mattingImage
            let portraitEffectsMatteImage = CIImage( cvImageBuffer: portraitEffectsMattePixelBuffer, options: [ .auxiliaryPortraitEffectsMatte: true ] )
            
            guard let perceptualColorSpace = CGColorSpace(name: CGColorSpace.sRGB) else {
                portraitEffectsMatteData = nil
                self.showError(at: #function, in: #file, error: PhotoOutputError.cannotCreateColorSpaceSRGB)
                return
            }
            portraitEffectsMatteData = context.heifRepresentation(of: portraitEffectsMatteImage,
                                                                  format: .RGBA8,
                                                                  colorSpace: perceptualColorSpace,
                                                                  options: [.portraitEffectsMatteImage: portraitEffectsMatteImage])
        } else {
            portraitEffectsMatteData = nil
        }
        
        for semanticSegmentationType in output.enabledSemanticSegmentationMatteTypes {
            handleMatteData(photo, ssmType: semanticSegmentationType)
        }
    }
    
    /// - Tag: DidFinishRecordingLive
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishRecordingLivePhotoMovieForEventualFileAt outputFileURL: URL, resolvedSettings: AVCaptureResolvedPhotoSettings) {
    }
    
    /// - Tag: DidFinishProcessingLive
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingLivePhotoToMovieFileAt outputFileURL: URL, duration: CMTime, photoDisplayTime: CMTime, resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        if let e = error {
            print("Error processing Live Photo companion movie: \(e)")
            self.showError(at: #function, in: #file, error: e)
            return
        }
        livePhotoCompanionMovieURL = outputFileURL
    }
    
    /// - Tag: DidFinishCapture
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
            self.showError(at: #function, in: #file, error: error)
            return
        }
        
        guard let photoData = photoData else {
            print("No photo data resource")
            self.showError(at: #function, in: #file, error: PhotoOutputError.noPhotoData)
            return
        }

        self.save(photoData) { result in
            switch result {
            case .success(let url):
                print("snapshot saved to \(url)")
            case .failure (let error):
                self.showError(at: #function, in: #file, error: error)
            }
        }
        
        // save to photo library
        saveToPhotoLibrary(photoData)
    }
    
    func save(_ data: Data, burstIndex: Int? = nil, completion: @escaping (Result<URL, Error>) -> Void) {

        StorageManager.shared.saveFile(from: data, folder: Date().description, fileName: "1", fileExtension: "jpeg") { result in
            switch result {
            case .success(let url):
                completion(.success(url))
            case .failure (let error):
                completion(.failure(error))
            }
        }
    }
    
    /// save to photo data to Photo Library
    func saveToPhotoLibrary(_ photoData: Data) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges({
                    let options = PHAssetResourceCreationOptions()
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    options.uniformTypeIdentifier = self.requestedPhotoSettings?.processedFileType.map { $0.rawValue }
                    creationRequest.addResource(with: .photo, data: photoData, options: options)

                    if let livePhotoCompanionMovieURL = self.livePhotoCompanionMovieURL {
                        let livePhotoCompanionMovieFileOptions = PHAssetResourceCreationOptions()
                        livePhotoCompanionMovieFileOptions.shouldMoveFile = true
                        creationRequest.addResource(with: .pairedVideo,
                                                    fileURL: livePhotoCompanionMovieURL,
                                                    options: livePhotoCompanionMovieFileOptions)
                    }

                    // Save Portrait Effects Matte to Photos Library only if it was generated
                    if let portraitEffectsMatteData = self.portraitEffectsMatteData {
                        let creationRequest = PHAssetCreationRequest.forAsset()
                        creationRequest.addResource(with: .photo,
                                                    data: portraitEffectsMatteData,
                                                    options: nil)
                    }
                    // Save Portrait Effects Matte to Photos Library only if it was generated
                    for semanticSegmentationMatteData in self.semanticSegmentationMatteDataArray {
                        let creationRequest = PHAssetCreationRequest.forAsset()
                        creationRequest.addResource(with: .photo,
                                                    data: semanticSegmentationMatteData,
                                                    options: nil)
                    }

                }, completionHandler: { _, error in
                    if let error = error {
                        print("Error occurred while saving photo to photo library: \(error)")
                    }
                }
                )
            } else {
            }
        }
    }
}

/// Custom error constants for CameraError
enum CameraError: String, Error {
    case configurationFailed = "Camera configuration failed."
    case captureSessionInputFailed = "Couldn't add the camera input."
    case captureSessionOutputFailed = "Couldn't add the camera output."
    // ... additional error cases ...
}

/// Custom error constants for PhotoOutput
enum PhotoOutputError: String, Error {
    case cannotCreateColorSpaceSRGB = "Cannot create color space sRGB."
    case cannotCreateImageHEIF = "Cannot create HEIF image."
    case noPhotoData = "No photo data."
}
