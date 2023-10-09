//
//  HorizontallyScrollMuscleView.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 05.10.2023.
//

import SwiftUI

struct HorizontallyScrollMuscleView: View {
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
                    ForEach(Array(training.last?.muscleGroup as! Set<MuscleGroup>), id: \.self ) { data in
                        Text(data.name ?? "")
                            .font(.system(size: 22))
                            .foregroundColor(vm.selectedMuscleOnHorizontalScroll == data.name ? .white : .black)
                            .padding(.horizontal)
                            .frame(height: 30)
                            .background(vm.selectedMuscleOnHorizontalScroll == data.name ? .gray : .clear)
                            .cornerRadius(10)
                            .id(data.name)
                            .onTapGesture {
                                vm.selectedMuscleOnHorizontalScroll = data.name!
                                vm.trigerForScrollTo.toggle()
                                for muscle in muscleGroup {
                                    if muscle.name == data.name {
                                        vm.rowId = muscle.id!
                                    }
                                }
                            }
                    }
                }
                .animation(.bouncy(), value: vm.selectedMuscleOnHorizontalScroll)
                .padding(.horizontal)
            }
            .onChange(of: vm.selectedMuscleOnHorizontalScroll, perform: { _ in
                withAnimation {
                    proxy.scrollTo(vm.selectedMuscleOnHorizontalScroll, anchor: .center)
                }
            })
        }
    }
}

struct HorizontallyScrollMuscleView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontallyScrollMuscleView(vm: TrainingViewModel())
    }
}
