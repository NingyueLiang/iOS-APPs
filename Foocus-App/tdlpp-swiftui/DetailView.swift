//
//  AddView.swift
//  tdlpp-swiftui
//
//  Created by 梁宁越 on 2022/11/15.

// TYhis file is not used in project, wierd
//

import SwiftUI
import Combine
struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var taskdata: TaskData
    @State var titleField: String = ""
    @State var desField: String = ""
    @State var priority: String = ""
    @State var ddlDate = Date()
    
    init(taskdata td: TaskData) {
        taskdata = td
    }
    
    init(taskdata td: TaskData, title: String, des: String, priority: Int, ddl: Date) {
        taskdata = td
        _titleField = State(initialValue: title)
        _desField = State(initialValue: des)
        _priority = State(initialValue: String(priority))
        _ddlDate = State(initialValue: ddl)
    }
    
    var body: some View {
        ScrollView {
            VStack{
                TextField("Add a title here...", text: $titleField)
                    .padding(.horizontal)
                    .frame(height:50)
                    .background(Color(white:0.95))
                    .cornerRadius(CGFloat(15.0))
                
                TextField("Brief description about the task...", text: $desField)
                    .padding(.horizontal)
                    .frame(height:150)
                    .background(Color(white:0.95))
                    .cornerRadius(CGFloat(15.0))
                
                HStack{
                    TextField("Task Priority here...", text: $priority)
                        .keyboardType(.numberPad)
                        .onReceive(Just(priority)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.priority = filtered
                            }
                        }
                        .padding(.horizontal)
                        .frame(height:50)
                        .background(Color(white:0.95))
                        .cornerRadius(CGFloat(15.0))
                    
                    
                }
                
                DatePicker(selection: $ddlDate, in: ...(Calendar.current.date(byAdding: .day, value: 730, to: Date()) ?? Date()), displayedComponents: [.date, .hourAndMinute]) {
                               Text("Due date")
                                
                }
         
                .foregroundColor(Color(white:0.7))
                .padding(.horizontal)
                .frame(height:50)
                .background(Color(white:0.95))
                .cornerRadius(CGFloat(15.0))
                
                Button(action: {
                    if(titleField != ""){
                        let task = Task(titleField, desField, nil, Date(), ddlDate, Int(priority) ?? 0, 1, nil, nil, nil)
                        taskdata.tasks.append(task)
                        util.inertDB(task: task)
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                    
                    
                }, label: {
                    Text("Add")
                        .foregroundColor(.white)
                        .frame(height:50)
                        .frame(maxWidth:.infinity)
                        .background(.blue)
                        .cornerRadius(CGFloat(15.0))
                    
                })
            }
            .padding(10)
            
           
        }.navigationTitle("Add a Task!")
    }
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            AddView( taskdata: TaskData())
//
//        }
//    }
//}
