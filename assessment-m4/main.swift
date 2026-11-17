
import SwiftUI
import Observation

// MARK: - Course Model
struct Course: Identifiable, Hashable {
    let id: Int
    let name: String
    let category: String
    let duration: String
    let description: String
}

// MARK: - Sample Courses
let sampleCourses = [
    Course(
        id: 1,
        name: "SwiftUI Development",
        category: "iOS Development",
        duration: "6 Weeks",
        description: "Learn SwiftUI, navigation, state management and build modern iOS applications."
    ),
    Course(
        id: 2,
        name: "Python Programming",
        category: "Programming",
        duration: "4 Weeks",
        description: "Learn Python fundamentals, functions, loops and object-oriented programming."
    ),
    Course(
        id: 3,
        name: "Data Structures",
        category: "Computer Science",
        duration: "8 Weeks",
        description: "Understand arrays, linked lists, stacks, queues and algorithms."
    ),
    Course(
        id: 4,
        name: "Web Development",
        category: "Web Development",
        duration: "5 Weeks",
        description: "Learn HTML, CSS and JavaScript to create responsive websites."
    )
]

// MARK: - Observable Shared Store
@Observable
class CourseStore {
    var favourites: Set<Int> = []

    func toggleFavourite(_ id: Int) {
        if favourites.contains(id) {
            favourites.remove(id)
        } else {
            favourites.insert(id)
        }
    }

    func isFavourite(_ id: Int) -> Bool {
        favourites.contains(id)
    }
}

// MARK: - App Entry Point
// Use the existing @main App entry point in your project.

// MARK: - Main Content View
struct ContentView: View {

    @State private var store = CourseStore()
    @State private var searchText = ""
    @State private var showFavourites = false

    var filteredCourses: [Course] {
        sampleCourses.filter { course in

            let matchesSearch = searchText.isEmpty ||
                course.name.localizedCaseInsensitiveContains(searchText) ||
                course.category.localizedCaseInsensitiveContains(searchText)

            let matchesFavourite = !showFavourites ||
                store.isFavourite(course.id)

            return matchesSearch && matchesFavourite
        }
    }

    var body: some View {
        TabView {

            NavigationStack {
                VStack(spacing: 12) {

                    // Search
                    TextField("Search courses...", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)

                    // Favourite Filter
                    Toggle("Show Favourites Only", isOn: $showFavourites)
                        .padding(.horizontal)

                    // Course List
                    if filteredCourses.isEmpty {
                        ContentUnavailableView(
                            "No Courses Found",
                            systemImage: "book",
                            description: Text("Try another search.")
                        )
                    } else {
                        List(filteredCourses) { course in
                            NavigationLink {
                                CourseDetailView(
                                    course: course,
                                    store: store
                                )
                            } label: {
                                CourseRow(
                                    course: course,
                                    store: store
                                )
                            }
                        }
                        .listStyle(.insetGrouped)
                    }
                }
                .navigationTitle("Course Explorer")
            }
            .tabItem {
                Label("Courses", systemImage: "book")
            }

            NavigationStack {
                RegistrationView()
            }
            .tabItem {
                Label("Register", systemImage: "person.crop.circle.badge.plus")
            }
        }
        .tint(.blue)
    }
}

// MARK: - Reusable Course Row
struct CourseRow: View {

    let course: Course
    var store: CourseStore

    var body: some View {
        HStack(spacing: 12) {

            Image(systemName: "book.fill")
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 45, height: 45)
                .background(Color.blue.opacity(0.12))
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 5) {
                Text(course.name)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(course.category)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(course.duration)
                    .font(.caption2)
                    .foregroundColor(.blue)
            }

            Spacer()

            Button {
                store.toggleFavourite(course.id)
            } label: {
                Image(systemName:
                    store.isFavourite(course.id)
                    ? "heart.fill" : "heart"
                )
                .foregroundColor(.red)
                .font(.title2)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 5)
    }
}

// MARK: - Course Detail View
struct CourseDetailView: View {

    let course: Course
    var store: CourseStore

    var body: some View {
        VStack(spacing: 20) {

            Image(systemName: "book.closed.fill")
                .font(.system(size: 65))
                .foregroundColor(.blue)
                .padding(25)
                .background(Color.blue.opacity(0.12))
                .cornerRadius(20)

            Text(course.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text(course.category)
                .font(.headline)
                .foregroundColor(.blue)

            Text(course.duration)
                .foregroundColor(.secondary)

            Text(course.description)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)

            // Favourite Button
            Button {
                store.toggleFavourite(course.id)
            } label: {
                Label(
                    store.isFavourite(course.id)
                    ? "Remove Favourite" : "Add to Favourites",
                    systemImage: store.isFavourite(course.id)
                    ? "heart.fill" : "heart"
                )
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.12))
                .foregroundColor(.red)
                .cornerRadius(12)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Course Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Registration View
struct RegistrationView: View {

    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var selectedEvent = "SwiftUI Workshop"
    @State private var acceptedTerms = false

    @State private var isLoading = false
    @State private var showSuccess = false
    @State private var errorMessage = ""

    let events = [
        "SwiftUI Workshop",
        "Coding Competition",
        "Technical Seminar",
        "Hackathon"
    ]

    var isValidEmail: Bool {
        let parts = email.split(separator: "@")
        return parts.count == 2 &&
            parts[1].contains(".") &&
            !email.contains(" ")
    }

    var isValidPhone: Bool {
        phone.count == 10 &&
            phone.allSatisfy { $0.isNumber }
    }

    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        isValidEmail &&
        isValidPhone &&
        acceptedTerms
    }

    var body: some View {
        Form {

            Section("Personal Information") {

                TextField("Full Name", text: $name)
                    .textContentType(.name)

                TextField("Email Address", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                TextField("Phone Number", text: $phone)
                    .keyboardType(.numberPad)

                if !email.isEmpty && !isValidEmail {
                    Text("Enter a valid email address.")
                        .font(.caption)
                        .foregroundColor(.red)
                }

                if !phone.isEmpty && !isValidPhone {
                    Text("Enter a valid 10-digit phone number.")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }

            Section("Event Selection") {

                Picker("Select Event", selection: $selectedEvent) {
                    ForEach(events, id: \.self) { event in
                        Text(event)
                    }
                }

                Toggle("Accept Terms and Conditions",
                       isOn: $acceptedTerms)
            }

            Section {

                Button {
                    submitRegistration()
                } label: {
                    HStack {
                        Spacer()

                        if isLoading {
                            ProgressView()
                        } else {
                            Text("Submit Registration")
                                .fontWeight(.bold)
                        }

                        Spacer()
                    }
                }
                .disabled(!isFormValid || isLoading)
            }

            if !errorMessage.isEmpty {
                Section("Error") {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
        }
        .navigationTitle("Event Registration")
        .alert("Registration Successful!",
               isPresented: $showSuccess) {
            Button("OK", role: .cancel) {
                resetForm()
            }
        } message: {
            Text("Your registration has been completed successfully.")
        }
    }

    // MARK: - Submit
    func submitRegistration() {

        guard isFormValid else {
            errorMessage = "Please complete all fields correctly."
            return
        }

        isLoading = true
        errorMessage = ""

        // Simulated registration process
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            showSuccess = true
        }
    }

    // MARK: - Reset Form
    func resetForm() {
        name = ""
        email = ""
        phone = ""
        selectedEvent = "SwiftUI Workshop"
        acceptedTerms = false
        errorMessage = ""
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
