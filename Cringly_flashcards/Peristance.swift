import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        // Nazwa musi pasować do pliku .xcdatamodeld, który stworzysz w Xcode
        container = NSPersistentContainer(name: "FlashcardsModel")
        
        // Lokalizacja pliku SQLite
        if let description = container.persistentStoreDescriptions.first {
            description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
            print("Lokalizacja bazy SQLite: \(description.url?.path ?? "nieznana")")
        }
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Błąd bazy danych: \(error), \(error.userInfo)")
            }
        }
    }
    
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            try? context.save()
        }
    }
}
