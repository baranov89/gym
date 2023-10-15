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
    
    @FetchRequest(fetchRequest: PowerSet.fetch(), animation: .default)
    private var powerSet: FetchedResults<PowerSet>
    
    @FetchRequest(fetchRequest: ExecisePower.fetch(), animation: .default)
    private var execisePower: FetchedResults<ExecisePower>
    
    @FetchRequest(fetchRequest: ExerciseName.fetch(), animation: .default)
    private var exerciseName: FetchedResults<ExerciseName>
    
    @StateObject var vm: StartViewModel = StartViewModel()
   
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Button {
                    vm.currentTraining = addTraining()
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
                    vm.currentTraining = training.last
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
                        vm.trigerWorkoutSelectionView = true
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
            TrainingSelectionView(vm: vm, action: goMainView)
            .zIndex(2.0)
        }
        .onAppear{
//            deleteAllEntities()
            if muscleGroupName.isEmpty {
                addCategories()
            }
        }
    }
    
    func addCategories() {
        let arrayMuscleGroup = ["спина", "грудь", "руки", "ноги", "бицепс", "трицепс"]
        let arrayExecise = ["присяд", "жиим на тренажере", "прыжки на куб", "выпады"]
        for muscleGroup in arrayMuscleGroup {
            addMuscleGroupName(name: muscleGroup)
            for execise in arrayExecise {
                addExeciseName(name: execise, muscleGroupArray: muscleGroupName, muclseGroupName: muscleGroup)
            }
        }
    }
    
    func setFlagOnExeciseName() {
        for execiseName in exerciseName {
            execiseName.hasAlready = false
        }
    }
    
    func checkTheExercisesStatus() {
        for execise in execisePower {
            if execise.muscleGroup?.training?.id == vm.currentTraining?.id {
                for execiseName in exerciseName {
                    if execiseName.id == execise.id {
                        execiseName.hasAlready = true
                    }
                }
            }
        }
    }
    
    func goMainView() {
        setFlagOnExeciseName()
        checkTheExercisesStatus()
        coordinator.goMainView(training: vm.currentTraining)
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
    
    func addExeciseName(name : String, muscleGroupArray: FetchedResults<MuscleGroupName>, muclseGroupName: String) {
        var muscleGroup: MuscleGroupName
        for i in muscleGroupArray {
            if i.name == muclseGroupName {
                muscleGroup = i
                withAnimation {
                    let execise = ExerciseName(context: viewContext)
                    execise.name = name
                    execise.id = UUID().uuidString
                    execise.hasAlready = false
                    execise.muscleGroupName = muscleGroup
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
        if !powerSet.isEmpty {
            print("dsdsdsdsdsd")
            for i in powerSet {
                do {
                    viewContext.delete(i)
                    viewContext.saveContext()
                }
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
