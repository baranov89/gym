//
//  TrainingSelectionView.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 11.10.2023.
//

import SwiftUI

struct TrainingSelectionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(fetchRequest: Training.fetch(), animation: .default)
    private var training: FetchedResults<Training>
    
    @ObservedObject var vm: StartViewModel
    
    var action: () -> ()
    
    init(vm: StartViewModel, action: @escaping () -> () ) {
        self._vm = ObservedObject(wrappedValue: vm)
        self.action = action
    }
    
    var body: some View {
        VStack{
            if vm.trigerWorkoutSelectionView {
                Spacer()
                VStack(spacing: 0) {
                    Text("Выберите тренировку")
                        .font(.system(size: 24))
                        .padding(.bottom)
                    Divider()
                    ScrollView(showsIndicators: false) {
                        ForEach(training) { item in
                            Button {
                                vm.currentTraining = item
                                action()
                                vm.trigerWorkoutSelectionView = false
                            } label: {
                                HStack{
                                    if self.training.last?.id == item.id {
                                        Text("last ")
                                            .font(.system(size: 22))
                                            .padding(.vertical, 3)
                                    }
                                    ChildSizeReader(height: $vm.height) {
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
                    .frame(height: (vm.height + 10) * (training.count < 8 ? CGFloat(training.count) : 7))
                    Divider()
                    Button {
                        withAnimation {
                            vm.trigerWorkoutSelectionView = false
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
        .background(Color.clear)
    }
}

struct TrainingSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingSelectionView(vm: StartViewModel()) {
            func foo() {
                print("")
            }
        }
    }
}
