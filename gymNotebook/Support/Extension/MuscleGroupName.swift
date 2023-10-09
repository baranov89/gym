//
//  MuscleGroupName.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 06.10.2023.
//

import Foundation
import CoreData

extension MuscleGroupName {
    static func fetch() -> NSFetchRequest<MuscleGroupName> {
        let request = NSFetchRequest<MuscleGroupName>(entityName: "MuscleGroupName")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MuscleGroupName.name, ascending: true)]
        return request
    }
}
