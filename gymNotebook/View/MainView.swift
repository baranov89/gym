//
//  TrainingView.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 17.09.2023.
//

import SwiftUI

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: Training.fetch(), animation: .default)
    private var training: FetchedResults<Training>
    
    var trainingViewModel: TrainingViewModel = TrainingViewModel()
    @State var selectedTag: Int = 1
    var currentTraining: Training?
    
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
            TrainingView(vm: trainingViewModel)
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
        .onAppear {
            trainingViewModel.currentTraining = currentTraining
            trainingViewModel.selectedMuscleOnHorizontalScroll = Array(currentTraining?.muscleGroup as! Set<MuscleGroup>).first
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(currentTraining: Training())
    }
}
