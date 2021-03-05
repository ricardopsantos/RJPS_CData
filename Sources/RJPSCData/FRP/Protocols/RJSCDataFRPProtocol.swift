//
//  RJSCDataFRPProtocol.swift
//  RJPSCData
//
//  Created by Ricardo Santos on 05/03/2021.
//

import Foundation
import CoreData

public protocol RJSCDataFRPProtocol: RJSCDataFRPEntityCreatingProtocol,
                                     RJSCDataFRPEntityFetchProtocol,
                                     RJSCDataFRPEntityDeleteProtocol,
                                     RJSCDataFRPEntitySaveProtocol {
    var viewContext: NSManagedObjectContext { get }
    var privateQueue: NSManagedObjectContext { get }
    var mainQueue: NSManagedObjectContext { get }

    func newBackgroundContext() -> NSManagedObjectContext
}
