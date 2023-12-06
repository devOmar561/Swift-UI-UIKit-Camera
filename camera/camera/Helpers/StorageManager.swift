//
//  StorageManager.swift
//  ID3D iOS mid-level SwiftUI Test 03
//
//  Created by Elliott on 5/22/21.
//

import Foundation

class StorageManager {
    
    static let shared = StorageManager()
    
    /// Saves data to local storage.
    ///
    /// ```
    /// StorageManager.shared.saveFile(from: data, folder: "sessionName", file: "fileName", fileExtension: "jpeg", completion: { result in } )
    /// ```
    ///
    /// - Parameter from: The `Data` that should be saved.
    /// - Parameter folder: The name of the folder to create within the app's document directory. The file will be saved within this subfolder.
    /// - Parameter subfolder: The name of the subfolder to create within the folder. If set, the file will be saved within this nested subfolder instead of directly in the `folder`.
    /// - Parameter fileName: The name of the actual file that is to be saved.
    /// - Parameter fileExtension: The extension of the actual file that is to be saved.
    /// - Returns `Result` holding a success URL or an error.
    func saveFile(from data: Data, folder: String, subfolder: String? = nil, fileName: String, fileExtension: String, fileAttributes: [FileAttributeKey : Any]? = nil, completion: @escaping (Result<URL, Error>) -> Void) {
        
        do {
            var folderURL: URL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(folder, isDirectory: true)

            if let sub = subfolder {
                folderURL.appendPathComponent(sub, isDirectory: true)
            }
            
            // create folder
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)

            let fileURL = folderURL.appendingPathComponent("\(fileName).\(fileExtension)")
            let _ = FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: fileAttributes)
            
            try? data.write(to: fileURL, options: .atomic)
            
            completion(.success(fileURL))
        } catch {
            print("\(#function) \(error)")
            completion(.failure(error))
        }
    }
}
