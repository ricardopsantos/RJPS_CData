import Combine
import CoreData

public struct RJPSCDataSaveModelPublisher: Publisher {
    public typealias Output = Bool
    public typealias Failure = NSError
    
    private let action: RJPSCDataAction
    private let context: NSManagedObjectContext
    
    init(action: @escaping RJPSCDataAction, context: NSManagedObjectContext) {
        self.action = action
        self.context = context
    }
    
    public func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = Subscription(subscriber: subscriber, context: context, action: action)
        subscriber.receive(subscription: subscription)
    }
}

public extension RJPSCDataSaveModelPublisher {
    class Subscription<S> where S: Subscriber, Failure == S.Failure, Output == S.Input {
        private var subscriber: S?
        private let action: RJPSCDataAction
        private let context: NSManagedObjectContext
        
        init(subscriber: S, context: NSManagedObjectContext, action: @escaping RJPSCDataAction) {
            self.subscriber = subscriber
            self.context = context
            self.action = action
        }
    }
}

extension RJPSCDataSaveModelPublisher.Subscription: Subscription {
    public func request(_ demand: Subscribers.Demand) {
        var demand = demand
        guard let subscriber = subscriber, demand > 0 else { return }
        
        do {
            action()
            demand -= 1
            try context.save()
            demand += subscriber.receive(true)
        } catch {
            subscriber.receive(completion: .failure(error as NSError))
        }
    }
}

extension RJPSCDataSaveModelPublisher.Subscription: Cancellable {
    public func cancel() {
        subscriber = nil
    }
}
