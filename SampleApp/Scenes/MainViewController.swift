//
//  Created by Ricardo P Santos on 2020.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import Combine
//
//import RJSLibUFBase
//import RJSLibUFStorage
//import RJSLibUFNetworking
//import RJSLibUFALayouts
import RJPSCData

let dbName = "SampleDataBase"
let bundle = Bundle.main.bundleIdentifier ?? ""

let coreDataStore = RJS_FRPCDataStore(name: dbName, bundle: bundle)
let cancelBag = CancelBag()

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        CoreDataTesting.fetchAssyncFromDB(with: "", coreDataStore: coreDataStore)
            .sink { (_) in } receiveValue: { (some) in print("Stored records: \(some.count)") }
            .store(in: cancelBag)

        CoreDataTesting.deleteAllRecordsSync(coreDataStore: coreDataStore, cancelBag: cancelBag)

        let size = 5000
        let random = EntityModel.random(size)

        let chuncks = random.chunked(into: size / 8)

        //
        // Testing massive paralel save
        //

        chuncks.forEach { (some) in
            DispatchQueue.global(qos: .background).async {
                CoreDataTesting.saveSync(models: some, using: coreDataStore, operationID: "Save_Test_1")
            }
        }

        DispatchQueue.global(qos: .background).async {
            chuncks.forEach { (some) in
                CoreDataTesting.saveSync(models: some, using: coreDataStore, operationID: "Save_Test_2")
            }
        }
    }
}
