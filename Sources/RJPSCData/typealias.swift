import Foundation

public struct RJSCData {
    private init() { }
    public struct FRP { private init() { } }
    public struct NonFRP { private init() { } }
}

//
// NON Function Reactive Programing (FRP) Version
//

public typealias RJS_NonFRPCDataStore = RJSCData.NonFRP.CDataStoreManager

//
// Function Reactive Programing (FRP) Version
//

public typealias RJS_FRPCDataStore         = RJSCData.FRP.CDataStoreManager
public typealias RJS_FRPCDataStoreProtocol = RJSCDataFRPProtocol // Composition of Create, Fetch, Delete and Save Protocols

//
// Sugar protocol extensions

public typealias RJS_CoreDataSugarProtocol = RJSCDataSugarProtocols
