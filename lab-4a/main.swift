
import SwiftUI
import Combine

// MARK: - MODEL

struct TodoTask: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool = false
}

enum TaskFilter: String, CaseIterable {
    case all = "All"
    case active = "Active"
    case completed = "Completed"
}

// MARK: - MVC CONTROLLER

class TaskViewController: ObservableObject {

    @Published var tasks: [TodoTask] = []

    func addTask(_ title: String) {
        let name = title.trimmingCharacters(in: .whitespaces)

        guard !name.isEmpty else { return }

        tasks.append(TodoTask(title: name))
    }

    func toggleTask(_ task: TodoTask) {
        guard let index = tasks.firstIndex(where: {
            $0.id == task.id
        }) else { return }

        tasks[index].isCompleted.toggle()
    }

    func deleteTask(_ task: TodoTask) {
        tasks.removeAll { $0.id == task.id }
    }

    func filteredTasks(_ filter: TaskFilter) -> [TodoTask] {
        switch filter {
        case .all:
            return tasks
        case .active:
            return tasks.filter { !$0.isCompleted }
        case .completed:
            return tasks.filter { $0.isCompleted }
        }
    }
}

// MARK: - MVC VIEW

struct MVCView: View {

    @StateObject private var controller = TaskViewController()
    @State private var input = ""
    @State private var filter: TaskFilter = .all

    var body: some View {
        VStack(spacing: 15) {

            Text("MVC Task Manager")
                .font(.largeTitle.bold())

            HStack {
                TextField("Enter task", text: $input)
                    .textFieldStyle(.roundedBorder)

                Button("Add") {
                    controller.addTask(input)
                    input = ""
                }
                .buttonStyle(.borderedProminent)
            }

            Picker("Filter", selection: $filter) {
                ForEach(TaskFilter.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.segmented)

            List {
                ForEach(controller.filteredTasks(filter)) { task in
                    HStack {
                        Button {
                            controller.toggleTask(task)
                        } label: {
                            Image(systemName:
                                task.isCompleted
                                ? "checkmark.circle.fill"
                                : "circle"
                            )
                        }

                        Text(task.title)
                            .strikethrough(task.isCompleted)
                    }
                }
                .onDelete { offsets in
                    let visibleTasks =
                        controller.filteredTasks(filter)

                    for index in offsets {
                        controller.deleteTask(visibleTasks[index])
                    }
                }
            }
        }
        .padding()
    }
}

// MARK: - MVVM VIEW MODEL

class TaskViewModel: ObservableObject {

    @Published private(set) var tasks: [TodoTask] = []

    @Published var filter: TaskFilter = .all

    var filteredTasks: [TodoTask] {
        switch filter {
        case .all:
            return tasks
        case .active:
            return tasks.filter { !$0.isCompleted }
        case .completed:
            return tasks.filter { $0.isCompleted }
        }
    }

    func addTask(_ title: String) {
        let name = title.trimmingCharacters(in: .whitespaces)

        guard !name.isEmpty else { return }

        tasks.append(TodoTask(title: name))
    }

    func toggleTask(_ id: UUID) {
        guard let index = tasks.firstIndex(where: {
            $0.id == id
        }) else { return }

        tasks[index].isCompleted.toggle()
    }

    func deleteTask(_ id: UUID) {
        tasks.removeAll { $0.id == id }
    }
}

// MARK: - MVVM VIEW

struct MVVMView: View {

    @StateObject private var viewModel = TaskViewModel()
    @State private var input = ""

    var body: some View {
        VStack(spacing: 15) {

            Text("MVVM Task Manager")
                .font(.largeTitle.bold())

            HStack {
                TextField("Enter task", text: $input)
                    .textFieldStyle(.roundedBorder)

                Button("Add") {
                    viewModel.addTask(input)
                    input = ""
                }
                .buttonStyle(.borderedProminent)
            }

            Picker("Filter", selection: $viewModel.filter) {
                ForEach(TaskFilter.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.segmented)

            List {
                ForEach(viewModel.filteredTasks) { task in
                    HStack {
                        Button {
                            viewModel.toggleTask(task.id)
                        } label: {
                            Image(systemName:
                                task.isCompleted
                                ? "checkmark.circle.fill"
                                : "circle"
                            )
                        }

                        Text(task.title)
                            .strikethrough(task.isCompleted)
                    }
                }
                .onDelete { offsets in
                    let visibleTasks = viewModel.filteredTasks

                    for index in offsets {
                        viewModel.deleteTask(visibleTasks[index].id)
                    }
                }
            }
        }
        .padding()
    }
}

// MARK: - MAIN APP

struct ContentView: View {

    @State private var selected = "MVVM"

    var body: some View {
        VStack {
            Picker("Architecture", selection: $selected) {
                Text("MVC").tag("MVC")
                Text("MVVM").tag("MVVM")
            }
            .pickerStyle(.segmented)
            .padding()

            if selected == "MVC" {
                MVCView()
            } else {
                MVVMView()
            }
        }
    }
}

@main
struct Lab4AApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
