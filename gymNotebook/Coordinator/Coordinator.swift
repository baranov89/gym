//
//  Coordinator.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 17.09.2023.
//

import Foundation
import SwiftUI

@MainActor
final class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var currentTraining: Training?
    @Published var currentExecise: Execise?
    
    func goStartView() {
        path.removeLast(path.count)
    }
    
    func goMainView(training: Training?) {
        currentTraining = training
        path.append(PagesMy.main)
    }
    
    func goSetView(execise: ExecisePower) {
        currentExecise = execise
        path.append(PagesMy.setView)
    }
    
    @ViewBuilder
    func getPage(page: PagesMy) -> some View {
        switch page {
        case .start :
            StartView()
        case .main :
            if let currentTraining = currentTraining {
                MainView(currentTraining: currentTraining)
            }
        case .setView :
            if let currentExecise = currentExecise {
                if currentExecise is ExecisePower {
                    SetView<ExecisePower>(currentExecise: currentExecise as! ExecisePower)
                } else {
                    SetView<ExeciseCardio>(currentExecise: currentExecise as! ExeciseCardio)
                }
            }
        }
    }
}
