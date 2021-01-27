//
//  Created by Ricardo Santos on 2021.
//

import Foundation
import Combine

enum AppErrors: Error {
    case generic
    case ok
}

public final class CancelBag {
public var subscriptions = Set<AnyCancellable>()
    public init() {
        subscriptions = Set<AnyCancellable>()
    }
    public func cancel() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
}

public extension AnyCancellable {
    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}

func randomAlphaNumericString(length: Int) -> String {
    let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let allowedCharsCount = UInt32(allowedChars.count)
    var randomString = ""

    for _ in 0 ..< length {
        let randomNum = Int(arc4random_uniform(allowedCharsCount))
        let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
        let newCharacter = allowedChars[randomIndex]
        randomString += String(newCharacter)
    }

    return randomString
}

public extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
