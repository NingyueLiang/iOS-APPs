//
//  EditView.swift
//  tdlpp-swiftui
//
//  Created by Yubo Wang on 11/30/22.
//

import SwiftUI
import Combine
import UIKit


struct EditView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var taskdata: TaskData
    @EnvironmentObject var task: Task
    @State var titleField: String = ""
    @State var desField: String = ""
    @State var priority: String = ""
    @State var moduleLabel: String = ""
    @State var status: String = ""
    @State var ddlDate = Date()
    @State private var chosenColor = Color.orange
    
    // for file upload use
    @State var fileIsImporting:Bool = false
    @State var filePath: String = ""
    @State var fileName: String = "" // for dsiplay use
    
    
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()
    
    init(task: Task) {
        _titleField = State(initialValue: task.title)
        _desField = State(initialValue: task.desc ?? "")
        _priority = State(initialValue: "\(String(describing: task.priority))")
        _status = State(initialValue: "\(String(describing: task.status))")
        _moduleLabel = State(initialValue: "\(String(describing: task.moduleLabel))")
        _filePath = State(initialValue: "\(String(describing: task.file_))")
        _ddlDate = State(initialValue: task.ddlDate ?? Date())
        _chosenColor = State(initialValue: Color(uiColor: util.hex2color(hexString: task.color)))
        _image = State(initialValue: task.img ?? UIImage())
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

                .foregroundColor(Color(white:0.7))
                .padding(.horizontal)
                .frame(height:50)
                .background(Color(.systemFill))
                .cornerRadius(CGFloat(15.0))
                
                Button(action: {
                    if(titleField != ""){
                        presentationMode.wrappedValue.dismiss()
                        task.title = titleField
                    }
                    task.priority = Int(priority) ?? 5
                    task.moduleLabel = String(moduleLabel)
                    if self.filePath != Optional("") {
                        task.file_ = self.filePath
                    }
                    task.desc = desField
                    task.status = Int(status)!
                    task.ddlDate = ddlDate
                    task.color = util.color2hex(color: UIColor(chosenColor))
                    
                    task.img = $image.wrappedValue
                    
                    util.delete(id: task.id)
                    util.inertDB(task: task)
                    // taskdata.tasks = util.loadAll()
                    self.task.objectWillChange.send()
                }, label: {
                    Text("Save")
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
            
        }.navigationTitle("Edit a Task!")
    }
}
