//
//  ExeciseCardio.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 13.10.2023.
//

import Foundation

extension ExeciseCardio: Execise {
    func getSet() -> NSSet? {
        self.cardioSet
    }
    
    var id_: String {
        get{
            id ?? ""
        }
    }
    
}
