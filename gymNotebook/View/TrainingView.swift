//
//  TrainingView.swift
//  gymNotebook
//
//  Created by Алексей Баранов on 17.09.2023.
//

import SwiftUI

struct TrainingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Training.trainingDate, ascending: true)], animation: .default
    )
    private var workouts: FetchedResults<Training>
    
    var idCurentTraining: String?
    @State var triger: Bool = false
    @State var rowId: String = ""
    
    init(id idCurentTraining: String?, selectedMuscle: Binding<String>) {
        self.idCurentTraining = idCurentTraining
        self._selectedMuscle = selectedMuscle
    }
    
    var arrayMuscle: [FakeData] = [
        FakeData(muscle: "спина", exersice: ["становая тяга", "гантеля", "тяга блка", "разводка гантелей"]),
        FakeData(muscle: "грудь", exersice: ["жим лежа", "гантеля", "тяга блка", "разводка гантелей"]),
        FakeData(muscle: "плечи", exersice: ["становая тяга", "гантеля", "тяга блка", "разводка гантелей"]),
        FakeData(muscle: "битцепц", exersice: ["поднятие штанги", "гантеля", "тяга блка", "разводка гантелей"]),
        FakeData(muscle: "ноги", exersice: ["присяд", "гантеля", "тяга блка", "разводка гантелей"])
    ]
    
    var arrayCardio: [String] = ["элепс", "велосепед", "беговая дорожка", "лестница"]
    var arrayStretch: [String] = ["расстяжка", "на коврике",]
    @State var currentCategiry: Categiry = .power
    @State var pushedAddButton: Bool = false
    
    @Binding var selectedMuscle: String
    
    var body: some View {
        ZStack(alignment: .bottom){
            VStack{
                Divider()
                switch currentCategiry {
                case .cardio: Text("сardio")
                        .font(.system(size: 22))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 30)
                        .padding(.horizontal)
                case .power:
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack{
                            ForEach(arrayMuscle) { data in
                                Text(data.muscle)
                                    .font(.system(size: 22))
                                    .foregroundColor(selectedMuscle == data.muscle ? .white : .black)
                                    .padding(.horizontal)
                                    .frame(height: 30)
                                    .background(selectedMuscle == data.muscle ? .gray : .clear)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        selectedMuscle = data.muscle
                                        triger.toggle()
                                        for muscle in arrayMuscle {
                                            if muscle.muscle == data.muscle {
                                                    rowId = muscle.id
                                            }
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                case .stretch: Text("stretch")
                        .font(.system(size: 22))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 30)
                        .padding(.horizontal)
                }
                Divider()
                switch currentCategiry {
                case .cardio:
                    ScrollView{
                        VStack{
                            ForEach(arrayCardio, id: \.self) { i in
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
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack{
                                ForEach(arrayMuscle) { item in
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
                            .onChange(of: triger) {
                                withAnimation {
                                    proxy.scrollTo(rowId)
                                }
                            }
                            .onAppear {
                                proxy.scrollTo(rowId)
                            }
                        }
                        .scrollDisabled(true)
                    }
                case .stretch:
                    ScrollView{
                        VStack{
                            ForEach(arrayStretch, id: \.self) { i in
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
                }
                Spacer()
                Divider()
                Button {
                    withAnimation {
                        pushedAddButton.toggle()
                    }
                } label: {
                    Text("add \(currentCategiry.rawValue) exercise")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50).background(.blue)
                        .cornerRadius(15)
                        .padding(.horizontal)
                }
                HStack {
                    Button {
                        currentCategiry = .cardio
                    } label: {
                        Text("cardio")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(currentCategiry == .cardio ? .blue : .gray.opacity(0.4))
                            .cornerRadius(15)
                    }
                    Button {
                        currentCategiry = .power
                    } label: {
                        Text("power")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(currentCategiry == .power ? .blue : .gray.opacity(0.4))
                            .cornerRadius(15)
                    }
                    Button {
                        currentCategiry = .stretch
                    } label: {
                        Text("stretch")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(currentCategiry == .stretch ? .blue : .gray.opacity(0.4))
                            .cornerRadius(15)
                    }
                }
                .padding(.horizontal)
                Divider()
            }
            .zIndex(1)
            VStack{
                if pushedAddButton {
                    Button(action: {
                        withAnimation {
                            pushedAddButton.toggle()
                        }
                        
                    }, label: {
                        Text("adsfasdf")
                    })
                    .frame(width: UIScreen.main.bounds.width - 16, height: UIScreen.main.bounds.height * 0.4)
                    .background(.white)
                    .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(.black, lineWidth: 1)
                        )
                    .transition(.move(edge: .trailing))
                }
            }
            .zIndex(2)
        }
    }
}

struct TrainingView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingView(id: "sad", selectedMuscle: .constant(""))
    }
}

enum Categiry: String {
    case cardio, power, stretch
}
