//
//  ContentView.swift
//  RealmCrudExample
//
//  Created by cano on 2023/01/09.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    
    // MARK: Read Data
    // Sorting By Date
    @ObservedResults(TaskItem.self, sortDescriptor: SortDescriptor.init(keyPath: "taskDate", ascending: false)) var tasksFetched
    
    // Opening keyboard for Newly added Task
    @State var lastAddedTaskID: String = ""
    
    var body: some View {
        NavigationView{
            
            ZStack{
                
                if tasksFetched.isEmpty{
                    
                    Text("Add some new Tasks!")
                        .font(.title3)
                        .foregroundColor(.gray)
                    
                }else {
                    
                    List{
                        ForEach(tasksFetched) { task in
                            
                            TaskRow(task: task,lastAddedTaskID: $lastAddedTaskID)
                            
                            // MARK: Delete Data
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                
                                Button(role: .destructive) {
                                    $tasksFetched.remove(task)
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                            
                        }
                    }
                    .listStyle(.insetGrouped)
                    .animation(.easeInOut, value: tasksFetched)
                }
            }
            .navigationTitle("Task's")
            .toolbar {
                
                Button {
                    
                    // MARK: Create Task
                    let task = TaskItem()
                    lastAddedTaskID = task.id.stringValue
                    $tasksFetched.append(task)
                    
                } label: {
                    Image(systemName: "plus")
                }
                
            }
            // MARK: Observing Keyboard
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                
                lastAddedTaskID = ""
                guard let last = tasksFetched.last else {
                    return
                }
                
                if last.taskTitle == "" {
                    // Removing task
                    $tasksFetched.remove(last)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
