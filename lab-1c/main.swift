
import Foundation

// MARK: - R1: Array Operations

print("===== R1: ARRAY OPERATIONS =====")

var courses = ["Swift", "Java", "Python", "C++", "JavaScript"]

print("Original Courses:", courses)

// Add a course
courses.append("Kotlin")
print("After Adding:", courses)

// Remove a course
courses.removeAll { $0 == "C++" }
print("After Removing C++:", courses)

// Sort courses
courses.sort()
print("Sorted Courses:", courses)

// Filter courses
let filteredCourses = courses.filter { $0.count > 4 }
print("Courses with more than 4 letters:", filteredCourses)

// Search a course
if courses.contains("Java") {
    print("Java course found!")
} else {
    print("Java course not found!")
}


// MARK: - R2: Set Operations

print("\n===== R2: SET OPERATIONS =====")

let studentIDs = [101, 102, 103, 101, 104, 102, 105, 103]

let uniqueIDs = Set(studentIDs)

print("Original Student IDs:", studentIDs)
print("Unique Student IDs:", uniqueIDs.sorted())
print("Unique Student Count:", uniqueIDs.count)


// MARK: - R3: Dictionary Operations

print("\n===== R3: DICTIONARY OPERATIONS =====")

let studentMarks = [
    101: 85,
    102: 92,
    103: 76,
    104: 95,
    105: 68
]

// Find topper
if let topper = studentMarks.max(by: { $0.value < $1.value }) {
    print("Topper ID:", topper.key)
    print("Highest Marks:", topper.value)
}

// Students below 80 marks
print("Students scoring below 80:")

for (id, marks) in studentMarks.sorted(by: { $0.key < $1.key }) {
    if marks < 80 {
        print("Student ID:", id, "Marks:", marks)
    }
}


// MARK: - R4: Enum and Switch

print("\n===== R4: ENUM AND SWITCH =====")

enum TaskPriority {
    case low
    case medium
    case high
    case urgent
}

let priority = TaskPriority.high

switch priority {
case .low:
    print("Priority: Low - Complete when possible")
case .medium:
    print("Priority: Medium - Complete soon")
case .high:
    print("Priority: High - Complete as early as possible")
case .urgent:
    print("Priority: Urgent - Complete immediately")
}


// MARK: - Optional Extension: Enum with Associated Values

print("\n===== ENUM WITH ASSOCIATED VALUES =====")

enum APIResult {
    case success(String)
    case failure(String)
}

let result = APIResult.success("Data loaded successfully")

switch result {
case .success(let message):
    print("Success:", message)

case .failure(let error):
    print("Error:", error)
}


// MARK: - R5: Explanation

print("\n===== R5: COLLECTIONS EXPLANATION =====")

print("""
1. Array:
   Used to store ordered data.
   Allows duplicate values.
   Example: Course names.

2. Set:
   Used to store unique values.
   Automatically removes duplicates.
   Example: Unique student IDs.

3. Dictionary:
   Used to store data in key-value pairs.
   Each key is unique.
   Example: Student IDs and marks.
""")
