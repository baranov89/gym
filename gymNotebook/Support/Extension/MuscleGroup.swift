//
//  MuscleGroup.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 08.10.2023.
//

import Foundation
import CoreData

extension MuscleGroup {
    static func fetch() -> NSFetchRequest<MuscleGroup> {
        let request = NSFetchRequest<MuscleGroup>(entityName: "MuscleGroup")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MuscleGroup.name, ascending: true)]
        return request
    }
}
