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
    @NSManaged public var monthsExperience: Int32
    @NSManaged public var jobHistory: JobDetail?

}

extension Candidate : Identifiable {

}
