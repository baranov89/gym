//
//  HorizontallyScrollMuscleView.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 05.10.2023.
//

import SwiftUI

struct HorizontallyScrollMuscleView: View {
    
    @ObservedObject var vm: TrainingViewModel
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack{
                    ForEach(vm.arrayMuscle) { data in
                        Text(data.muscle)
                            .font(.system(size: 22))
                            .foregroundColor(vm.selectedMuscleOnHorizontalScroll == data.muscle ? .white : .black)
                            .padding(.horizontal)
                            .frame(height: 30)
                            .background(vm.selectedMuscleOnHorizontalScroll == data.muscle ? .gray : .clear)
                            .cornerRadius(10)
                            .id(data.muscle)
                            .onTapGesture {
                                vm.selectedMuscleOnHorizontalScroll = data.muscle
                                vm.trigerForScrollTo.toggle()
                                for muscle in vm.arrayMuscle {
                                    if muscle.muscle == data.muscle {
                                        vm.rowId = muscle.id
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
        HorizontallyScrollMuscleView(vm: TrainingViewModel(idCurentTraining: ""))
    }
}
