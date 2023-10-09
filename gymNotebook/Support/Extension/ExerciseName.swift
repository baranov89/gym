//
//  ExerciseName.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 06.10.2023.
//

import Foundation
import CoreData

extension ExerciseName {
    static func fetch() -> NSFetchRequest<ExerciseName> {
        let request = NSFetchRequest<ExerciseName>(entityName: "ExerciseName")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ExerciseName.name, ascending: true)]
        return request
    }
}
