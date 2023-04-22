//
//  RealmEx.swift
//  Architecture
//
//  Created by Александр Колесник on 22.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

import RealmSwift

extension Object {
    
    func writeBlock(_ block: (Realm) -> ()) {
        if isInvalidated == true { return }
        guard let realm = realm
            else {
            do {
                let realm = try Realm()
                checkTransaction(for: realm, block)
                return
            } catch {
                print("can't initialize realm")
                return
            }
        }
        checkTransaction(for: realm, block)
    }
    
    private func checkTransaction(for realm: Realm, _ block: (Realm) -> ()) {
        if realm.isInWriteTransaction == true {
            block(realm)
        } else {
            try? realm.write {
                block(realm)
            }
        }
    }
    
    func deleteSelf() {
        if isInvalidated == true || realm == nil { return }
        writeBlock { realm in
            realm.delete(self)
        }
    }
    
}

protocol DetachableObject: AnyObject {
    func detached() -> Self
}

extension Object: DetachableObject {
    
    func detached() -> Self {
        let detached = type(of: self).init()
        if isInvalidated { return detached }
        for property in objectSchema.properties {
            guard let value = value(forKey: property.name) else { continue }
            if let detachable = value as? DetachableObject {
                detached.setValue(detachable.detached(), forKey: property.name)
            } else { // Then it is a primitive
                detached.setValue(value, forKey: property.name)
            }
        }
        return detached
    }
    
}

extension Object {
    
    func realm(writeBlock: (Realm) -> ()) {
        guard let realm = realm
        else {
            if let realm = try? Realm() {
                try? realm.write {
                    writeBlock(realm)
                }
            }
            return
        }
        try? realm.write { writeBlock(realm)}
    }
    
    func save() {
        if isInvalidated { return }
        realm { realm in
            realm.add(self, update: .modified)
            realm.refresh()
        }
    }
    
}


extension List: DetachableObject {
    
    func detached() -> List<Element> {
        let result = List<Element>()
        forEach {
            if let detachableObject = $0 as? DetachableObject,
                let element = detachableObject.detached() as? Element {
                result.append(element)
            } else { // Then it is a primitive
                result.append($0)
            }
        }
        return result
    }
    
}

extension Results {
    
    func toArray() -> Array<Element> {
        return Array(self)
    }
    
    func detached() -> List<Element> {
        let result = List<Element>()
        forEach {
            if let detachableObject = $0 as? DetachableObject,
                let element = detachableObject.detached() as? Element {
                result.append(element)
            } else { // Then it is a primitive
                result.append($0)
            }
        }
        return result
    }
    
}

extension List {
    
    func toArray() -> Array<Element> {
        return Array(self)
    }
    
}

extension Realm {
    
    static func writeBlock(_ block: (Realm) -> ()) {
        guard let realm = try? Realm() else { return }
        if realm.isInWriteTransaction == true {
            block(realm)
        } else {
            try? realm.write {
                block(realm)
            }
        }
    }
    
    static func deleteAll() {
        writeBlock { realm in
            realm.deleteAll()
        }
    }
    
    static func deleteAll<T: Object>(of type: T.Type) {
        writeBlock { realm in
            realm.delete(getAll(of: type))
        }
    }
    
    static func safeRealmCreate<T: Object>(array: [Object], type: T.Type) {
        writeBlock { realm in
            let typeName = (type as Object.Type).className()
            for object in array {
                realm.create(type, value: object, update: realm.schema[typeName]?.primaryKeyProperty != nil ? .all : .modified)
            }
        }
    }
    
    static func saveAllObjectsFrom(_ array: [Object]) {
        let safeObjects = array.filter { !$0.isInvalidated }
        writeBlock { realm in
            safeObjects.forEach { realm.add($0, update: .modified) }
            realm.refresh()
        }
    }
    
    func filter<ParentType: Object>(parentType: ParentType.Type, subclasses: [ParentType.Type], predicate: NSPredicate) -> [ParentType] {
        return ([parentType] + subclasses).flatMap { classType in
            return Array(self.objects(classType).filter(predicate).sorted(byKeyPath: "time"))
        }
    }
    
    static func getAll<T: Object>(of type: T.Type) -> [T] {
        let realm = try? Realm()
        return realm?.objects(T.self).toArray() ?? []
    }
    
    static func getAllDetached<T: Object>(of type: T.Type) -> [T] {
        let realm = try? Realm()
        return realm?.objects(T.self).detached().toArray() ?? []
    }
    
    static func getObject<T: Object, KeyType>(of type: T.Type, for key: KeyType) -> T? {
        let realm = try? Realm()
        return realm?.object(ofType: T.self, forPrimaryKey: key)
    }
    
    static func getDetachedObject<T: Object, KeyType>(of type: T.Type, for key: KeyType) -> T? {
        let realm = try? Realm()
        return realm?.object(ofType: T.self, forPrimaryKey: key)?.detached()
    }
    
    static func randomId() -> Int {
        return -Int(arc4random())
    }
    
}
