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
    
    @FetchRequest(fetchRequest: MuscleGroupName.fetch(), animation: .default)
    private var muscleGroupName: FetchedResults<MuscleGroupName>
    
    @FetchRequest(fetchRequest: Training.fetch(), animation: .default)
    private var training: FetchedResults<Training>
    
    @FetchRequest(fetchRequest: MuscleGroup.fetch(), animation: .default)
    private var muscleGroup: FetchedResults<MuscleGroup>
    
    @State var currentTraining: Training?
    @State var trigerWorkoutSelectionView: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Button {
                    currentTraining = addTraining()
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
                    currentTraining = training.last
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
                    withAnimation {
                        trigerWorkoutSelectionView = true
                    }
                    
                } label: {
                    Text("open")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50).background(.blue)
                        .cornerRadius(15)
                        .padding()
                }
            }
            .zIndex(1.0)
            VStack {
                if trigerWorkoutSelectionView {
                    VStack {
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .background(.white)
                    .onTapGesture {
                        withAnimation {
                            trigerWorkoutSelectionView = false
                        }
                    }
                }
            }
            .zIndex(2.0)
            VStack{
                Spacer()
                if trigerWorkoutSelectionView {
                    VStack {
                        Text("Выберите тренировку")
                            .padding(.top, 5)
                        Spacer()
                        ScrollView(showsIndicators: false) {
                                ForEach(training) { item in
                                    Button {
                                        currentTraining = item
                                        goMainView()
                                        trigerWorkoutSelectionView = false
                                    } label: {
                                        Text("\((item.trainingDate?.formatted(.dateTime.day().month().year()) ?? ""))" )
                                            .padding(.vertical, 3)
                                    }
                                }
                        }
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width - 16, height: UIScreen.main.bounds.height * 0.4)
                    .background(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(.black, lineWidth: 1)
                    )
                    .transition(.move(edge: .trailing))
                }
            }
            .zIndex(3.0)
        }
        .onAppear{
//                            deleteAllEntities()
            //                addMuscleGroupName(name: "ноги")
            //                addExerciseName(name: "присяд", muscleGroupArray: muscleGroupName, muclseGroupName: "ноги")
            //                addExerciseName(name: "жиим на тренажере", muscleGroupArray: muscleGroupName, muclseGroupName: "ноги")
            //                addExerciseName(name: "прыжки на куб", muscleGroupArray: muscleGroupName, muclseGroupName: "ноги")
            //                addExerciseName(name: "выпады", muscleGroupArray: muscleGroupName, muclseGroupName: "ноги")
        }
    }
    
    func goMainView() {
        coordinator.goMainView(data: currentTraining)
    }
    
    func addTraining() -> Training {
        let training = Training(context: viewContext)
        withAnimation {
            training.id = UUID().uuidString
            training.trainingDate = Date()
            viewContext.saveContext()
        }
        return training
    }
    
    func addMuscleGroupName(name : String) {
        withAnimation {
            let muscleGroupName = MuscleGroupName(context: viewContext)
            muscleGroupName.name = name
            viewContext.saveContext()
        }
    }
    
    func addExerciseName(name : String, muscleGroupArray: FetchedResults<MuscleGroupName>, muclseGroupName: String) {
        var muscleGroup: MuscleGroupName
        for i in muscleGroupArray {
            if i.name == muclseGroupName {
                muscleGroup = i
                withAnimation {
                    let exercise = ExerciseName(context: viewContext)
                    exercise.name = name
                    exercise.muscleGroupName = muscleGroup
                    viewContext.saveContext()
                }
            }
        }
    }
    
    func deleteAllEntities() {
//        if !muscleGroupName.isEmpty {
//            for i in muscleGroupName {
//                do {
//                    viewContext.delete(i)
//                    viewContext.saveContext()
//                }
//            }
//        }
        if !training.isEmpty {
            print("dsdsdsdsdsd")
            for i in training {
                do {
                    viewContext.delete(i)
                    viewContext.saveContext()
                }
            }
        }
        if !muscleGroup.isEmpty {
            print("dsdsdsdsdsd")
            for i in muscleGroup {
                do {
                    viewContext.delete(i)
                    viewContext.saveContext()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView(currentTraining: Training()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
