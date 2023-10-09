//
//  AddingViewExercises.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 06.10.2023.
//

import SwiftUI

struct AddingViewExercises: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: ExerciseName.fetch(), animation: .default)
    private var exerciseName: FetchedResults<ExerciseName>
    
    @FetchRequest(fetchRequest: MuscleGroupName.fetch(), animation: .default)
    private var muscleGroupName: FetchedResults<MuscleGroupName>
    
    @FetchRequest(fetchRequest: MuscleGroup.fetch(), animation: .default)
    private var muscleGroup: FetchedResults<MuscleGroup>
    
    @FetchRequest(fetchRequest: ExecisePower.fetch(), animation: .default)
    private var execisePower: FetchedResults<ExecisePower>
    
    @ObservedObject var vm: TrainingViewModel
    
    var body: some View {
        VStack{
            if vm.pushedAddButton {
                VStack {
                    Text(vm.trigerBetweenMuscleAndExercise ? "выберите группу мышц" : "выберите упражнение")
                        .font(.system(size: 22))
                        .padding(.top, 10)
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        VStack {
                            if vm.trigerBetweenMuscleAndExercise {
                                ForEach(muscleGroupName) { muscle in
                                    Text(muscle.name ?? "")
                                        .font(.system(size: 22))
                                        .padding(.vertical, 5)
                                        .onTapGesture {
                                            vm.muscleGroupSelectedForAdd = muscle
                                            vm.trigerBetweenMuscleAndExercise.toggle()
                                        }
                                }
                            }
                            else {
                                ForEach(exerciseName) { execise in
                                    if execise.muscleGroupName!.name == vm.muscleGroupSelectedForAdd!.name {
                                        Text(execise.name ?? "")
                                            .font(.system(size: 22))
                                            .padding(.vertical, 5)
                                            .onTapGesture {
                                                vm.exerciseSelectedForAdd = execise
                                                vm.currentMuscleGroup = addMuscleGroup(name: vm.muscleGroupSelectedForAdd?.name)
                                                addExercise()
                                                withAnimation {
                                                    vm.pushedAddButton.toggle()
                                                    vm.rowId = (vm.currentMuscleGroup?.id)!
                                                    vm.trigerForScrollTo.toggle()
                                                }
                                                vm.selectedMuscleOnHorizontalScroll = (vm.muscleGroupSelectedForAdd?.name)!
                                                vm.trigerBetweenMuscleAndExercise.toggle()
                                            }
                                    }
                                }
                            }
                        }
                    })
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
    }
    
    func addMuscleGroup(name: String?) -> MuscleGroup? {
        var result: MuscleGroup?
        if let name = name {
            for i in muscleGroup {
                if i.name == name && i.training?.id == vm.currentTraining?.id {
                    result = i
                }
            }
            if result == nil {
                let muscleGroup = MuscleGroup(context: viewContext)
                withAnimation {
                    muscleGroup.name = name
                    muscleGroup.id = UUID().uuidString
                    muscleGroup.training = vm.currentTraining
                    viewContext.saveContext()
                }
                result = muscleGroup
            }
        }
        return result
    }
    
    func addExercise() {
        switch vm.currentCategiry {
        case .power:
            let execise = ExecisePower(context: viewContext)
            withAnimation {
                execise.name = vm.exerciseSelectedForAdd?.name
                execise.muscleGroup = vm.currentMuscleGroup
                viewContext.saveContext()
            }
        case .cardio:
            let execise = ExeciseCardio(context: viewContext)
            withAnimation {
                execise.name = vm.exerciseSelectedForAdd?.name
                viewContext.saveContext()
            }
        }
    }
}

struct AddingViewExercises_Previews: PreviewProvider {
    static var previews: some View {
        AddingViewExercises(vm: TrainingViewModel())
    }
}
