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
    @Published var selectedMuscleOnHorizontalScroll: MuscleGroup?
    
    @Published var arrayCardio: [String] = ["элепс", "велосепед", "беговая дорожка", "лестница"]
    @Published var currentCategiry: Categiry = .power
    
    @Published var muscleGroupSelectedForAdd: MuscleGroupName?
    @Published var exerciseSelectedForAdd: ExerciseName?
    
    @Published var trigerBetweenMuscleAndExercise = true
    @Published var trigerForScrollTo: Bool = false
    @Published var pushedAddButton: Bool = false
    @Published var selectedTag: Int = 1
    @Published var height: CGFloat = 0.0
    
    var navTitel: String  {
        var temp: String = ""
        switch selectedTag {
        case 0 : temp = "Ctegory"
        case 1 : temp = "\((currentTraining?.trainingDate?.formatted(.dateTime.day().month().year()) ?? "jjjjj"))"
        case 2 : temp = "History"
        default:
            return ""
        }
        return temp
    }
}
