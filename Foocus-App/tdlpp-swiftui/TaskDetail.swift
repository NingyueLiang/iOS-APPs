//
//  TaskList.swift
//  tdlpp-swiftui
//
//  Created by Ryan Chen on 11/15/22.
//

import SwiftUI
import UniformTypeIdentifiers
import Dispatch

struct TaskDetail: View {
    @Environment(\.refresh) private var refresh
    @ObservedObject var task: Task
    @State var needRefresh = false
    @State var fileIsExporting: Bool = false
    @State private var showPreview = false
    @State var showFile: Bool = false
    
    var body: some View {
        ZStack {
            Color(uiColor: util.hex2color(hexString: task.color)).opacity(0.3).ignoresSafeArea()
        ScrollView {
            
                
            VStack(alignment: .leading) {
              
                Section(header: Text("Task Status:").font(.title2.weight(.semibold)).foregroundColor(Color(uiColor: util.hex2color(hexString: task.color)))){
                    VStack {
                    
                        HStack {
                            Text("Label:").font(.headline.weight(.semibold)).foregroundColor(Color(uiColor: util.hex2color(hexString: task.color))).frame(height:50)
                                .frame(maxWidth: 80)
                            Text(task.moduleLabel)
                                .padding(.horizontal)
                                .frame(height:50)
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemBackground))
                                .cornerRadius(.infinity)
                        }
                        
                        HStack {
                            Text("Status:").font(.headline.weight(.semibold)).foregroundColor(Color(uiColor: util.hex2color(hexString: task.color))).frame(height:50)
                                .frame(maxWidth: 80)
                            Text(util.status2str(status: task.status))
                                .padding(.horizontal)
                                .frame(height:50)
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemBackground))
                                .cornerRadius(.infinity)
                        }
                        
                        HStack {
                            Text("Priority:").font(.headline.weight(.semibold)).foregroundColor(Color(uiColor: util.hex2color(hexString: task.color))).frame(height:50)
                                .frame(maxWidth: 80)
                            Text(util.priority2str(priority: task.priority))
                                .padding(.horizontal)
                                .frame(height:50)
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemBackground))
                                .cornerRadius(.infinity)
                        }
                       
                    }
                
                }
                
                
                Section(header: Text("Date:").font(.title2.weight(.semibold)).foregroundColor(Color(uiColor: util.hex2color(hexString: task.color)))){
                    HStack {
                        Text("Created:").font(.headline.weight(.semibold)).foregroundColor(Color(uiColor: util.hex2color(hexString: task.color))).frame(height:50)
                            .frame(maxWidth: 100)
                        Text(util.formatDate(task.createDate))
                            .padding(.horizontal)
                            .frame(height:50)
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemBackground))
                            .cornerRadius(.infinity)
                    }
                    if task.ddlDate != nil {
                        HStack {
                            Text("Due On:").font(.headline.weight(.semibold)).foregroundColor(Color(uiColor: util.hex2color(hexString: task.color))).frame(height:50)
                                .frame(maxWidth: 100)
                            Text(util.formatDate(task.ddlDate!))
                                .padding(.horizontal)
                                .frame(height:50)
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemBackground))
                                .cornerRadius(.infinity)
                        }
            
                    }
                }
                if task.desc != nil && task.desc != "" {
                    Section(header: Text("Description:").font(.title2.weight(.semibold)).foregroundColor(Color(uiColor: util.hex2color(hexString: task.color)))){
                            Text(task.desc!)
                                .padding(.horizontal)
                                .frame(height:50)
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemBackground))
                                .cornerRadius(15)
                        
                        
                    }
                }
                
                if task.img != nil && task.img != UIImage() {
                    Section(header: Text("Image:").font(.title2.weight(.semibold)).foregroundColor(Color(uiColor: util.hex2color(hexString: task.color)))){

                        Image(uiImage: task.img!)
                            .resizable()
                            .scaledToFit()
                    }
                }
                if task.file_ != "" && URL(string:task.file_) != nil {
                    ExecuteCode{
                        if URL(string: task.file_)!.startAccessingSecurityScopedResource(){
                            if FileManager.default.fileExists(atPath: URL(string:task.file_)!.path){
                                DispatchQueue.main.async { self.showFile = true }
                            }
                            else{
                                DispatchQueue.main.async { self.showFile = false }
                            }
                        }
    //                    URL(string: task.file_)!.stopAccessingSecurityScopedResource() if add this line it won't work
                    }
                }
                
                
                if task.file_ != "" && URL(string:task.file_) != nil && showFile{
                    Section(header: Text("File:").font(.title2.weight(.semibold)).foregroundColor(Color(uiColor: util.hex2color(hexString: task.color)))){
                        
                        Button("Preview File: \(URL(string:task.file_)!.lastPathComponent)") {
                            
                                    self.showPreview = true
                                }
                                .sheet(isPresented: $showPreview) {
                                    VStack(spacing: 0) {
                                        HStack {
                                            Button("Done") {
                                                self.showPreview = false
                                            }
                                            Spacer()
                                        }
                                        .padding()

                                        PreviewController(url: URL(string:task.file_)!)
                                    }
                                }.padding(.horizontal)
                            .frame(height:50)
                            .frame(maxWidth: .infinity)
                            .background(Color(white:0.95))
                            .cornerRadius(CGFloat(15.0))
                        

                    Button(action: {
                           fileIsExporting.toggle()
                           print("Image export")
                       }) {
                           if URL(string:task.file_) != nil {
                               Text("Export File: \(URL(string:task.file_)!.lastPathComponent)")
                           }else{
                               Text("No File Assigned")
                           }
                           
                       }
                           .padding(.horizontal)
                           .frame(height:50)
                           .frame(maxWidth: .infinity)
                           .background(Color(white:0.95))
                           .cornerRadius(CGFloat(15.0))
                           .fileExporter(isPresented: $fileIsExporting, document: Doc(url: task.file_), contentType: UTType.item) {
                               result in switch result{
                                   case .success(let url):
                                       print("Saved to \(url)")
                                   case .failure(let error):
                                       print(error.localizedDescription)
                                   }
                               }
                    }
                }
            }
            .padding()
        }
        }
        .navigationTitle(task.title.capitalizingFirstLetter())
        .navigationBarItems(
            trailing: NavigationLink(
                "Edit",
                destination: EditView(task: task).environmentObject(task)
            )
        )
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
