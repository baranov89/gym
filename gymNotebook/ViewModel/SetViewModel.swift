//
//  SetViewModel.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 16.10.2023.
//

import Foundation

class SetViewModel: ObservableObject {
    @Published var currentExecise: Execise
    var arrayPowerName: [String] = ["set", "wieght", "repeats"]
    var arrayCardioName: [String] = ["set", "distance", "time", "level"]
    var arrayName: [String] {
        if currentExecise is ExecisePower {
            return arrayPowerName
        } else {
            return arrayCardioName
        }
    }
 
    var navTitle: String {
        var result: String = ""
        switch currentExecise {
        case let execise as ExecisePower : result = execise.name ?? ""
        case let execise as ExeciseCardio : result = execise.name ?? ""
        default:
            return ""
        }
        return result
    }
    
    init(currentExecise: Execise) {
        self._currentExecise = Published(wrappedValue: currentExecise)
    }
}
