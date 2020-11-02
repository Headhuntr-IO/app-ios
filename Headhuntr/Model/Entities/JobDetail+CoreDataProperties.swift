//
//  JobDetail+CoreDataProperties.swift
//  Headhuntr
//
//  Created by StartupBuilder.INFO on 11/2/20.
//
//

import Foundation
import CoreData


extension JobDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<JobDetail> {
        return NSFetchRequest<JobDetail>(entityName: "JobDetail")
    }

    @NSManaged public var companyId: String?
    @NSManaged public var companyName: String?
    @NSManaged public var end: Date?
    @NSManaged public var jobDescription: String?
    @NSManaged public var location: String?
    @NSManaged public var monthsExperience: Int32
    @NSManaged public var sequence: Int16
    @NSManaged public var start: Date?
    @NSManaged public var title: String?
    @NSManaged public var candidate: Candidate?

}

extension JobDetail : Identifiable {

}
