//
//  Created by Ricardo P Santos on 2020.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Combine
import CoreData
//
import RJPSCData

let dbName = "SampleDataBase"
let bundle = Bundle.main.bundleIdentifier ?? ""

let frpCDataStore    = RJS_FRPCDataStore(name: dbName, bundle: bundle)
let nonFRPCDataStore = RJS_NonFRPCDataStore(modelName: dbName)
let cancelBag = CancelBag()

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //
        // RJS_NonFRPCDataStore
        //
        let request = NSFetchRequest<DBEntity>(entityName: DBEntity.entityName)
        do {
            let allRecordsV1 = try nonFRPCDataStore.privateQueue.fetch(request)
            let allRecordsV2 = try nonFRPCDataStore.mainQueue.fetch(request)
            let allRecordsV3 = try nonFRPCDataStore.viewContext.fetch(request)
            let allRecordsV4: [DBEntity] = try nonFRPCDataStore.fectch()
            print("Fetched \(allRecordsV1.count) records")
            print("Fetched \(allRecordsV2.count) records")
            print("Fetched \(allRecordsV3.count) records")
            print("Fetched \(allRecordsV4.count) records")
            allRecordsV1.chunked(into: 3).first?.forEach { (some) in
                print(some)
            }
        } catch {
            print(error)
        }
        
        //
        // RJS_FRPCDataStore
        //
        if false {
            CoreDataTesting_A.fetchAssyncFromDB(with: "", coreDataStore: frpCDataStore)
                .sink { (_) in } receiveValue: { (some) in print("Stored records: \(some.count)") }
                .store(in: cancelBag)

            CoreDataTesting_A.deleteAllRecordsSync(coreDataStore: frpCDataStore, cancelBag: cancelBag)

            let size = 5000
            let random = EntityModel.random(size)

            let chuncks = random.chunked(into: size / 8)

            //
            // Testing massive paralel save
            //

            chuncks.forEach { (some) in
                DispatchQueue.global(qos: .background).async {
                    CoreDataTesting_A.saveSync(models: some, using: frpCDataStore, operationID: "Save_Test_1")
                }
            }

            DispatchQueue.global(qos: .background).async {
                chuncks.forEach { (some) in
                    CoreDataTesting_A.saveSync(models: some, using: frpCDataStore, operationID: "Save_Test_2")
                }
            }
        }

    }
}
