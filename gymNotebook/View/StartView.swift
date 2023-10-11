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
    
    @FetchRequest(fetchRequest: ExecisePower.fetch(), animation: .default)
    private var execisePower: FetchedResults<ExecisePower>
    
    @FetchRequest(fetchRequest: ExerciseName.fetch(), animation: .default)
    private var exerciseName: FetchedResults<ExerciseName>
    
    @State var currentTraining: Training?
    @State var trigerWorkoutSelectionView: Bool = false
    
    @State var height: CGFloat = 0.0
    
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
            VStack{
                if trigerWorkoutSelectionView {
                    Spacer()
                    VStack(spacing: 0) {
                        Text("Выберите тренировку")
                            .font(.system(size: 24))
                            .padding(.bottom)
                        Divider()
                        ScrollView(showsIndicators: false) {
                            ForEach(training) { item in
                                Button {
                                    currentTraining = item
                                    goMainView()
                                    trigerWorkoutSelectionView = false
                                } label: {
                                    HStack{
                                        if self.training.last?.id == item.id {
                                            Text("last ")
                                                .font(.system(size: 22))
                                                .padding(.vertical, 3)
                                        }
                                        ChildSizeReader(height: $height) {
                                            Text("\((item.trainingDate?.formatted(.dateTime.day().month().year()) ?? ""))" )
                                                .font(.system(size: 22))
                                                .padding(.vertical, 3)
                                        }
                                    }
                                }
                            }
                            .padding(.top, 3)
                            .padding(.vertical, 3)
                        }
                        .scrollDisabled(training.count < 8)
                        .frame(height: (height + 10) * (training.count < 8 ? CGFloat(training.count) : 7))
                        Divider()
                        Button {
                            withAnimation {
                                trigerWorkoutSelectionView = false
                            }
                        } label: {
                            Text("отмена")
                                .font(.system(size: 22))
                                .padding(.top)
                        }
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 16)
                    .background(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(.black, lineWidth: 1)
                    )
                    .transition(.move(edge: .trailing))
                }
            }
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
    
    func goMainView() {
        setFlagOnExeciseName()
        checkTheExercisesStatus()
        coordinator.goMainView(data: currentTraining)
    }
    
    func setFlagOnExeciseName() {
        for execiseName in exerciseName {
            execiseName.hasAlready = false
        }
    }
    
    func checkTheExercisesStatus() {
        for execise in execisePower {
            if execise.muscleGroup?.training?.id == currentTraining?.id {
                for execiseName in exerciseName {
                    if execiseName.id == execise.id {
                        execiseName.hasAlready = true
                    }
                }
            }
        }
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView(currentTraining: Training()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
