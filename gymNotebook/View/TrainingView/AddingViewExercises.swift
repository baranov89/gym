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
    @State var chooseMuscleGroup: String = "выберите группу мышц"
    
    var body: some View {
//            VStack(spacing: 0) {
                VStack(spacing: 0)  {
                    if vm.trigerBetweenMuscleAndExercise {
                        VStack(spacing: 0) {
                            ScrollView(showsIndicators: false) {
                                ForEach(muscleGroupName) { muscle in
                                    ChildSizeReader(height: $vm.height) {
                                        Button {
                                            vm.muscleGroupSelectedForAdd = muscle
                                            vm.trigerBetweenMuscleAndExercise.toggle()
                                            chooseMuscleGroup = muscle.name ?? ""
                                        } label: {
                                            Text(muscle.name ?? "")
                                                .font(.system(size: 22))
                                                .padding(.vertical, 3)
                                        }
                                        
                                    }
                                }
                            }
                            .scrollDisabled(muscleGroupName.count < 8)
                            .frame(height: (vm.height + 10) * (muscleGroupName.count < 8 ? CGFloat(muscleGroupName.count) : 7))
                            .padding(.top, 20)
                        }
                    }
                    else {
                        VStack(spacing: 0) {
                            HStack {
                                Button {
                                    vm.trigerBetweenMuscleAndExercise.toggle()
                                } label: {
                                    HStack {
                                        Image(systemName: "chevron.backward")
                                            .padding(.trailing, 5)
                                        Text(chooseMuscleGroup)
                                            .font(.system(size: 24))
                                            .padding(.vertical)
                                    }
                                   
                                }
                                Spacer()
                            }
                            ScrollView(showsIndicators: false) {
                                ForEach(Array(vm.muscleGroupSelectedForAdd?.exerciseName as! Set<ExerciseName>)) { execiseName in
                                    ChildSizeReader(height: $vm.height) {
                                        Text(execiseName.name ?? "")
                                            .font(.system(size: 22))
                                            .padding(.vertical, 3)
                                            .foregroundColor(execiseName.hasAlready ? .gray : .blue)
                                            .onTapGesture {
                                                if !execiseName.hasAlready {
                                                    vm.exerciseSelectedForAdd = execiseName
                                                    vm.currentMuscleGroup = addMuscleGroup(name: vm.muscleGroupSelectedForAdd?.name)
                                                    addExercise(id: execiseName.id!)
                                                    vm.pushedAddButton.toggle()
                                                    withAnimation {
                                                        vm.selectedMuscleOnHorizontalScroll = vm.currentMuscleGroup
                                                        vm.trigerForScrollTo.toggle()
                                                    }
                                                    vm.trigerBetweenMuscleAndExercise.toggle()
                                                    chooseMuscleGroup = "выберите группу мышц"
                                                    execiseName.hasAlready = true
                                                }
                                            }
                                    }
                                }
                            }
                            .scrollDisabled((vm.muscleGroupSelectedForAdd?.exerciseName?.count)! < 8)
                            .frame(height: (vm.height + 10) * (vm.muscleGroupSelectedForAdd?.exerciseName?.count ?? 0 < 8 ? CGFloat(vm.muscleGroupSelectedForAdd?.exerciseName?.count ?? 0) : 7))
                        }
                    }
//                }
//                .padding()
            }
            .frame(width: UIScreen.main.bounds.width - 16)
            .background(.white)
            .presentationDetents([.height(getHeight())])
            .presentationDragIndicator(.visible)
    }
    
    func getHeight() -> CGFloat {
        if vm.trigerBetweenMuscleAndExercise {
            return (vm.height + 10) * (muscleGroupName.count < 8 ? CGFloat(muscleGroupName.count) : 7) + 30
        } else {
            return ((vm.height + 10) * (vm.muscleGroupSelectedForAdd?.exerciseName?.count ?? 0 < 8 ? CGFloat(vm.muscleGroupSelectedForAdd?.exerciseName?.count ?? 0) : 7) + 80)
        }
    }
    
    func addMuscleGroup(name: String?) -> MuscleGroup? {
        var result: MuscleGroup?
        if let name = name {
            for muscle in muscleGroup {
                if muscle.name == name && muscle.training?.id == vm.currentTraining?.id {
                    result = muscle
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
