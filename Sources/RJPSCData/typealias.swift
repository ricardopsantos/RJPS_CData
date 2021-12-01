import Foundation

public struct RJSCDataNameSpace {
    private init() { }
    public struct FRP { private init() { } }    // Function Reactive Programing (FRP) Version
    public struct NonFRP { private init() { } } // NON Function Reactive Programing (FRP) Version
}

//
// NON Function Reactive Programing (FRP) Version
//

public typealias RJS_NonFRPCDataStore = RJSCDataNameSpace.NonFRP.CDataStoreManager

//
// Function Reactive Programing (FRP) Version
//

public typealias RJS_FRPCDataStore = RJSCDataNameSpace.FRP.CDataStoreManager

//
// Protocols
//

public typealias RJS_FRPCDataStoreProtocol  = CDataFRPComposedProtocol // Composition of Create, Fetch, Delete and Save Protocols
public typealias RJS_CDataComposedProtocols = CDataComposedProtocols   // Composition of Create, Fetch, Delete and Save Protocols
