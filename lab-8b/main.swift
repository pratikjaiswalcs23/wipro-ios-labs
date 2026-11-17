
import SwiftUI

// MARK: - Model
struct Course: Identifiable, Hashable {
    let id: Int
    let name: String
    let category: String
    let duration: String
    let description: String
}

// MARK: - Sample Data
let courseList = [
    Course(
        id: 1,
        name: "SwiftUI Development",
        category: "iOS Development",
        duration: "6 Weeks",
        description: "Learn SwiftUI, navigation, reusable views and build modern iOS applications."
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
        description: "Understand arrays, stacks, queues, linked lists, trees and algorithms."
    ),
    Course(
        id: 4,
        name: "Web Development",
        category: "Web Development",
        duration: "5 Weeks",
        description: "Learn HTML, CSS and JavaScript to create responsive websites."
    )
]

// MARK: - App Entry Point
@main
struct NavigationDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - Main View
struct ContentView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            List(courseList) { course in
                NavigationLink(value: course) {
                    CourseRow(course: course)
                }
            }
            .navigationTitle("My Courses")
            .navigationDestination(for: Course.self) { course in
                CourseDetailView(course: course)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        path.append(courseList[0])
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button("Home") {
                        path = NavigationPath()
                    }
                }
            }
        }
    }
}

// MARK: - Course Row
struct CourseRow: View {
    let course: Course

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "book.fill")
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 45, height: 45)
                .background(Color.blue.opacity(0.12))
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 5) {
                Text(course.name)
                    .font(.headline)

                Text(course.category)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 5)
    }
}

// MARK: - Detail View
struct CourseDetailView: View {
    let course: Course

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "book.closed.fill")
                .font(.system(size: 65))
                .foregroundColor(.blue)
                .padding(25)
                .background(Color.blue.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 20))

            Text(course.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            VStack(alignment: .leading, spacing: 12) {
                Label(course.category, systemImage: "tag")
                Label(course.duration, systemImage: "clock")

                Divider()

                Text("About Course")
                    .font(.headline)

                Text(course.description)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(15)

            Spacer()
        }
        .padding()
        .navigationTitle("Course Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: course.name) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
