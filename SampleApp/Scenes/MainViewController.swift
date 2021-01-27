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
//import RJPSCData

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let dbName = "SampleDataBase"
        let bundle = "com.rjps.libuf.SampleApp"
        let testing = CoreDataTesting()
        let coreDataStore = CoreDataStore(name: dbName, bundle: bundle)
        let cancelBag = CancelBag()
        CoreDataTesting.Assync.fetchFromDB(with: "", coreDataStore: coreDataStore).sink { (_) in } receiveValue: { (some) in print(some.count) }
        
        let size = 50000
        let random = EntityModel.random(size)
      
        if true {
            DispatchQueue.global(qos: .background).async {
                let chuncks = random.chunked(into: size / 8)
                chuncks.forEach { (some) in
                    CoreDataTesting.Sync.save(models: some, using: coreDataStore)
                }
            }
        }

        if false {
            DispatchQueue.global(qos: .background).async {
                random.forEach { (random) in
                    CoreDataTesting.Sync.save(model: random, coreDataStore: coreDataStore, cancelBag: cancelBag)
                }
            }
        }

        


    }

    
}
