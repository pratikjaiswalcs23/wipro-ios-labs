
import SwiftUI
import Observation

// MARK: - Course Model
struct Course: Identifiable {
    let id: Int
    let name: String
    let category: String
    let description: String
}

// MARK: - Observable Model
@Observable
class CourseStore {
    var courses: [Course] = [
        Course(
            id: 1,
            name: "SwiftUI Development",
            category: "iOS Development",
            description: "Learn SwiftUI and build modern iOS applications."
        ),
        Course(
            id: 2,
            name: "Python Programming",
            category: "Programming",
            description: "Learn Python basics, functions and OOP."
        ),
        Course(
            id: 3,
            name: "Data Structures",
            category: "Computer Science",
            description: "Learn arrays, stacks, queues and algorithms."
        ),
        Course(
            id: 4,
            name: "Web Development",
            category: "Web Development",
            description: "Build websites using HTML, CSS and JavaScript."
        )
    ]

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

// MARK: - Main View
struct ContentView: View {
    @State private var store = CourseStore()
    @State private var searchText = ""
    @State private var showFavouritesOnly = false

    var filteredCourses: [Course] {
        store.courses.filter { course in
            let matchesSearch = searchText.isEmpty ||
                course.name.localizedCaseInsensitiveContains(searchText)

            let matchesFavourite = !showFavouritesOnly ||
                store.isFavourite(course.id)

            return matchesSearch && matchesFavourite
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {

                // Search Field
                TextField("Search courses...", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                // Favourite Filter
                Toggle("Show Favourites Only", isOn: $showFavouritesOnly)
                    .padding(.horizontal)

                // Course List
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
            }
            .navigationTitle("My Courses")
            .overlay {
                if filteredCourses.isEmpty {
                    ContentUnavailableView(
                        "No Courses Found",
                        systemImage: "book",
                        description: Text("Try another search or favourite a course.")
                    )
                }
            }
        }
    }
}

// MARK: - Course Row
struct CourseRow: View {
    let course: Course
    var store: CourseStore

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(course.name)
                    .font(.headline)

                Text(course.category)
                    .font(.caption)
                    .foregroundColor(.secondary)
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

// MARK: - Detail View
struct CourseDetailView: View {
    let course: Course
    var store: CourseStore

    var body: some View {
        VStack(spacing: 20) {

            Image(systemName: "book.fill")
                .font(.system(size: 65))
                .foregroundColor(.blue)
                .padding(25)
                .background(Color.blue.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 20))

            Text(course.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text(course.category)
                .font(.headline)
                .foregroundColor(.blue)

            Text(course.description)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

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

// MARK: - Preview
#Preview {
    ContentView()
}
