//
//  AKDBService.swift
//  Architecture
//
//  Created by Александр Колесник on 22.04.2023.
//  Copyright © 2023 A&A. All rights reserved.

import UIKit
import RealmSwift

private let DBVersion: UInt64 = .zero

class AKDBService {

    @discardableResult
    init() {
        debugPrint("init database models")
        migrateDB()
    }

    private func migrateDB(upgradeVersion: UInt64 = DBVersion) {
        Realm.Configuration.defaultConfiguration =
            Realm.Configuration(
                schemaVersion: upgradeVersion,
                migrationBlock: { migration, oldSchemaVersion in
                    if oldSchemaVersion < upgradeVersion {
                        // do the stuff
                    }
            },
            deleteRealmIfMigrationNeeded: true)
        let realm = try? Realm()
        if realm == nil { migrateDB(upgradeVersion: upgradeVersion + 1); return }
        print("realm configured \(realm == nil ? "with error" : "successfully") with version \(upgradeVersion)")
    }

    // use this func to get access to realm from several sources
    // for example: app and today extension will use the same db
    
    private func migrateSharedDB() {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "YOUR_GROUP_IDENTIFIER")
        var config = Realm.Configuration()
        config.schemaVersion = DBVersion
        config.fileURL = container!.appendingPathComponent("default.realm")
        config.migrationBlock = { migration, oldSchemaVersion in
            if oldSchemaVersion < DBVersion {
                // do the stuff
            }
        }
        Realm.Configuration.defaultConfiguration = config
        _ = try? Realm()
    }
    
    
}
