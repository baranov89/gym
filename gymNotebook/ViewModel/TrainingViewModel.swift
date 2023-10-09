//
//  TrainingViewModel.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 05.10.2023.
//

import Foundation
import SwiftUI

class TrainingViewModel: ObservableObject {
    @Published var currentTraining: Training?
    @Published var currentMuscleGroup: MuscleGroup?
    @Published var trigerForScrollTo: Bool = false
    @Published var rowId: String = ""
    @Published var selectedMuscleOnHorizontalScroll: String = ""
    
    @Published var arrayMuscle: [FakeData] = [
        FakeData(muscle: "спина", exersice: ["становая тяга", "гантеля", "тяга блка", "разводка гантелей"]),
        FakeData(muscle: "грудь", exersice: ["жим лежа", "гантеля", "тяга блка", "разводка гантелей"]),
        FakeData(muscle: "плечи", exersice: ["становая тяга", "гантеля", "тяга блка", "разводка гантелей"]),
        FakeData(muscle: "битцепц", exersice: ["поднятие штанги", "гантеля", "тяга блка", "разводка гантелей"]),
        FakeData(muscle: "ноги", exersice: ["присяд", "гантеля", "тяга блка", "разводка гантелей"])
    ]
    
    @Published var arrayCardio: [String] = ["элепс", "велосепед", "беговая дорожка", "лестница"]
    @Published var arrayStretch: [String] = ["расстяжка", "на коврике",]
    @Published var currentCategiry: Categiry = .power
    @Published var pushedAddButton: Bool = false
    
    @Published var muscleGroupSelectedForAdd: MuscleGroupName?
    @Published var exerciseSelectedForAdd: ExerciseName?
    
    @Published var trigerBetweenMuscleAndExercise = true
}
