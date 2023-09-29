//
//  ContentView.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 17.09.2023.
//

import SwiftUI

struct StartView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var coordinator: Coordinator
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Training.trainingDate, ascending: true)], animation: .default
    )
    
    private var workouts: FetchedResults<Training>
    @State var idCurrentTraining: String?
    
    var body: some View {
            VStack {
                ForEach(workouts) { workout in
                    Text("\(workout.trainingDate!)")
                }
                Spacer()
                Button {
                    idCurrentTraining = "asdasd"
                    goMainView()
                } label: {
                        Text("new")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50).background(.blue)
                            .cornerRadius(15)
                            .padding()
                }
                Button {
                    idCurrentTraining = "ascxdasd"
                    goMainView()
                } label: {
                    Text("continue")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50).background(.blue)
                        .cornerRadius(15)
                        .padding(.horizontal)
                }
                
                Button {
                    idCurrentTraining = "asdasd"
                    goMainView()
                } label: {
                        Text("open")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50).background(.blue)
                            .cornerRadius(15)
                            .padding()
                }
            }
    }
    
    func goMainView() {
        coordinator.goMainView(data: idCurrentTraining)
    }
    
    //    private func addItem() {
    //        withAnimation {
    //            let newItem = Training(context: viewContext)
    //            newItem.timestamp = Date()
    //
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
    //    }
    
    //    private func deleteItems(offsets: IndexSet) {
    //        withAnimation {
    //            offsets.map { items[$0] }.forEach(viewContext.delete)
    //
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
    //    }
}

//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView(idCurrentTraining: "asd").environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
