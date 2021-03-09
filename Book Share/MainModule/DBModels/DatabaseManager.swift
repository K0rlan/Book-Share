//
//  DatabaseManager.swift
//  Book Share
//
//  Created by Korlan Omarova on 06.03.2021.
//

import Foundation
import GRDB
import UIKit

var dbQueue: DatabaseQueue!

class DatabaseManager {
    
    static func setup(for application: UIApplication) throws {
        let databaseURL = try FileManager.default
            .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("db.sqlite")
        
        dbQueue = try DatabaseQueue(path: databaseURL.path)
        dbQueue.releaseMemory()
        try migrator.migrate(dbQueue)
    }
    
    static var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("createBooks") { db in
            try db.create(table: "books") { t in
                t.column("id", .integer).notNull()
                t.column("isbn", .text).notNull()
                t.column("title", .text).notNull()
                t.column("author", .text).notNull()
                t.column("image", .text)
                t.column("publish_date", .text).notNull()
                t.column("genre_id", .integer)
            }
        }
        
        migrator.registerMigration("createBooking") { db in
            try db.create(table: "booking") { t in
                t.column("id", .integer).notNull()
                t.column("user_id", .text).notNull()
                t.column("book_id", .integer).notNull()
                t.column("start_date", .text).notNull()
                t.column("end_date", .text)
            }
        }
        
        migrator.registerMigration("createGenres") { db in
            try db.create(table: "genres") { t in
                t.column("id", .integer).notNull()
                t.column("title", .text).notNull()
                t.column("sort", .integer).notNull()
                t.column("enabled", .boolean)
            }
        }

        
        return migrator
    }
    
    
}
