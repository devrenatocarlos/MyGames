//
//  ConsolesManager.swift
//  MyGames
//
//  Created by Douglas Frari on 8/25/20.
//  Copyright © 2020 CESAR School. All rights reserved.
//

import Foundation


import CoreData

class ConsolesManager {
    
    static let shared = ConsolesManager()
    
    var consoles: [Console] = []
    
    
    // usando um padrao de projeto Singleton
    private init() {
        
    }
    
    
    func loadConsoles(with context: NSManagedObjectContext) {
        
        let fetchRequest: NSFetchRequest<Console> = Console.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            consoles = try context.fetch(fetchRequest)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    
    func deleteConsole(index: Int, context: NSManagedObjectContext) {
        let console = consoles[index]
        context.delete(console)
        
        do {
            try context.save()
            consoles.remove(at: index)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    
}
