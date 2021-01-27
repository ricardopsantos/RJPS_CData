//
//  Created by Ricardo Santos on 27/01/2021.
//

import Foundation

extension SampleDBTableEntity {
    var toModel: EntityModel {
        return EntityModel(field1: self.field1 ?? "", field2: self.field2 ?? "")
    }
}

struct EntityModel {
    let field1: String
    let field2: String
    
    static func random(_ count: Int) -> [EntityModel] {
        var acc: [EntityModel] = []
        for x in 1...count {
            autoreleasepool {
                let some = EntityModel(field1: "id_\(x)",
                                       field2: randomAlphaNumericString(length: 100))
                acc.append(some)
            }
        }
        return acc
    }
}
