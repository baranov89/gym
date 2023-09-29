//
//  TrainingView.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 17.09.2023.
//

import SwiftUI

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Training.trainingDate, ascending: true)], animation: .default
    )
    
    private var workouts: FetchedResults<Training>
    
    @State var selectedMuscle = ""
    @State var selectedTag: Int = 1
    var idCurentTraining: String?
    
    var navTitel: String  {
        var temp: String = ""
        switch selectedTag {
        case 0 : temp = "Ctegory"
        case 1 : temp = "\(Date().formatted(.dateTime.day().month().year()))"
        case 2 : temp = "History"
        default:
            return ""
        }
        return temp
    }
    
    var body: some View {
        TabView(selection: $selectedTag) {
            CategoryView()
                .tag(0)
                .tabItem {
                    Button {
                        selectedTag = 0
                    } label: {
                        Label("категории", systemImage: "square.and.pencil")
                    }
                }
            TrainingView(id: idCurentTraining, selectedMuscle: $selectedMuscle)
                .tag(1)
                .tabItem {
                    Button {
                        if selectedTag == 1 {
                        } else {
                            selectedTag = 1
                        }
                    } label: {
                        Label("тренировка", systemImage: "dumbbell.fill")
                    }
                }
            HistoryView()
                .tag(2)
                .tabItem {
                    Button {
                        selectedTag = 2
                    } label: {
                        Label("история", systemImage:  "doc.text.magnifyingglass")
                    }
                }
        }
        .navigationTitle(navTitel)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
