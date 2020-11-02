//
//  Candidate+CoreDataProperties.swift
//  Headhuntr
//
//  Created by StartupBuilder.INFO on 11/2/20.
//
//

import Foundation
import CoreData


extension Candidate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Candidate> {
        return NSFetchRequest<Candidate>(entityName: "Candidate")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var fullName: String?
    @NSManaged public var id: String?
    @NSManaged public var lastName: String?
    @NSManaged public var monthsExperience: Int64
    @NSManaged public var jobHistory: NSSet?

}

// MARK: Generated accessors for jobHistory
extension Candidate {

    @objc(addJobHistoryObject:)
    @NSManaged public func addToJobHistory(_ value: JobDetail)

    @objc(removeJobHistoryObject:)
    @NSManaged public func removeFromJobHistory(_ value: JobDetail)

    @objc(addJobHistory:)
    @NSManaged public func addToJobHistory(_ values: NSSet)

    @objc(removeJobHistory:)
    @NSManaged public func removeFromJobHistory(_ values: NSSet)

}

extension Candidate : Identifiable {

}
