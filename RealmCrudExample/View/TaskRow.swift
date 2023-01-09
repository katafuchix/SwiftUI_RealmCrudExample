//
//  TaskRow.swift
//  RealmCrudExample
//
//  Created by cano on 2023/01/09.
//

import SwiftUI
import RealmSwift

struct TaskRow: View {
    @ObservedRealmObject var task: TaskItem
    
    @Binding var lastAddedTaskID: String
    
    // MARK: Keyboard Focus
    @FocusState var showKeyboard: Bool
    
    var body: some View{
        
        HStack(spacing: 15){
            
            // MARK: Task Status Indicator Menu
            Menu {
                
                // MARK: Update Data
                Button("Missed"){
                    $task.taskStatus.wrappedValue = .missed
                }
                Button("Completed"){
                    $task.taskStatus.wrappedValue = .completed
                }
                
            } label: {
             
                Circle()
                    .stroke(.gray)
                    .frame(width: 15, height: 15)
                    .overlay(
                    
                        Circle()
                            .fill(task.taskStatus == .missed ? .red : (task.taskStatus == .pending ? .yellow : .green))
                    )
            }
            
            VStack(alignment: .leading, spacing: 12) {
                
                // MARK: Task Title
                TextField("Task Title", text: $task.taskTitle)
                    .focused($showKeyboard)
                
                // MARK: Task Date
                if task.taskTitle != ""{
                    Picker(selection: .constant("")) {
                        
                        DatePicker(selection: $task.taskDate, displayedComponents: .date) {
                            
                        }
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .navigationTitle("Task Date")
                        
                    } label: {
                        
                        HStack{
                            Image(systemName: "calendar")
                            Text(task.taskDate.formatted(date: .abbreviated, time: .omitted))
                        }
                        
                    }

                }
            }
        }
        .onAppear {
            if lastAddedTaskID == task.id.stringValue{
                showKeyboard.toggle()
            }
        }
    }
}
