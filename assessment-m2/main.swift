
import SwiftUI
import Combine

// MARK: - MODEL

struct TaskItem: Identifiable, Equatable, Sendable {
    let id: Int
    var title: String
    var isCompleted: Bool
}

struct UserInfo: Sendable {
    let name: String
    let email: String
}

// MARK: - SERVICE

protocol TaskService: Sendable {
    func fetchTasks() async throws -> [TaskItem]
    func fetchUser() async throws -> UserInfo
}

struct MockTaskService: TaskService {

    func fetchTasks() async throws -> [TaskItem] {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        try Task.checkCancellation()

        return [
            TaskItem(id: 1, title: "Learn Swift", isCompleted: false),
            TaskItem(id: 2, title: "Practice MVVM", isCompleted: true),
            TaskItem(id: 3, title: "Learn Concurrency", isCompleted: false),
            TaskItem(id: 4, title: "Complete Assessment 2", isCompleted: false)
        ]
    }

    func fetchUser() async throws -> UserInfo {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        try Task.checkCancellation()

        return UserInfo(
            name: "Pratik Jaiswal",
            email: "pratik@example.com"
        )
    }
}

// MARK: - SCREEN STATES

enum ScreenState {
    case idle
    case loading
    case success
    case error(String)
    case cancelled
}

// MARK: - VIEW MODEL

@MainActor
final class TaskViewModel: ObservableObject {

    @Published var tasks: [TaskItem] = []
    @Published var user: UserInfo?
    @Published var state: ScreenState = .idle

    private let service: any TaskService
    private var loadingTask: Task<Void, Never>?

    init(service: any TaskService = MockTaskService()) {
        self.service = service
    }

    // Fetch independent data sources concurrently
    func loadData() {
        loadingTask?.cancel()

        tasks = []
        user = nil
        state = .loading

        loadingTask = Task {
            do {
                async let taskData = service.fetchTasks()
                async let userData = service.fetchUser()

                let (loadedTasks, loadedUser) =
                    try await (taskData, userData)

                try Task.checkCancellation()

                tasks = loadedTasks
                user = loadedUser
                state = .success

            } catch is CancellationError {
                state = .cancelled

            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }

    // Cancel loading
    func cancelLoading() {
        loadingTask?.cancel()
        loadingTask = nil
        state = .cancelled
    }

    // Add task
    func addTask(title: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespaces)

        guard !trimmedTitle.isEmpty else {
            return
        }

        let newID = (tasks.map { $0.id }.max() ?? 0) + 1

        tasks.append(
            TaskItem(
                id: newID,
                title: trimmedTitle,
                isCompleted: false
            )
        )
    }

    // Complete or uncomplete task
    func toggleTask(id: Int) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else {
            return
        }

        tasks[index].isCompleted.toggle()
    }

    // Delete task
    func deleteTask(id: Int) {
        tasks.removeAll { $0.id == id }
    }

    // Reset
    func reset() {
        loadingTask?.cancel()
        loadingTask = nil
        tasks = []
        user = nil
        state = .idle
    }
}

// MARK: - MAIN VIEW

struct ContentView: View {

    @StateObject private var viewModel = TaskViewModel()
    @State private var newTask = ""

    var body: some View {

        NavigationView {

            VStack(spacing: 18) {

                Text("Assessment 2")
                    .font(.largeTitle)
                    .bold()

                Text("MVVM Architecture & Concurrency")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                // USER INFORMATION

                if let user = viewModel.user {

                    VStack(alignment: .leading, spacing: 8) {

                        Text("User Information")
                            .font(.headline)

                        Text("Name: \(user.name)")
                        Text("Email: \(user.email)")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                }

                // LOADING / SUCCESS / ERROR / CANCELLED

                Group {

                    switch viewModel.state {

                    case .idle:
                        Text("Press Load Data to start")

                    case .loading:
                        ProgressView("Fetching data...")
                            .tint(.blue)

                    case .success:
                        Text("Data loaded successfully!")
                            .foregroundColor(.green)
                            .bold()

                    case .error(let message):
                        Text("Error: \(message)")
                            .foregroundColor(.red)

                    case .cancelled:
                        Text("Loading cancelled")
                            .foregroundColor(.orange)
                    }
                }
                .frame(minHeight: 45)

                // LOAD BUTTON

                Button {
                    viewModel.loadData()
                } label: {
                    Label("Load Data", systemImage: "arrow.down.circle")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(isLoading)

                // CANCEL BUTTON

                if isLoading {

                    Button {
                        viewModel.cancelLoading()
                    } label: {
                        Label("Cancel Loading", systemImage: "xmark.circle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }

                // ADD TASK

                HStack {

                    TextField("Enter a new task", text: $newTask)
                        .textFieldStyle(.roundedBorder)

                    Button("Add") {
                        viewModel.addTask(title: newTask)
                        newTask = ""
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(newTask.trimmingCharacters(in: .whitespaces).isEmpty)
                }

                // TASK LIST

                List {

                    ForEach(viewModel.tasks) { task in

                        HStack {

                            Button {
                                viewModel.toggleTask(id: task.id)
                            } label: {
                                Image(
                                    systemName: task.isCompleted
                                    ? "checkmark.circle.fill"
                                    : "circle"
                                )
                                .foregroundColor(
                                    task.isCompleted ? .green : .gray
                                )
                            }

                            Text(task.title)
                                .strikethrough(task.isCompleted)

                            Spacer()

                            Button(role: .destructive) {
                                viewModel.deleteTask(id: task.id)
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                }

                // RESET BUTTON

                Button("Reset All") {
                    viewModel.reset()
                }
                .buttonStyle(.bordered)
                .disabled(isLoading)
            }
            .padding()
            .navigationTitle("Task Manager")
        }
    }

    private var isLoading: Bool {
        if case .loading = viewModel.state {
            return true
        }
        return false
    }
}

// MARK: - APP ENTRY POINT

@main
struct Assessment2App: App {

    var body: some Scene {

        WindowGroup {
            ContentView()
        }
    }
}
