//
//  StartViewModel.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 11.10.2023.
//

import Foundation

class StartViewModel: ObservableObject {
    @Published var currentTraining: Training?
    @Published var trigerWorkoutSelectionView: Bool = false
    @Published var height: CGFloat = 0.0
}
