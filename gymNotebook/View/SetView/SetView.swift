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
    @State var currentExecise: T
 
    var array: [Moki] = [Moki(set: 1, weight: 2, repeats: 3),
                          Moki(set: 2, weight: 22, repeats: 12),
                          Moki(set: 3, weight: 22, repeats: 12),
                          Moki(set: 4, weight: 22, repeats: 12)]
    
    private var navTitle: String {
        var result: String = ""
        switch currentExecise {
        case let execise as ExecisePower : result = execise.name ?? ""
        case let execise as ExeciseCardio : result = execise.name ?? ""
        default:
            return ""
        }
        return result
    }
    var body: some View {
        VStack {
            HStack{
                Spacer()
                VStack{
//                    Array(vm.currentTraining?.muscleGroup as! Set<MuscleGroup>), id: \.self
//                    ForEach((currentExecise as? ExecisePower)?.options.sorted{$0 < $1}) { option in
//                        Text(option.name) .padding(.vertical, 4)
                    
                }
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(array) { item in
                            VStack(spacing: 0) {
                                Text("\(item.set)")
                                Text("\(item.weight)")
                                    .padding(.vertical, 8)
                                Text("\(item.repeats)")
                            }
                        }
                        .padding(.leading, 10)
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
//        .navigationTitle(navTitle)
    }
}

#Preview {
    NavigationView{
        SetView<ExecisePower>(currentExecise: ExecisePower())
    }
}
