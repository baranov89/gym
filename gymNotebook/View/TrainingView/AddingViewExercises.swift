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
    @State var height: CGFloat = 0.0
    
    var body: some View {
        VStack{
            Spacer()
            if vm.pushedAddButton {
                VStack(spacing: 0) {
                    Text(vm.trigerBetweenMuscleAndExercise ? "выберите группу мышц" : "выберите упражнение")
                        .font(.system(size: 24))
                        .padding(.vertical)
                    Divider()
                        .padding(.horizontal)
                    Button(action: {
                        
                    }, label: {
                        VStack(spacing: 0)  {
                            if vm.trigerBetweenMuscleAndExercise {
                                VStack(spacing: 0) {
                                    ScrollView(showsIndicators: false) {
                                        ForEach(muscleGroupName) { muscle in
                                            ChildSizeReader(height: $height) {
                                                Text(muscle.name ?? "")
                                                    .font(.system(size: 22))
                                                    .padding(.vertical, 3)
                                                    .onTapGesture {
                                                        vm.muscleGroupSelectedForAdd = muscle
                                                        vm.trigerBetweenMuscleAndExercise.toggle()
                                                    }
                                            }
                                        }
                                    }
                                    .scrollDisabled(muscleGroupName.count < 8)
                                    .frame(height: (height + 10) * (muscleGroupName.count < 8 ? CGFloat(muscleGroupName.count) : 7))
                                    Divider()
                                    Button {
                                        vm.pushedAddButton.toggle()
                                    } label: {
                                        Text("отмена")
                                            .font(.system(size: 22))
                                            .padding(.top)
                                    }
                                }
                            }
                            else {
                                VStack(spacing: 0) {
                                    ScrollView(showsIndicators: false) {
                                        ForEach(Array(vm.muscleGroupSelectedForAdd?.exerciseName as! Set<ExerciseName>)) { execise in
                                            ChildSizeReader(height: $height) {
                                                Text(execise.name ?? "")
                                                    .font(.system(size: 22))
                                                    .padding(.vertical, 3)
                                                    .foregroundColor(execise.hasAlready ? .gray : .blue)
                                                    .onTapGesture {
                                                        if !execise.hasAlready {
                                                            vm.exerciseSelectedForAdd = execise
                                                            vm.currentMuscleGroup = addMuscleGroup(name: vm.muscleGroupSelectedForAdd?.name)
                                                            addExercise(id: execise.id!)
                                                            withAnimation {
                                                                vm.pushedAddButton.toggle()
                                                                vm.selectedMuscleOnHorizontalScroll = vm.currentMuscleGroup
                                                                vm.trigerForScrollTo.toggle()
                                                            }
                                                            vm.trigerBetweenMuscleAndExercise.toggle()
                                                            execise.hasAlready = true
                                                        }
                                                    }
                                            }
                                        }
                                    }
                                    .scrollDisabled((vm.muscleGroupSelectedForAdd?.exerciseName?.count)! < 8)
                                    .frame(height: (height + 10) * (vm.muscleGroupSelectedForAdd?.exerciseName?.count ?? 0 < 8 ? CGFloat(vm.muscleGroupSelectedForAdd?.exerciseName?.count ?? 0) : 7))
                                    Divider()
                                    Button {
                                        vm.trigerBetweenMuscleAndExercise.toggle()
                                    } label: {
                                        Text("назад")
                                            .font(.system(size: 22))
                                            .padding(.top)
                                    }
                                }
                            }
                        }
                    })
                    .padding()
                }
                .frame(width: UIScreen.main.bounds.width - 16)
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
    
    func addExercise(id: String) {
        switch vm.currentCategiry {
        case .power:
            let execise = ExecisePower(context: viewContext)
            withAnimation {
                execise.name = vm.exerciseSelectedForAdd?.name
                execise.id = id
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
