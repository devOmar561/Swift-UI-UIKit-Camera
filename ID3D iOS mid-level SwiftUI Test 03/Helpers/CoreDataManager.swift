//
//  CoreDataManager.swift
//  ID3D iOS mid-level SwiftUI Test 03
//
//  Created by Alex Nagy on 21/09/2021.
//

import SwiftUI
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    /// Save image meta data
    /// - Parameters:
    ///   - entries: attributes of the entity which is to be populated
    ///   - entity: entity to be populated
    ///   - completion: completion handler that indicates the data saving completion
    func saveData(
        withEntries entries : [String: Any],
        forEntity entity    : String,
        completion          : @escaping (_ finished: Bool) -> ()
    ){
        //We need to create a context from this container
        let managedContext = PersistenceController.shared.container.viewContext
        
        //Now let’s create an entity and new user records.
        let dataEntity = NSEntityDescription.entity(
                            forEntityName : entity,
                            in            : managedContext
                         )!
        
        let Data = NSManagedObject(entity: dataEntity, insertInto: managedContext)
        
        for (key, value) in entries {
            Data.setValue(value, forKey: key)
        }
        
        //Now we have set all the values. The next step is to save them inside the Core Data
        do {
            try managedContext.save()
            completion(true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            completion(false)
        }
    }
    
    /// Retrieve image metadata
    /// - Parameter id: session id of the capture session that is to be fetched
    /// - Returns: data from the entity of related sessin id
    func retrieveData(ofSessionid id: UUID) -> [Any] {
        
        //We need to create a context from this container
        let managedContext = PersistenceController.shared.container.viewContext

        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Capture")
        fetchRequest.predicate = NSPredicate(format: "sessionId = '\(id)'")
    

        do {
            return try managedContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch")
            return [Capture]()
        }
    }
    
}
