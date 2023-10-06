//
//  TrainingView.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 17.09.2023.
//

import SwiftUI

struct TrainingView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ExerciseName.name, ascending: true)], animation: .default
    )
    private var exerciseName: FetchedResults<ExerciseName>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \MuscleGroupName.name, ascending: true)], animation: .default
    )
    private var muscleGroupName: FetchedResults<MuscleGroupName>
    
    @ObservedObject var vm: TrainingViewModel
    
    init(vm: TrainingViewModel) {
        self._vm = ObservedObject(wrappedValue: vm)
    }
    
    var body: some View {
        ZStack(alignment: .bottom){
            VStack{
                Divider()
                switch vm.currentCategiry {
                case .cardio: Text("сardio")
                        .font(.system(size: 22))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 30)
                        .padding(.horizontal)
                case .power:
                    HorizontallyScrollMuscleView(vm: vm)
                }
                Divider()
                switch vm.currentCategiry {
                case .cardio:
                    ScrollView{
                        VStack{
                            ForEach($vm.arrayCardio, id: \.self) { $i in
                                Text(i)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .frame(height: 50)
                                    .background(.gray.opacity(0.3))
                                    .cornerRadius(10)
                                    .font(.system(size: 22))
                                    .padding(.horizontal)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width)
                    }
                case .power:
                    VerticalScrollTrainngView(vm: vm)
                }
                Spacer()
                Divider()
                Button {
                    withAnimation {
                        vm.pushedAddButton.toggle()
                    }
                } label: {
                    Text("add \(vm.currentCategiry.rawValue) exercise")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50).background(.blue)
                        .cornerRadius(15)
                        .padding(.horizontal)
                }
                HStack {
                    Button {
                        vm.currentCategiry = .cardio
                    } label: {
                        Text("cardio")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(vm.currentCategiry == .cardio ? .blue : .gray.opacity(0.4))
                            .cornerRadius(15)
                    }
                    Button {
                        vm.currentCategiry = .power
                    } label: {
                        Text("power")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(vm.currentCategiry == .power ? .blue : .gray.opacity(0.4))
                            .cornerRadius(15)
                    }
                }
                .padding(.horizontal)
                Divider()
            }
            .zIndex(1)
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
                                    ForEach(exerciseName) { exercise in
                                        if exercise.muscleGroupName!.name == vm.muscleGroupSelectedForAdd!.name {
                                            Text(exercise.name ?? "")
                                                .font(.system(size: 22))
                                                .padding(.vertical, 5)
                                                .onTapGesture {
                                                    vm.exerciseSelectedForAdd = exercise
                                                    withAnimation {
                                                        vm.pushedAddButton.toggle()
                                                    }
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
            .zIndex(2)
        }
    }
}

struct TrainingView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingView(vm: TrainingViewModel(idCurentTraining: ""))
    }
}

enum Categiry: String {
    case cardio, power
}
