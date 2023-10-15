//
//  ExecisePower.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 08.10.2023.
//

import Foundation
import CoreData

extension ExecisePower {
    static func fetch() -> NSFetchRequest<ExecisePower> {
        let request = NSFetchRequest<ExecisePower>(entityName: "ExecisePower")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ExecisePower.name, ascending: true)]
        return request
    }
}

extension ExecisePower: Execise {
    func getSet() -> NSSet? {
        self.powerSet
    }
    
    var id_: String {
        get {
            id ?? ""
        }
    }
    
}

protocol Execise {
    func getSet() -> NSSet?
    var id_: String { get }
}
