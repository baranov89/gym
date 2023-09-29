//
//  TrainingModel.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 17.09.2023.
//

import Foundation

struct FakeData: Identifiable {
    var id: String = UUID().uuidString
    var muscle: String
    var exersice: [String]
    
}

struct TrainingModel {
    let id: String
    let trainingData: Data
    let trainingType: TrainingType
    
    struct TrainingType {
        let cardio: [ExeciseCardio]?
        let power: [MuscleGroup]?
        let strietch: [ExeciseStrietch]?
    }
    
    struct MuscleGroup {
        let name: String
        let exercise: [ExecisePower]
    }
    
    struct ExecisePower {
        let name: String
        let execiseSet: [PowerSet]
    }
    
    struct ExeciseCardio {
        let time: Bool
        let speed: Bool
        let slope: Bool
        let distance: Bool
        let level: Bool
        let name: String
        let execiseSet: [CardioSet]
    }
    
    struct ExeciseStrietch {
        let name: String
        let execiseSet: [StrietchSet]
    }
    
    struct StrietchSet {
        let repeats: Int
        let set: Int
    }
    
    struct PowerSet {
        let repeats: Int
        let count: Int
    }
    
    struct CardioSet {
        let time: Int
        let speed: Int
        let slope: Int
        let distance: Int
        let level: Int
    }
}
