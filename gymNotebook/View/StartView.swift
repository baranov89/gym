//
//  ContentView.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 17.09.2023.
//

import SwiftUI
import CoreData

struct StartView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var coordinator: Coordinator
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \MuscleGroupName.name, ascending: true)], animation: .default
    )
    private var muscleGroupName: FetchedResults<MuscleGroupName>
    @State var idCurrentTraining: String?
    
    var body: some View {
            VStack {
                Spacer()
                Button {
                    idCurrentTraining = "asdasd"
                    goMainView()
                } label: {
                        Text("new")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50).background(.blue)
                            .cornerRadius(15)
                            .padding()
                }
                Button {
                    idCurrentTraining = "ascxdasd"
                    goMainView()
                } label: {
                    Text("continue")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50).background(.blue)
                        .cornerRadius(15)
                        .padding(.horizontal)
                }
                
                Button {
                    idCurrentTraining = "asdasd"
                    goMainView()
                } label: {
                        Text("open")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50).background(.blue)
                            .cornerRadius(15)
                            .padding()
                }
            }
            .onAppear{
//                deleteAllEntities()
//                addMuscleGroup(name: "руки")
//                addExercise(name: "становая", muscleGroupArray: muscleGroupName, muclseGroupName: "руки")
//                addExercise(name: "тренажер", muscleGroupArray: muscleGroupName, muclseGroupName: "руки")
//                addExercise(name: "гири", muscleGroupArray: muscleGroupName, muclseGroupName: "руки")
//                addExercise(name: "штанга", muscleGroupArray: muscleGroupName, muclseGroupName: "руки")
            }
    }
    
    func goMainView() {
        coordinator.goMainView(data: idCurrentTraining)
    }
    
    private func addMuscleGroup(name : String) {
            withAnimation {
                let muscleGroupName = MuscleGroupName(context: viewContext)
                muscleGroupName.name = name
    
                do {
                    try viewContext.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
    
    private func addExercise(name : String, muscleGroupArray: FetchedResults<MuscleGroupName>, muclseGroupName: String) {
        var muscleGroup: MuscleGroupName
        for i in muscleGroupArray {
            if i.name == muclseGroupName {
                muscleGroup = i
                withAnimation {
                    let exercise = ExerciseName(context: viewContext)
                    exercise.name = name
                    exercise.muscleGroupName = muscleGroup
                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                }
            }
        }
        
            
        }
    
    func deleteAllEntities() {
        for i in muscleGroupName {
            do {
                viewContext.delete(i)
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
        }
        
    }
    
//        private func deleteItems(offsets: IndexSet) {
//            withAnimation {
//                offsets.map { items[$0] }.forEach(viewContext.delete)
//    
//                do {
//                    try viewContext.save()
//                } catch {
//                    // Replace this implementation with code to handle the error appropriately.
//                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                    let nsError = error as NSError
//                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//                }
//            }
//        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView(idCurrentTraining: "asd").environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
