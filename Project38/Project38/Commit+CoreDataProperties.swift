//
//  Commit+CoreDataProperties.swift
//  Project38
//
//  Created by Tanner Quesenberry on 2/18/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//
//

import Foundation
import CoreData


extension Commit {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Commit> {
        return NSFetchRequest<Commit>(entityName: "Commit")
    }

    @NSManaged public var date: Date
    @NSManaged public var message: String
    @NSManaged public var sha: String
    @NSManaged public var url: String

}
