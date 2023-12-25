//
//  SetView.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 12.10.2023.
//

import SwiftUI

struct SetView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest var fetchRequestPowerSet: FetchedResults<PowerSet>
    @FetchRequest var fetchRequestCardioSet: FetchedResults<CardioSet>
    
    @StateObject var vm: SetViewModel
    
    init(currentExecise: Execise) {
        _fetchRequestPowerSet = FetchRequest<PowerSet> (
            sortDescriptors: [SortDescriptor(\.set)],
            predicate: NSPredicate(format: "execisePower.id == %@", "\(currentExecise.id_)")
        )
        _fetchRequestCardioSet = FetchRequest<CardioSet> (
            sortDescriptors: [SortDescriptor(\.set)],
            predicate: NSPredicate(format: "execiseCardio.id == %@", "\(currentExecise.id_)")
        )
        self._vm = StateObject(wrappedValue: SetViewModel(currentExecise: currentExecise))
    }
                               
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
                            ForEach(fetchRequestPowerSet, id: \.self) { set in
                                VStack{
                                    Text("\(set.set)")
                                    Text("\(set.wieght)")
                                    Text("\(set.repeats)")
                                }
                            }
                        } else {
                            ForEach(fetchRequestCardioSet, id: \.self) { set in
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
            Button {
                addSet()
            } label: {
                Text("Add")
                    .frame(width: 100, height: 20)
                    .background(.gray.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.black, lineWidth: 1)
                    )
            }
        }
        .navigationTitle(vm.navTitle)
    }
    
    func addSet() {
        if vm.currentExecise is ExecisePower {
            let powerSet = PowerSet(context: viewContext)
            withAnimation {
                powerSet.id = UUID().uuidString
                powerSet.repeats = 20
                powerSet.wieght = 25
                powerSet.set = Int64(((vm.currentExecise as? ExecisePower)?.powerSet?.count ?? 0) + 1)
                powerSet.execisePower = vm.currentExecise as? ExecisePower
                viewContext.saveContext()
            }
        } else {
            
        }
    }
}

#Preview {
    NavigationView{
        SetView(currentExecise: ExecisePower())
    }
}
