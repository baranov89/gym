//
//  PowerSet.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 16.10.2023.
//

import Foundation
import CoreData

extension PowerSet {
    static func fetch() -> NSFetchRequest<PowerSet> {
        let request = NSFetchRequest<PowerSet>(entityName: "PowerSet")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \PowerSet.id, ascending: true)]
        return request
    }
}
