import SwiftUI

struct Task: Identifiable {
    let id = UUID()
    var name: String
    var isCompleted: Bool = false
}

struct SubmitOnReturnTextField: View {
    let placeholder: String
    @Binding var text: String
    var onCommit: () -> Void
    
    var body: some View {
        TextField(placeholder, text: $text, onCommit: onCommit)
            .textFieldStyle(PlainTextFieldStyle()) 
    }
}

struct ContentView: View {
    @State private var tasks: [Task] = []
    @State private var newTask = ""
    @State private var showingTextField = false 
    
    var body: some View {
        VStack {
            Image(systemName: "pin")
                .imageScale(.large)
                .foregroundColor(.blue)
            
            Text("To do list")
                .foregroundColor(.green)
            
            List {
                ForEach(tasks.indices, id: \.self) { index in
                    Toggle(isOn: $tasks[index].isCompleted) {
                        Text(tasks[index].name)
                    }
                }
            }
            
            ProgressView(value: completionPercentage())
            
            HStack {
                Button(action: {
                    tasks.indices.forEach { index in
                        tasks[index].isCompleted = false
                    }
                }) {
                    Text("Mark all tasks uncompleted")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                
                Button("Add new task") {
                    if !showingTextField { 
                        showingTextField = true
                    } else if !newTask.isEmpty {
                        tasks.append(Task(name: newTask))
                        newTask = ""
                        showingTextField = false 
                    }
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.green)
                .cornerRadius(8)
            }
            
            if showingTextField { 
                SubmitOnReturnTextField(placeholder: "New Task", text: $newTask) {
                    if !newTask.isEmpty {
                        tasks.append(Task(name: newTask))
                        newTask = ""
                        showingTextField = false 
                    }
                }
                .padding()
            }
        }
        .padding()
    }
    
    private func completionPercentage() -> Double {
        guard !tasks.isEmpty else {
            return 0.0
        }
        let completedTasks = tasks.filter { $0.isCompleted }.count
        return Double(completedTasks) / Double(tasks.count)
    }
}

