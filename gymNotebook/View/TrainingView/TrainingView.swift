//
//  TrainingView.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 17.09.2023.
//

import SwiftUI

struct TrainingView: View {

    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: ExerciseName.fetch(), animation: .default)
    private var exerciseName: FetchedResults<ExerciseName>
    
    @FetchRequest(fetchRequest: MuscleGroupName.fetch(), animation: .default)
    private var muscleGroupName: FetchedResults<MuscleGroupName>
    
    @FetchRequest(fetchRequest: ExecisePower.fetch(), animation: .default)
    private var execisePower: FetchedResults<ExecisePower>
    
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
            AddingViewExercises(vm: vm)
                .zIndex(2)
        }
    }
}

struct TrainingView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingView(vm: TrainingViewModel())
    }
}

