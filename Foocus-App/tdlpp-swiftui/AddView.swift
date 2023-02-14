//
//  AddView.swift
//  tdlpp-swiftui
//
//  Created by 梁宁越 on 2022/11/15.
//

import SwiftUI
import Combine
import UIKit





struct AddView: View {
    
    @State private var isShowPhotoLibrary = false
    @State private var image: UIImage = UIImage()
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var taskdata: TaskData
    @State var titleField: String = ""
    @State var desField: String = ""
    @State var priority: String = "5" // default picker 1
    @State var moduleLabel: String = "No Label" // default picker 1
    @State var status: String = "0" // default picker 0
    @State var ddlDate = Date()
    @State private var chosenColor:Color = Color(uiColor: util.hex2color(hexString: "#355C7D")) 
    
    // for file selection use
    @State var fileIsImporting:Bool = false
    @State var filePath: String = ""
    @State var fileName: String = "" // for dsiplay use
    
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
                    .background(Color(.systemFill))
                    .cornerRadius(CGFloat(15.0))
                
                TextField("Brief description about the task...", text: $desField)
                    .padding(.horizontal)
                    .frame(height:150)
                    .background(Color(.systemFill))
                    .cornerRadius(CGFloat(15.0))
                
                HStack {
                    Text("Priority:").foregroundColor(Color(.systemGray)).font(.headline.weight(.medium))
                    Picker(selection: $priority, label:EmptyView()) {
                        ForEach(0...5, id: \.self) {
                            Text(util.priority2str(priority: $0)).tag(String($0)) // tag and
                        }
                    }
                    .padding(.horizontal)
                    .frame(height:50)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemFill))
                    .cornerRadius(CGFloat(15.0))
                }.frame(maxWidth: .infinity)
                
                HStack {
                    Text("Label:   ").foregroundColor(Color(.systemGray)).font(.headline.weight(.medium))
                    TextField("Select a module label here...", text: $moduleLabel)
                        .padding(.horizontal)
                        .frame(height:50)
                        .background(Color(.systemFill))
                        .cornerRadius(CGFloat(15.0))
                        .multilineTextAlignment(.center)
                }.frame(maxWidth: .infinity)
                
                HStack {
                    Text("Status: ").foregroundColor(Color(.systemGray)).font(.headline.weight(.medium))
                    Picker(selection: $status, label:EmptyView()) {
                        ForEach(0...2, id: \.self) {
                            Text(util.status2str(status: $0)).tag(String($0)) // tag and
                        }
                    }
                    .padding(.horizontal)
                    .frame(height:50)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemFill))
                    .cornerRadius(CGFloat(15.0))
                }.frame(maxWidth: .infinity)
            

                VStack{
                    DatePicker(selection: $ddlDate, in: Date()..., displayedComponents: [.date, .hourAndMinute]) {
                                   Text("Due Date").font(.headline.weight(.medium)).foregroundColor(Color(.systemGray))
                                    
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                

                HStack{
                    // button for image selection
                    Button(action: {
                        print("Image selection")
                        self.isShowPhotoLibrary = true
                    }) {
                        Text("Select Image")
                    }
                        .padding(.horizontal)
                        .frame(height:50)
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemFill))
                        .cornerRadius(CGFloat(15.0))
                        
                    // button for file selection
                    Button(action: {
                        fileIsImporting.toggle()
                        print("File selection")
                    }) {
                        Text(fileName == "" ? "Select File" : fileName )
                    }
                        .padding(.horizontal)
                        .frame(height:50)
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemFill))
                        .cornerRadius(CGFloat(15.0))
                        .fileImporter(isPresented: $fileIsImporting, allowedContentTypes: [.item], allowsMultipleSelection: false) { (result) in
                            do {
                                let fileURL = try result.get()
                                self.filePath = fileURL.first!.absoluteString
                                self.fileName = fileURL.first!.lastPathComponent // unwrap safe since try catch
                            } catch {
                                print("File selection Fail")
                                print(error)
                            }
                        }
                }
                
                // select color
                VStack {
                    ColorPicker("Color", selection: $chosenColor)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal)
                .frame(height:50)
                .background(Color(.systemFill))
                .cornerRadius(CGFloat(15.0))
                
                Button(action: {
                    if(titleField != ""){
                        let task = Task(titleField, desField, self.filePath, Date(), ddlDate, Int(priority), Int(status), String(moduleLabel), nil, util.color2hex(color: UIColor(chosenColor)))

                        // if image is selected, add image to task
                        task.img = $image.wrappedValue
                        
                        taskdata.tasks.append(task)
                        util.inertDB(task: task)
                        presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Text("Add")
                        .foregroundColor(Color(.white))
                        .frame(height:50)
                        .frame(maxWidth:.infinity)
                        .background(.blue)
                        .cornerRadius(CGFloat(15.0))
                })
            }
            .padding(10)
            .sheet(isPresented: $isShowPhotoLibrary) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
            }
        }.navigationTitle("Add a Task!")
    }
}

//struct AddView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            AddView( taskdata: TaskData())
//
//        }
//    }
//}
