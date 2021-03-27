//
//  Persistence.swift
//  Contacts
//
//  Created by Magesh Sridhar on 3/24/21.
//

import CoreData

struct PersistenceController{
    static let shared = PersistenceController()
    let container : NSPersistentContainer
    
    init(){
        container = NSPersistentContainer(name: "Kontakts")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError?{
                fatalError("Unresolved Error \(error)")
            }
        }
    }
}
