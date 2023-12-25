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
    
    @ObservedObject var vm: TrainingViewModel
//    @State var blure: CGFloat = 10
    
    init(vm: TrainingViewModel) {
        self._vm = ObservedObject(wrappedValue: vm)
        if vm.selectedMuscleOnHorizontalScroll == nil {
            vm.selectedMuscleOnHorizontalScroll = Array(vm.currentTraining?.muscleGroup as! Set<MuscleGroup>).first
        } else {
            if !(vm.currentTraining?.muscleGroup as! Set<MuscleGroup>).contains(vm.selectedMuscleOnHorizontalScroll!) {
                vm.selectedMuscleOnHorizontalScroll = Array(vm.currentTraining?.muscleGroup as! Set<MuscleGroup>).first
            }
        }
    }
    
    var body: some View {
        TabView(selection: $vm.selectedTag) {
            CategoryView()
                .tag(0)
                .tabItem {
                    Button {
                        vm.selectedTag = 0
                    } label: {
                        Label("категории", systemImage: "square.and.pencil")
                    }
                }
            TrainingView(vm: vm)
                .tag(1)
                .tabItem {
                    Button {
                        if vm.selectedTag == 1 {
                        } else {
                            vm.selectedTag = 1
                        }
                    } label: {
                        Label("тренировка", systemImage: "dumbbell.fill")
                    }
                }
            HistoryView()
                .tag(2)
                .tabItem {
                    Button {
                        vm.selectedTag = 2
                    } label: {
                        Label("история", systemImage:  "doc.text.magnifyingglass")
                    }
                }
        }
        .blur(radius: vm.pushedAddButton ? 10 : 0)
        .navigationTitle("Back")
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                HStack{
                    Text(vm.navTitel)
                }.font(.subheadline)
            }
        })
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(vm: TrainingViewModel())
    }
}
