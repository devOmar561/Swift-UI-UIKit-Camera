//
//  ContentViewModel.swift
//  ID3D iOS mid-level SwiftUI Test 03
//
//  Created by Alex Nagy on 22/09/2021.
//

import Foundation

final class ContentViewModel: NSObject, ObservableObject {
    // MARK:- Published Properties
    @Published public var isArhiving: Bool = false
    @Published public var shouldShowAlert: Bool = false
    @Published private (set) public var archivedProgress   : Double = 0.0
    @Published private (set) public var isSessionAvailable : Bool   = false
    
    // MARK:- Properties
    private var progress: Observable<Progress> = Observable(Progress())
    
    /// Setting up observers
    /// ```
    /// Setup the 'isDismissed' observes when the child view is dismissed
    /// and the 'progress' observes the progress of the zip being archived
    /// ```
    func setObserver(){
        IS_DISMISSED.bind { session in
            if let session = session {
                self.isSessionAvailable = session
            }
        }
        
        MAIN_QUEUE.asyncAfter(deadline: .now() + 0.05) {
            if let _ = LAST_SESSION_ID {
                self.isSessionAvailable = true
            }
        }
        
        progress.bind { progress in
            if let totalProgress = progress?.totalUnitCount,
               let completedProgress = progress?.completedUnitCount, completedProgress > 0 {
                self.archivedProgress = Double(completedProgress/totalProgress )
            }
        }
    }
    
    /// Fetching and Archiving the last session
    /// ```
    /// Retrieves the last session from the core data on the base of the session ID
    /// and create the 'zip' of the last session folder.
    /// ```
    func fetchAndZipLastSession() {
        archivedProgress = 0.0
        
        let data = CoreDataManager.shared.retrieveData(
            ofSessionid: UUID(uuidString: LAST_SESSION_ID!)!)
        
        if let folderURL = FileManager.default.urls(
            for : .documentDirectory,
            in  : .userDomainMask
        ).first {
            
            if let data = data as? [Capture],
               let absoluteUrl = data.first?.url?.absoluteString,
               let name = data.first?.url?.lastPathComponent {
                
                if let range = absoluteUrl.range(of: FOLDER_NAME) {
                    
                    let upperBound = absoluteUrl[range.upperBound...]
                    let stringUrl  = "\(folderURL.absoluteString)\(FOLDER_NAME)\(upperBound)"
                    
                    if let newRange = stringUrl.range(of: name) {
                       let lowerBound = stringUrl[stringUrl.startIndex..<newRange.lowerBound]
                       let url: URL!  = URL(string: "\(lowerBound)")
                                                
                        ArchiveManager.shared.zip(
                            directoryUrl: url,
                            progress: &progress.value!,
                            overwrite: true) { result in
                            print("Archive Result:",result)
                            MAIN_QUEUE.asyncAfter(deadline: .now() + 2) {
                                self.isArhiving     = false
                                self.progress.value = Progress()
                                self.shouldShowAlert = true
                            }
                        }
                    }
                    
                }
                
            }
        }
    }
}
