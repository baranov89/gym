//
//  SetView.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 12.10.2023.
//

import SwiftUI

struct Moki: Identifiable {
    var id: UUID = UUID()
    var set: Int
    var weight: Int
    var repeats: Int
}

struct SetView<T>: View {
    
    @StateObject var vm: SetViewModel
    
    init(currentExecise: Execise) {
        self._vm = StateObject(wrappedValue: SetViewModel(currentExecise: currentExecise))
                               
    }
 
    var array: [Moki] = [Moki(set: 1, weight: 2, repeats: 3),
                          Moki(set: 2, weight: 22, repeats: 12),
                          Moki(set: 3, weight: 22, repeats: 12),
                          Moki(set: 4, weight: 22, repeats: 12)]
    
   
                               
    var body: some View {
        VStack {
            HStack{
                Spacer()
                VStack{
                    ForEach(vm.arrayName, id: \.self) { option in
                        Text(option)
                    }
                }
                ScrollView(.horizontal) {
                    HStack {
                        if vm.currentExecise is ExecisePower {
                            ForEach(Array(vm.currentExecise.getSet() as! Set<PowerSet>), id: \.self) { set in
                                VStack{
                                    Text("\(set.set)")
                                    Text("\(set.wieght)")
                                    Text("\(set.repeats)")
                                }
                            }
                        } else {
                            ForEach(Array(vm.currentExecise.getSet() as! Set<CardioSet>), id: \.self) { set in
                                VStack{
                                    Text("\(set.set)")
                                    Text("\(set.distance)")
                                    Text("\(set.time)")
                                    Text("\(set.level)")
                                }
                            }
                        }
                    }
                    
                }
                .padding(.vertical)
                .frame(width: UIScreen.main.bounds.width / 2)
                .background(.gray.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.black, lineWidth: 1)
                )
                
                Spacer()
            }
        }
        .navigationTitle(vm.navTitle)
    }
}

#Preview {
    NavigationView{
        SetView<ExecisePower>(currentExecise: ExecisePower())
    }
}
