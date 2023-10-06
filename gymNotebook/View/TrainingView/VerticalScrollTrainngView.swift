//
//  VerticalScrollTrainngView.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 05.10.2023.
//

import SwiftUI

struct VerticalScrollTrainngView: View {
    
    @ObservedObject var vm: TrainingViewModel
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack{
                    ForEach(vm.arrayMuscle) { item in
                        ScrollView{
                            VStack{
                                ForEach(item.exersice, id: \.self) { i in
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
                        .id(item.id)
                    }
                }
                .onChange(of: vm.trigerForScrollTo, perform:  { _ in
                    withAnimation {
                        proxy.scrollTo(vm.rowId)
                    }
                })
                .onAppear {
                    proxy.scrollTo(vm.rowId)
                }
            }
            .scrollDisabled(true)
        }
    }
}

struct VerticalScrollTrainngView_Previews: PreviewProvider {
    static var previews: some View {
        VerticalScrollTrainngView(vm: TrainingViewModel(idCurentTraining: ""))
    }
}
