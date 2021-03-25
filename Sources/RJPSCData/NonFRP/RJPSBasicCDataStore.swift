//
//  Created by Ricardo Santos on 05/03/2021.
//

import Foundation
import CoreData

//
// https://codeburst.io/how-to-use-nsfetchedresultscontroller-with-swiftui-de5b75f1b8d0
// How to use NSFetchedResultsController with SwiftUI
//

public extension RJSCData.NonFRP {
    class CDataStoreManager: RJSCDataSugarProtocols {

        // MARK: - Properties

        private let modelName: String
        private let writeContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

        lazy public var viewContext: NSManagedObjectContext = {
            return self.storeContainer.viewContext
        }()

        public lazy var storeContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: self.modelName)
            container.loadPersistentStores { (_, error) in
                if let error = error {
                    fatalError("Unresolved error \(error), \(error.localizedDescription)")
                }
            }
            return container
        }()

        // MARK: - Initializers

        public init(modelName: String) {
            self.modelName = modelName
            self.writeContext.persistentStoreCoordinator = storeContainer.persistentStoreCoordinator
        }
    }

}
