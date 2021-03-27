//
//  ContactsApp.swift
//  Contacts
//
//  Created by Magesh Sridhar on 3/23/21.
//

import SwiftUI

@main
struct ContactsApp: App {
    let persistentContainer = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistentContainer.container.viewContext)
        }
    }
}
