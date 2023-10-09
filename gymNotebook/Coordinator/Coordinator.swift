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
    
    func goStartView() {
        path.removeLast(path.count)
    }
    
    func goMainView(data: Training?) {
        currentTraining = data
        path.append(PagesMy.main)
    }
    
    @ViewBuilder
    func getPage(page: PagesMy) -> some View {
        switch page {
        case .start :
            StartView()
        case .main :
            MainView(currentTraining: currentTraining)
        }
    }
}
