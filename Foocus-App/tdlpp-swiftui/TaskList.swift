//  TaskList.swift
//  tdlpp-swiftui
//
//  Created by Ryan Chen on 11/15/22.
//

import SwiftUI

struct TaskList: View {
    @EnvironmentObject var taskdata: TaskData
    @State private var searchText = ""

    // update the current time every second
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var currentTime = Date()
    init(){
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color("lightbrown"))

    }
    enum ProfileSection : String, CaseIterable {
        case all = "All Tasks"
        case timeline = "Timeline"
        case label = "Label"
        case priority = "Priority"
    }
    @State var segmentationSelection : ProfileSection = .all
    var body: some View {
        
        NavigationView {
       
            VStack{
           
                List {
                    switch segmentationSelection {
                    //timeline
                    case .timeline:
                        let taskGroups = Dictionary(grouping: searchResults, by: {$0.status })
                        ForEach(Array(taskGroups.keys).sorted(), id: \.self) { key in
                            VStack {
                                
                                Section(header: Text(util.status2str(status: key)).font(.title2.weight(.semibold)).frame(maxHeight: 30)) {
                                    List {
                                        ForEach(taskGroups[key]!) { task in
                                            NavigationLink {
                                                TaskDetail(task: task)
                                            } label: {
                                                TaskRow(task: task, currentTime: currentTime)
                                                        .onReceive(timer, perform: { _ in
                                                            currentTime = Date()
                                                        })
                                            }
                                            .listRowBackground((Color(uiColor: util.hex2color(hexString: task.color))).opacity(0.3))
                                        }
                                        .onDelete(perform: { indexSet in
                                            // get the task to be deleted
                                            let task = taskdata.tasks[indexSet.first!]
                                            taskdata.tasks.remove(atOffsets: indexSet)
                                            // delete the task from the database
                                            util.delete(id: task.id)
                                        })
                                    }.overlay(
                                            RoundedRectangle(cornerRadius: 10, style: .circular).stroke(Color(uiColor: .tertiaryLabel), lineWidth: 1)
                                    )
                                }
                            }
                            .frame(maxWidth: .infinity, minHeight: 200)
                        
                        
                        }
                        
                    //label
                    case .label:
                        let taskGroups = Dictionary(grouping: searchResults, by: {$0.moduleLabel})
                        ForEach(Array(taskGroups.keys).sorted(), id: \.self) { key in
                            VStack {
                                
                                Section(header: Text(String(key)).font(.title2.weight(.semibold)).frame(maxHeight: 30)) {
                                    List {
                                        ForEach(taskGroups[key]!) { task in
                                            NavigationLink {
                                                TaskDetail(task: task)
                                            } label: {
                                                TaskRow(task: task, currentTime: currentTime)
                                                        .onReceive(timer, perform: { _ in
                                                            currentTime = Date()
                                                        })
                                            }
                                            .listRowBackground((Color(uiColor: util.hex2color(hexString: task.color))).opacity(0.3))
                                        }
                                        .onDelete(perform: { indexSet in
                                            // get the task to be deleted
                                            let task = taskdata.tasks[indexSet.first!]
                                            taskdata.tasks.remove(atOffsets: indexSet)
                                            // delete the task from the database
                                            util.delete(id: task.id)
                                        })
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10, style: .circular).stroke(Color(uiColor: .tertiaryLabel), lineWidth: 1)
                                    )
                                }
                            }
                            .frame(maxWidth: .infinity, minHeight: 200)
                        
                        
                        }
                    //priority
                    case .priority:
                        let taskGroups = Dictionary(grouping: searchResults, by: {$0.priority})
                        ForEach(Array(taskGroups.keys).sorted(), id: \.self) { key in
                            VStack {
                                
                                Section(header: Text(util.priority2str(priority: key)).font(.title2.weight(.semibold)).frame(maxHeight: 30)) {
                                    List {
                                        ForEach(taskGroups[key]!) { task in
                                            NavigationLink {
                                                TaskDetail(task: task)
                                            } label: {
                                                TaskRow(task: task, currentTime: currentTime)
                                                        .onReceive(timer, perform: { _ in
                                                            currentTime = Date()
                                                        })
                                            }
                                            .listRowBackground((Color(uiColor: util.hex2color(hexString: task.color))).opacity(0.3))
                                        }
                                        .onDelete(perform: { indexSet in
                                            // get the task to be deleted
                                            let task = taskdata.tasks[indexSet.first!]
                                            taskdata.tasks.remove(atOffsets: indexSet)
                                            // delete the task from the database
                                            util.delete(id: task.id)
                                        })
                                    }.overlay(
                                            RoundedRectangle(cornerRadius: 10, style: .circular).stroke(Color(uiColor: .tertiaryLabel), lineWidth: 1)
                                    )
                                }
                            }
                            .frame(maxWidth: .infinity, minHeight: 200)
                        
                        
                        }
                        
                        
                        
                    default:
                        ForEach(searchResults) { task in
                            NavigationLink {
                                TaskDetail(task: task)
                            } label: {

                                TaskRow(task: task, currentTime: currentTime)
                                        .onReceive(timer, perform: { _ in
                                            currentTime = Date()
                                        })


                            }
                            .listRowBackground((Color(uiColor: util.hex2color(hexString: task.color))).opacity(0.3))
                            
                            
                        }
                                .onDelete(perform: { indexSet in
                                    // get the task to be deleted
                                    let task = taskdata.tasks[indexSet.first!]
                                    taskdata.tasks.remove(atOffsets: indexSet)
                                    // delete the task from the database
                                    util.delete(id: task.id)
                                })
                    }
                }
            
                Picker("", selection: $segmentationSelection) {
                            ForEach(ProfileSection.allCases, id: \.self) { option in
                                Text(option.rawValue)
                            }
                }.pickerStyle(SegmentedPickerStyle())
                    .padding()
            }
            .searchable(text: $searchText)
            .navigationTitle("Tasks")
            .navigationBarItems(
                trailing: NavigationLink(
                    "Add",
                    destination: AddView(taskdata: taskdata)
                )
            )
        }
        .navigationViewStyle(.stack)
    }
    var searchResults: [Task] {
        if searchText.isEmpty {
            return taskdata.tasks
        } else {
            return taskdata.tasks.filter { task in
                task.title.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

//struct TaskList_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskList()
//            .environmentObject(TaskData())
//    }
//}
