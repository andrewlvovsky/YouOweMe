//
//  BorrowerEntity+CoreDataProperties.swift
//  YouOweMe
//
//  Created by Andrew Lvovsky on 8/15/20.
//  Copyright © 2020 Andrew Lvovsky. All rights reserved.
//
//

import Foundation
import CoreData


extension BorrowerEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BorrowerEntity> {
        return NSFetchRequest<BorrowerEntity>(entityName: "BorrowerEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var activity: String?
    @NSManaged public var amount: String?
    @NSManaged public var image: Data?

}
