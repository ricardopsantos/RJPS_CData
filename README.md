<p align="center">
   <a href="https://developer.apple.com/swift/">
      <img src="https://img.shields.io/badge/Swift-5.3-orange.svg?style=flat" alt="Swift 5.3">
   </a>
    <a href="https://developer.apple.com/swift/">
      <img src="https://img.shields.io/badge/Xcode-12.0.1-blue.svg" alt="Swift 5.3">
   </a>
   <a href="https://github.com/apple/swift-package-manager">
      <img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" alt="SPM">
   </a>
   <a href="https://twitter.com/ricardo_psantos/">
      <img src="https://img.shields.io/badge/Twitter-@ricardo_psantos-blue.svg?style=flat" alt="Twitter">
   </a>
</p>

---

# Intro

Playing with [__CoreData__](https://developer.apple.com/documentation/coredata) and [__Combine__](https://developer.apple.com/documentation/combine)

---

# Notes

![Preview](_Documents/images/image1.png)

## NSPersistentContainer

* __NSPersistentContainer__ handles the creation of the Core Data stack and offers access to the __NSManagedObjectContext__ as well as a number of convenience methods.

## NSManagedObjectModel

* __NSManagedObjectModel__ describes the data that is going to be accessed by the Core Data stack. During the creation of the Core Data stack, the __NSManagedObjectModel__ is loaded into memory as the first step in the creation of the stack. After the __NSManagedObjectModel__ object is initialized, the __NSPersistentStoreCoordinator__ object is constructed.

## NSManagedObjectContext

* __NSManagedObjectContext__ is the object that your application will interact with the most. Think of it as an intelligent scratch pad. When you fetch objects from a persistent store, you bring temporary copies onto the scratch pad where they form an object graph. You can then modify those objects however you like and if you choose to save the changes you have made, the context ensures that your objects are in a valid state. If they are, the changes are written to the persistent store, new records are added for objects you created, and records are removed for objects you deleted.

## NSPersistentStoreCoordinator

* __NSPersistentStoreCoordinator__ sits in the middle of the Core Data stack. It is responsible for realizing instances of entities that are defined inside of the model. It creates new instances of the entities in the model, and it retrieves existing instances from a persistent store (__NSPersistentStore__) which can be on disk or in memory depending on the structure of the application.