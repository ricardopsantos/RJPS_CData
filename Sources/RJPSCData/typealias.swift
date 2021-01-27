//
//  RJPSLib.Storage.typealias.swift
//  RJPSLib.Storage
//
//  Created by Ricardo Santos on 12/07/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

// swiftlint:disable all

//
// typealias? Why?
//
// 1 : When using RJSLib on other projects, instead of using `DataModelEntity.PersistentSimpleCacheWithTTL`,
// we can use `RJS_PersistentCacheWithTTL` which can be more elegant and short to use
// 2: When using RJSLib, we can type `RJS_` and the Xcode auto-complete feature will suggest only thing inside RJSLib
// 3 : if one day the module `DataModelEntity.PersistentSimpleCacheWithTTL` changes name for something
// like `DataModelEntity.PersistentSimpleCacheWithSmallTTL`,
// the external apps using the alias wont need to change anything because the alias stays the same
//

//extension RJSLib {
//    public struct  Storages { private init() {} }
//}

