# Camera UIKit Project

This test project is confidential.


## CameraController

This view controller contains the logic for saving images from the camera to local storage, the images are also saved to your camera roll for debug purposes.

It references other classes and helpers.


## StorageManager

Convenience class to more easily save files to local storage.


## TapticGenerator

Convenience class to more easily make taptic feedback calls. Example usage: `TapticGenerator.impact(.heavy)`


## Main.storyboard

Contains a `preview` which is a `PreviewView` to display camera passthrough, a `flashView` that animates in and out when images are captured, and `button` for capturing photos.


## PreviewView

This view contains `videoPreviewLayer` to easily display the camera passthrough for the capture session.


## Info.plist

Contains required keys for capturing and saving photos.


## Feedback from candidate

Feedback isn't required, but feel free to note anything you'd like.
