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
    @Published var idCurrentTraining: String?
    
    func goStartView() {
        path.removeLast(path.count)
    }
    func goMainView(data: String?) {
        idCurrentTraining = data
        print("cccccc")
        path.append(PagesMy.main)
    }
    
    @ViewBuilder
    func getPage(page: PagesMy) -> some View {
        switch page {
        case .start :
            StartView()
        case .main :
            MainView(idCurentTraining: idCurrentTraining)
        }
    }
}
