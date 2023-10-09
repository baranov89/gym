//
//  Training.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 06.10.2023.
//

import Foundation
import CoreData

extension Training {
    static func fetch() -> NSFetchRequest<Training> {
        let request = NSFetchRequest<Training>(entityName: "Training")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Training.trainingDate, ascending: true)]
        return request
    }
}
