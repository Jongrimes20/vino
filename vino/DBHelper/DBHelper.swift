//
//  DBHelper.swift
//  Store Managment System
//
//  Created by Jon Grimes on 3/29/22.
//

import Foundation
import CloudKit

/**
 - Parameters:
    - recordType: the type of record in the CloudKit database you want to query
    - predicate: the preduicate upon which you want to query these records
    - database: the database you want to query from -> if not specified will query from public DB
    - Zone: the zone you want to query from -> if not specified it will query from public DB "_defualtZone" 
 */
public func queryRecords(recordType: CKRecord.RecordType, predicate: NSPredicate, database: CKDatabase = CKContainer.default().publicCloudDatabase, Zone: CKRecordZone = CKRecordZone(zoneName: "_defaultZone")) async throws -> [CKRecord] {
    return try await database.records(type: recordType, predicate: predicate, zoneID: Zone.zoneID)
}

public extension CKDatabase {
  /// Request `CKRecord`s that correspond to a Swift type.
  ///
  /// - Parameters:
  ///   - recordType: Its name has to be the same in your code, and in CloudKit.
  ///   - predicate: for the `CKQuery`
  func records(type: CKRecord.RecordType,predicate: NSPredicate = .init(value: true),zoneID: CKRecordZone.ID) async throws -> [CKRecord] {
    try await withThrowingTaskGroup(of: [CKRecord].self) { group in
      func process(
        _ records: (
          matchResults: [(CKRecord.ID, Result<CKRecord, Error>)],
          queryCursor: CKQueryOperation.Cursor?
        )
      ) async throws {
        group.addTask {
          try records.matchResults.map { try $1.get() }
        }
        if let cursor = records.queryCursor {
          try await process(self.records(continuingMatchFrom: cursor))
        }
      }
      try await process(
        records(
          matching: .init(
            recordType: type,
            predicate: predicate
          ),
          inZoneWith: zoneID
        )
      )
        
        return try await group.reduce(into: [], +=)
      }
    }
}

