//
//  Created by Ricardo Santos on 2021.
//

import Foundation
import UIKit
import CoreData
import Combine
//
import RJPSCData

class CoreDataTesting_A {

    let cancelBag: CancelBag = CancelBag()

    static func deleteAllRecordsSync(coreDataStore: RJS_FRPCDataStoreProtocol,
                                     cancelBag: CancelBag) {
        let request = NSFetchRequest<DBEntity>(entityName: DBEntity.entityName)
        coreDataStore
            .publisher(delete: request)
            .sink { _ in } receiveValue: { _ in
                print("Deleting \(DBEntity.entityName) succeeded")
            }
            .store(in: cancelBag)
    }

    // https://blog.nfnlabs.in/run-tasks-on-background-thread-swift-5d3aec272140
    static func saveSync(models: [EntityModel], using coreDataStore: RJS_FRPCDataStoreProtocol, operationID: String) {
        let privateQueue = coreDataStore.privateQueue
        privateQueue.perform {
            models.forEach { (model) in
                autoreleasepool {
                    guard let record = NSEntityDescription.insertNewObject(forEntityName: DBEntity.entityName,
                                                                           into: privateQueue) as? DBEntity else {
                        return
                    }
                    record.field1 = model.field1
                    record.field2 = model.field2
                    do {
                        print("\(operationID) \(model.field1)")
                        if privateQueue.hasChanges {
                            try privateQueue.save()
                        }
                    } catch {
                        print("\(error)")
                    }
                    privateQueue.reset()
                }
            }
        }
    }

    static func saveSync(model: EntityModel,
                         coreDataStore: RJS_FRPCDataStoreProtocol,
                         cancelBag: CancelBag) {

        let action: RJS_FRPCDataStorePublisherAction = {
            let record: DBEntity = coreDataStore.createEntity()
            record.field1 = model.field1
            record.field2 = model.field2
        }

        coreDataStore
            .publisher(save: action)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { _ in
                print("Saved_A \(model.field1)")
            }
            .store(in: cancelBag)
    }

    public static func fetchAssyncFromDB(with filter: String,
                                         coreDataStore: RJS_FRPCDataStoreProtocol) -> FetcherListResult {
        let request = NSFetchRequest<DBEntity>(entityName: DBEntity.entityName)
        if !filter.isEmpty {
           // request.predicate = NSPredicate.with(filter: filter.trim)
        }

        let recordsToModel = coreDataStore.publisher(fetch: request)
            .mapError { _ in AppErrors.ok }.eraseToAnyPublisher()
            .flatMap { (list) -> FetcherListResult in
                let mapped = list.compactMap ({ $0.toModel })
                return Just(mapped).mapError { _ in AppErrors.ok }.eraseToAnyPublisher()
            }

        return recordsToModel.eraseToAnyPublisher()
    }

    public static func fetchAssyncRecordsCount(coreDataStore: RJS_FRPCDataStoreProtocol) -> AnyPublisher<Int, AppErrors> {
        let allRecords = fetchAssyncFromDB(with: "", coreDataStore: coreDataStore)
        let serverPublicKeyPublisher = allRecords.compactMap { $0.count }.eraseToAnyPublisher()
        return serverPublicKeyPublisher.mapError { _ in AppErrors.ok }.eraseToAnyPublisher()
    }
}
