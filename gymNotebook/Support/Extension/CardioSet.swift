//
//  CardioSet.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 16.10.2023.
//

import Foundation
import CoreData

extension CardioSet {
    static func fetch() -> NSFetchRequest<CardioSet> {
        let request = NSFetchRequest<CardioSet>(entityName: "CardioSet")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CardioSet.id, ascending: true)]
        return request
    }
}
