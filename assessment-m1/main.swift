
import Foundation

// ==========================================
// R1: GRADEBOOK USING ARRAYS, DICTIONARIES
// AND SAFE OPTIONALS
// ==========================================

print("\n========== R1: GRADEBOOK ==========")

struct Student {
    var name: String
    var marks: Int
}

var students: [Student] = [
    Student(name: "Pratik", marks: 85),
    Student(name: "Rahul", marks: 78),
    Student(name: "Aman", marks: 92),
    Student(name: "Rohit", marks: 67)
]

// Dictionary
var gradebook: [String: Int] = [:]

for student in students {
    gradebook[student.name] = student.marks
}

print("Student Gradebook:")

for student in students {
    print("\(student.name): \(student.marks)")
}

// Average marks
let totalMarks = students.reduce(0) { $0 + $1.marks }
let average = Double(totalMarks) / Double(students.count)

print("Average Marks:", average)

// Highest marks
if let topper = students.max(by: { $0.marks < $1.marks }) {
    print("Topper:", topper.name)
    print("Highest Marks:", topper.marks)
}

// Safe optional access
if let marks = gradebook["Pratik"] {
    print("Pratik's Marks:", marks)
} else {
    print("Student not found")
}

// Nil coalescing
let missingMarks = gradebook["Vikas"] ?? 0
print("Vikas's Marks:", missingMarks)


// ==========================================
// R2: GENERIC STACK WITH TWO DATA TYPES
// ==========================================

print("\n========== R2: GENERIC STACK ==========")

struct Stack<T> {

    private var elements: [T] = []

    mutating func push(_ element: T) {
        elements.append(element)
    }

    mutating func pop() -> T? {
        return elements.popLast()
    }

    func peek() -> T? {
        return elements.last
    }

    var count: Int {
        return elements.count
    }

    var isEmpty: Bool {
        return elements.isEmpty
    }
}

// Integer Stack
var intStack = Stack<Int>()

intStack.push(10)
intStack.push(20)
intStack.push(30)

print("Integer Stack Top:", intStack.peek() ?? 0)
print("Integer Stack Pop:", intStack.pop() ?? 0)
print("Integer Stack Count:", intStack.count)

// String Stack
var stringStack = Stack<String>()

stringStack.push("Swift")
stringStack.push("UIKit")
stringStack.push("SwiftUI")

print("String Stack Top:", stringStack.peek() ?? "Empty")
print("String Stack Pop:", stringStack.pop() ?? "Empty")
print("String Stack Count:", stringStack.count)


// ==========================================
// R3: RETAIN CYCLE FIX USING WEAK REFERENCE
// ==========================================

print("\n========== R3: RETAIN CYCLE ==========")

class Person {

    var name: String
    var apartment: Apartment?

    init(name: String) {
        self.name = name
        print("\(name) created")
    }

    deinit {
        print("Person \(name) deallocated")
    }
}

class Apartment {

    var number: String

    // Weak reference prevents retain cycle
    weak var tenant: Person?

    init(number: String) {
        self.number = number
        print("Apartment \(number) created")
    }

    deinit {
        print("Apartment \(number) deallocated")
    }
}

func testRetainCycleFix() {

    let person = Person(name: "Pratik")
    let apartment = Apartment(number: "A-101")

    person.apartment = apartment
    apartment.tenant = person

    print("Person:", person.name)
    print("Apartment:", apartment.number)
    print("Tenant:", apartment.tenant?.name ?? "No tenant")

    print("Leaving function...")
}

testRetainCycleFix()

print("Retain cycle demonstration completed")


// ==========================================
// R4: ERROR HANDLING AND VALIDATION
// ==========================================

print("\n========== R4: ERROR HANDLING ==========")

enum ValidationError: Error {
    case emptyName
    case invalidAge
}

func validateStudent(name: String, age: Int) throws -> String {

    if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        throw ValidationError.emptyName
    }

    if age < 18 || age > 100 {
        throw ValidationError.invalidAge
    }

    return "Student \(name) registered successfully!"
}

let studentRecords = [
    ("Pratik", 21),
    ("", 20),
    ("Rahul", 15)
]

for student in studentRecords {

    do {

        let message = try validateStudent(
            name: student.0,
            age: student.1
        )

        print(message)

    } catch ValidationError.emptyName {

        print("Error: Student name cannot be empty")

    } catch ValidationError.invalidAge {

        print("Error: Age must be between 18 and 100")

    } catch {

        print("Unknown error:", error)
    }
}


// ==========================================
// R5: STRUCT VS CLASS
// ==========================================

print("\n========== R5: STRUCT VS CLASS ==========")

struct StudentInfo {
    var name: String
}

class TeacherInfo {
    var name: String

    init(name: String) {
        self.name = name
    }
}

var student1 = StudentInfo(name: "Pratik")
var student2 = student1

student2.name = "Rahul"

print("Struct Student 1:", student1.name)
print("Struct Student 2:", student2.name)

let teacher1 = TeacherInfo(name: "Amit")
let teacher2 = teacher1

teacher2.name = "Rahul"

print("Class Teacher 1:", teacher1.name)
print("Class Teacher 2:", teacher2.name)


// ==========================================
// PROTOCOL VS INHERITANCE
// ==========================================

print("\n========== PROTOCOL VS INHERITANCE ==========")

protocol Printable {
    func printDetails()
}

class StudentDetails: Printable {

    func printDetails() {
        print("Student Details Displayed")
    }
}

class PersonDetails {
    func showName() {
        print("Person Name Displayed")
    }
}

class CollegeStudent: PersonDetails {
    func showCourse() {
        print("Course: Computer Science")
    }
}

let studentDetails = StudentDetails()
studentDetails.printDetails()

let collegeStudent = CollegeStudent()
collegeStudent.showName()
collegeStudent.showCourse()


// ==========================================
// MAP, FILTER AND REDUCE
// ==========================================

print("\n========== MAP FILTER REDUCE ==========")

let numbers = [1, 2, 3, 4, 5]

// Map
let squares = numbers.map { $0 * $0 }
print("Map - Squares:", squares)

// Filter
let evenNumbers = numbers.filter { $0 % 2 == 0 }
print("Filter - Even Numbers:", evenNumbers)

// Reduce
let sum = numbers.reduce(0) { $0 + $1 }
print("Reduce - Sum:", sum)


// ==========================================
// END OF MILESTONE 1
// ==========================================

print("\n========== MILESTONE 1 COMPLETED ==========")
