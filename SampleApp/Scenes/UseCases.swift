//
//  Created by Ricardo Santos on 2021.
//

import Foundation
import UIKit
import CoreData
import Combine
//
import RJPSCData

typealias DBEntity = SampleDBTableEntity
typealias FetcherListResult = AnyPublisher<[EntityModel], AppErrors>

class CoreDataTesting {
    
    let cancelBag: CancelBag = CancelBag()

    static func deleteAllRecordsSync(coreDataStore: RJPSCDataStoringProtocol,
                                 cancelBag: CancelBag) {
        let request = NSFetchRequest<DBEntity>(entityName: DBEntity.entityName)
        coreDataStore
            .publicher(delete: request)
            .sink { _ in } receiveValue: { _ in
                print("Deleting \(DBEntity.entityName) succeeded")
            }
            .store(in: cancelBag)
    }
        
    // https://blog.nfnlabs.in/run-tasks-on-background-thread-swift-5d3aec272140
    static func saveSync(models: [EntityModel], using coreDataStore: RJPSCDataStoringProtocol, operationID: String) {
        let privateQueue = coreDataStore.privateQueue
        privateQueue.perform {
            models.forEach { (model) in
                autoreleasepool {
                    let record = NSEntityDescription.insertNewObject(forEntityName: DBEntity.entityName,into: privateQueue) as! DBEntity
                    record.field1 = model.field1
                    record.field2 = model.field2
                    do {
                        print("\(operationID) \(model.field1)")
                        try privateQueue.save()
                    } catch {
                        print("\(error)")
                    }
                    privateQueue.reset()
                }
            }
        }
    }
        
    static func saveSync(model: EntityModel,
              coreDataStore: RJPSCDataStoringProtocol,
              cancelBag: CancelBag) {
        
        let action: RJPSCDataAction = {
            let record: DBEntity = coreDataStore.createEntity()
            record.field1 = model.field1
            record.field2 = model.field2
        }
        
        coreDataStore
            .publicher(save: action)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { record in
                print("Saved_A \(model.field1)")
            }
            .store(in: cancelBag)
    }

    
    public static func fetchAssyncFromDB(with filter: String,
                            coreDataStore: RJPSCDataStoringProtocol) -> FetcherListResult {
        let request = NSFetchRequest<DBEntity>(entityName: DBEntity.entityName)
        if !filter.isEmpty {
           // request.predicate = NSPredicate.with(filter: filter.trim)
        }
        
        let recordsToModel = coreDataStore.publicher(fetch: request)
            .mapError { _ in AppErrors.ok }.eraseToAnyPublisher()
            .flatMap { (list) -> FetcherListResult in
                let mapped = list.compactMap ({ $0.toModel })
                return Just(mapped).mapError { _ in AppErrors.ok }.eraseToAnyPublisher()
            }
        
        return recordsToModel.eraseToAnyPublisher()
    }
    
    public static func fetchAssyncRecordsCount(coreDataStore: RJPSCDataStoringProtocol) -> AnyPublisher<Int, AppErrors> {
        let allRecords = self.fetchAssyncFromDB(with: "", coreDataStore: coreDataStore)
        let serverPublicKeyPublisher = allRecords.compactMap { $0.count }.eraseToAnyPublisher()
        return serverPublicKeyPublisher.mapError { _ in AppErrors.ok }.eraseToAnyPublisher()
    }


}


