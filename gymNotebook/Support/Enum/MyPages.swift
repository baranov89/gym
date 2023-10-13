//
//  MyPages.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 17.09.2023.
//

import Foundation

enum PagesMy: String, CaseIterable, Identifiable {
    case start, main, setView
    var id: String {
        self.rawValue
    }
}
