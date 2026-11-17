
import SwiftUI

// MARK: - Course Model
struct Course: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let category: String
    let status: String
    let icon: String
    let color: Color
    let description: String
}

// MARK: - Sample Data
let courses = [
    Course(
        title: "SwiftUI Development",
        subtitle: "Learn iOS App Development",
        category: "Mobile Development",
        status: "In Progress",
        icon: "swift",
        color: .orange,
        description: "Learn to build beautiful iOS applications using SwiftUI, reusable views and modern app architecture."
    ),
    Course(
        title: "Python Programming",
        subtitle: "Learn Python from Basics",
        category: "Programming",
        status: "Completed",
        icon: "chevron.left.forwardslash.chevron.right",
        color: .blue,
        description: "Understand Python programming, functions, loops, OOP and practical problem solving."
    ),
    Course(
        title: "Data Structures",
        subtitle: "Master DSA Concepts",
        category: "Computer Science",
        status: "Not Started",
        icon: "list.bullet.rectangle",
        color: .purple,
        description: "Study arrays, linked lists, stacks, queues, trees and algorithms."
    ),
    Course(
        title: "Web Development",
        subtitle: "HTML, CSS and JavaScript",
        category: "Web Development",
        status: "In Progress",
        icon: "globe",
        color: .green,
        description: "Create responsive websites using HTML, CSS and JavaScript."
    )
]

// MARK: - Main View
struct ContentView: View {
    @State private var searchText = ""

    var filteredCourses: [Course] {
        if searchText.isEmpty {
            return courses
        }
        return courses.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.category.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {

                // Header
                VStack(alignment: .leading, spacing: 5) {
                    Text("Course Explorer")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Explore and learn new skills")
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)

                // Search
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)

                    TextField("Search courses...", text: $searchText)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)

                // Category Label
                Text("Available Courses")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                // Course List
                if filteredCourses.isEmpty {
                    EmptyCourseView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 14) {
                            ForEach(filteredCourses) { course in
                                NavigationLink {
                                    CourseDetailView(course: course)
                                } label: {
                                    CourseCard(course: course)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }

                Spacer(minLength: 0)
            }
            .padding(.top)
            .background(Color(.systemGroupedBackground))
        }
    }
}

// MARK: - Reusable Course Card
struct CourseCard: View {
    let course: Course

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack {
                Image(systemName: course.icon)
                    .font(.title)
                    .foregroundColor(course.color)
                    .frame(width: 55, height: 55)
                    .background(course.color.opacity(0.12))
                    .cornerRadius(12)

                Spacer()

                Text(course.status)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(course.color)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(course.color.opacity(0.12))
                    .cornerRadius(10)
            }

            Text(course.title)
                .font(.headline)
                .foregroundColor(.primary)

            Text(course.subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack {
                Text(course.category)
                    .font(.caption)
                    .foregroundColor(.blue)

                Spacer()

                Image(systemName: "arrow.right")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4)
    }
}

// MARK: - Course Detail Screen
struct CourseDetailView: View {
    let course: Course

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                Image(systemName: course.icon)
                    .font(.system(size: 65))
                    .foregroundColor(course.color)
                    .frame(height: 130)
                    .frame(maxWidth: .infinity)
                    .background(course.color.opacity(0.12))
                    .cornerRadius(20)

                Text(course.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(course.category)
                    .font(.headline)
                    .foregroundColor(.blue)

                Text(course.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

                Text("Status: \(course.status)")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(course.color.opacity(0.12))
                    .cornerRadius(12)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Course Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Empty State
struct EmptyCourseView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "book.closed")
                .font(.system(size: 55))
                .foregroundColor(.gray)

            Text("No Courses Found")
                .font(.title3)
                .fontWeight(.bold)

            Text("Try searching with another keyword.")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
