//
//  VerticalScrollTrainngView.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 05.10.2023.
//

import SwiftUI

struct VerticalScrollTrainngView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: MuscleGroup.fetch(), animation: .default)
    private var muscleGroup: FetchedResults<MuscleGroup>
    
    @FetchRequest(fetchRequest: Training.fetch(), animation: .default)
    private var training: FetchedResults<Training>
    
    @ObservedObject var vm: TrainingViewModel
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack{
                    ForEach(Array(vm.currentTraining?.muscleGroup as! Set<MuscleGroup>), id: \.self) { item in
                        ScrollView{
                            VStack{
                                ForEach(Array(item.execisePower as! Set<ExecisePower>), id: \.self) { execise in
                                    Text(execise.name ?? "")
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
                        .id(item.id)
                    }
                }
                .onChange(of: vm.trigerForScrollTo, perform:  { _ in
                    withAnimation {
                        proxy.scrollTo(vm.selectedMuscleOnHorizontalScroll?.id)
                    }
                })
                .onAppear {
                    proxy.scrollTo(vm.selectedMuscleOnHorizontalScroll?.id)
                }
            }
            .scrollDisabled(true)
        }
    }
}

struct VerticalScrollTrainngView_Previews: PreviewProvider {
    static var previews: some View {
        VerticalScrollTrainngView(vm: TrainingViewModel())
    }
}
