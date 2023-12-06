//
//  ArchiveManager.swift
//  ID3D iOS mid-level SwiftUI Test 03
//
//  Created by Elliott on 5/23/21.
//

import Foundation
import ZIPFoundation

class ArchiveManager {
    
    static let shared = ArchiveManager()

    /// Zips a directory and saves the archive within the same directory. Progress updates as the folder is zipped.
    /// ```
    /// StorageManager.shared.zip(directoryUrl: url, progress: &progress, overwrite: true) { result in }
    /// ```
    /// - Important: This function implements [ZIPFoundation](https://github.com/weichsel/ZIPFoundation#zipping-files-and-directories) with [progress](https://github.com/weichsel/ZIPFoundation#progress-tracking-and-cancellation).
    /// - Returns: A a `Result` object holding the url of the zip or an error.
    func zip(directoryUrl: URL, progress: inout Progress, overwrite: Bool = false, completion: (Result<URL, Error>) -> Void) {
        do {
            let zipName = "\(directoryUrl.lastPathComponent).zip"
            let zipUrl = directoryUrl.appendingPathComponent(zipName)
            if overwrite == true {
                // check if file exists
                if FileManager.default.fileExists(atPath: zipUrl.path) {
                    // delete it so the new zip overwrites it
                    try FileManager.default.removeItem(atPath: zipUrl.path)
                }
            }
            
            try FileManager.default.zipItem(at: directoryUrl, to: zipUrl, shouldKeepParent: false, compressionMethod: .none, progress: progress)
            
            completion(.success(zipUrl))
        } catch {
            completion(.failure(error))
        }
    }
}
