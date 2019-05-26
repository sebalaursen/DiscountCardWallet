//
//  CoreDataManager.swift
//  DiscountCardWallet
//
//  Created by Sebastian on /19/2/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit
import CoreData

final class CoreDataStack {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DiscountCards")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func load(_ wallet: Wallet) {
        let context = self.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let predicate = NSPredicate(format: "username == %@", Wallet.shared.owner)
        
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        do {
            let results =  try context.fetch(request)
            
            if (results.count > 0) {
                for result in results as! [NSManagedObject] {
                    if let user = result as? User {
                        if let cards = user.cards {
                            for cardd in cards {
                                if let c = cardd as? Card {
                                    wallet.cards.append(card(backgroundColor: .white, logo: c.logo! , barcode: c.barcode!, title: c.title!))
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            let nserror = error as NSError
            print("Error while loading data \(nserror), \(nserror.userInfo)")
        }
    }
    
    func addUser(username: String) {
        let context = self.persistentContainer.viewContext
        let newNote = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        
        newNote.setValue(username, forKey: "username")
        do {
            try context.save()
        }
        catch {
            let nserror = error as NSError
            print("Error while adding data \(nserror), \(nserror.userInfo)")
        }
    }
    
    func add (logo: String?, title: String, barcode: String) {
        let context = self.persistentContainer.viewContext
        let newNote = NSEntityDescription.insertNewObject(forEntityName: "Card", into: context)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let predicate = NSPredicate(format: "username == %@", Wallet.shared.owner)
        
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        
        newNote.setValue(title, forKey: "title")
        newNote.setValue(barcode, forKey: "barcode")
        if logo != nil {
            newNote.setValue(logo, forKey: "logo")
        }
        
        do {
            let result =  try context.fetch(request)
            newNote.setValue(result[0], forKey: "user")
            
            try context.save()
        }
        catch {
            let nserror = error as NSError
            print("Error while adding data \(nserror), \(nserror.userInfo)")
        }
    }
    
    func deleteAllData(_ entity:String) {
        let context = self.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        request.returnsObjectsAsFaults = false
        do {
            let results =  try context.fetch(request)
            if (results.count > 0) {
                for result in results as! [NSManagedObject] {
                    context.delete(result)
                }
            }
            try context.save()
        } catch {
            let nserror = error as NSError
            print("Error while deleting data \(nserror), \(nserror.userInfo)")
        }
    }
    
    func delete (at: Int) {
        let context = self.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Card")
        
        request.returnsObjectsAsFaults = false
        do {
            let results =  try context.fetch(request)
            if (results.count > 0) {
                let result = results[at] as! NSManagedObject
                context.delete(result)
            }
            try context.save()
        } catch {
            let nserror = error as NSError
            print("Error while deleting data \(nserror), \(nserror.userInfo)")
        }
    }
    
    func edit (logo: String?, title: String, barcode: String, at index: Int?) {
        let context = self.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Card")
        
        request.returnsObjectsAsFaults = false
        
        do {
            let results =  try context.fetch(request)
            if (results.count > 0 && index != nil) {
                let result = results[index!] as! NSManagedObject
                
                result.setValue(title, forKey: "title")
                result.setValue(barcode, forKey: "barcode")
                if logo != nil {
                    result.setValue(logo, forKey: "logo")
                }
            }
            
            try context.save()
            
        } catch {
            let nserror = error as NSError
            print("Error while editing data \(nserror), \(nserror.userInfo)")
        }
    }
    
    func edit (logo: String?, title: String, barcode: String, at index: Int?, fav: Bool) {
        let context = self.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Card")
        
        request.returnsObjectsAsFaults = false
        
        do {
            let results =  try context.fetch(request)
            if (results.count > 0 && index != nil) {
                let result = results[index!] as! NSManagedObject
                
                result.setValue(title, forKey: "title")
                result.setValue(barcode, forKey: "barcode")
                result.setValue(fav, forKey: "isFavorite")
                if logo != nil {
                    result.setValue(logo, forKey: "logo")
                }
            }
            
            try context.save()
            
        } catch {
            let nserror = error as NSError
            print("Error while editing data \(nserror), \(nserror.userInfo)")
        }
    }
}
