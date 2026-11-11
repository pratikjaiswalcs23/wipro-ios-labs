
import SwiftUI
import Foundation

// MARK: - MODEL

struct DirectoryUser: Codable, Identifiable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String
    let website: String
    let address: Address
    let company: Company

    struct Address: Codable {
        let street: String
        let city: String
    }

    struct Company: Codable {
        let name: String
    }
}

// MARK: - API ERRORS

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError
    case emptyResults
    case networkError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API URL."
        case .invalidResponse:
            return "Invalid server response."
        case .httpError(let code):
            return "HTTP Error: \(code)"
        case .decodingError:
            return "Unable to decode JSON data."
        case .emptyResults:
            return "No users found."
        case .networkError:
            return "Network connection failed."
        }
    }
}

// MARK: - API SERVICE

struct DirectoryAPIService {

    func fetchUsers() async throws -> [DirectoryUser] {

        guard let components = URLComponents(
            string: "https://jsonplaceholder.typicode.com/users"
        ),
        components.scheme == "https",
        components.host != nil,
        let url = components.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 20
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Accept"
        )

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.httpError(httpResponse.statusCode)
            }

            let users: [DirectoryUser]

            do {
                users = try JSONDecoder().decode(
                    [DirectoryUser].self,
                    from: data
                )
            } catch {
                throw APIError.decodingError
            }

            guard !users.isEmpty else {
                throw APIError.emptyResults
            }

            return users

        } catch let error as APIError {
            throw error
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            throw APIError.networkError
        }
    }
}

// MARK: - VIEW MODEL

@MainActor
class DirectoryViewModel: ObservableObject {

    @Published var users: [DirectoryUser] = []
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var hasLoaded = false

    private let service = DirectoryAPIService()
    private var loadingTask: Task<Void, Never>?

    var filteredUsers: [DirectoryUser] {
        if searchText.isEmpty {
            return users
        }

        return users.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.email.localizedCaseInsensitiveContains(searchText) ||
            $0.username.localizedCaseInsensitiveContains(searchText)
        }
    }

    func fetchUsers() {
        loadingTask?.cancel()

        isLoading = true
        errorMessage = nil
        hasLoaded = false

        loadingTask = Task {
            do {
                let result = try await service.fetchUsers()
                try Task.checkCancellation()

                users = result
                hasLoaded = true

            } catch is CancellationError {
                errorMessage = "Request cancelled."

            } catch {
                users = []
                errorMessage =
                    (error as? LocalizedError)?.errorDescription
                    ?? error.localizedDescription
            }

            isLoading = false
        }
    }

    func cancelRequest() {
        loadingTask?.cancel()
        loadingTask = nil
        isLoading = false
        errorMessage = "Request cancelled."
    }
}

// MARK: - MAIN VIEW

struct ContentView: View {

    @StateObject private var viewModel = DirectoryViewModel()

    var body: some View {

        NavigationStack {

            VStack(spacing: 15) {

                TextField("Search users...", text: $viewModel.searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                if viewModel.isLoading {

                    VStack(spacing: 15) {
                        ProgressView("Fetching users...")
                        Button("Cancel Request") {
                            viewModel.cancelRequest()
                        }
                        .tint(.red)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                } else if let error = viewModel.errorMessage {

                    VStack(spacing: 15) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 45))
                            .foregroundColor(.red)

                        Text("Something went wrong")
                            .font(.title2)
                            .bold()

                        Text(error)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)

                        Button("Try Again") {
                            viewModel.fetchUsers()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                } else if viewModel.hasLoaded {

                    if viewModel.filteredUsers.isEmpty {

                        ContentUnavailableView.search(
                            text: viewModel.searchText
                        )

                    } else {

                        List(viewModel.filteredUsers) { user in

                            NavigationLink {
                                UserDetailView(user: user)
                            } label: {

                                HStack(spacing: 15) {

                                    Image(systemName: "person.circle.fill")
                                        .font(.system(size: 42))
                                        .foregroundColor(.blue)

                                    VStack(alignment: .leading, spacing: 5) {

                                        Text(user.name)
                                            .font(.headline)

                                        Text(user.email)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)

                                        Text("@\(user.username)")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(.vertical, 5)
                            }
                        }
                    }

                } else {

                    VStack(spacing: 15) {
                        Image(systemName: "person.3.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.blue)

                        Text("User Directory")
                            .font(.title2)
                            .bold()

                        Button("Load Users") {
                            viewModel.fetchUsers()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("User Directory")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.fetchUsers()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .task {
                if !viewModel.hasLoaded &&
                    viewModel.errorMessage == nil {
                    viewModel.fetchUsers()
                }
            }
        }
    }
}

// MARK: - DETAIL VIEW

struct UserDetailView: View {

    let user: DirectoryUser

    var body: some View {

        Form {

            Section("Personal Information") {
                LabeledContent("Name", value: user.name)
                LabeledContent("Username", value: user.username)
                LabeledContent("Email", value: user.email)
            }

            Section("Contact Information") {
                LabeledContent("Phone", value: user.phone)
                LabeledContent("Website", value: user.website)
            }

            Section("Address") {
                LabeledContent("Street", value: user.address.street)
                LabeledContent("City", value: user.address.city)
            }

            Section("Company") {
                LabeledContent("Company", value: user.company.name)
            }
        }
        .navigationTitle("User Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - APP ENTRY POINT

@main
struct Lab6App: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
