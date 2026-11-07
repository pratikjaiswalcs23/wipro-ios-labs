
import Foundation

// MARK: - R1: Sort Students Using Closure

print("===== R1: SORT STUDENTS =====")

struct Student {
    let name: String
    let marks: Int
}

let students = [
    Student(name: "Rahul", marks: 85),
    Student(name: "Pratik", marks: 95),
    Student(name: "Aman", marks: 75),
    Student(name: "Rohit", marks: 90)
]

// Closure sorts students by marks in descending order
let sortedStudents = students.sorted { (student1, student2) -> Bool in
    return student1.marks > student2.marks
}

for student in sortedStudents {
    print("\(student.name): \(student.marks)")
}


// MARK: - R2: Completion Closure

print("\n===== R2: COMPLETION CLOSURE =====")

// Function accepts a completion closure as a parameter
func performOperation(completion: () -> Void) {
    print("Operation Started")

    // Simulated operation
    print("Processing data...")

    // Calling completion after operation
    completion()
}

performOperation {
    print("Operation Completed Successfully!")
}


// MARK: - R3: Trailing Closure and Shorthand Arguments

print("\n===== R3: CLOSURE SYNTAX =====")

let numbers = [10, 20, 30, 40, 50]

// Trailing closure with shorthand argument name $0
let doubledNumbers = numbers.map {
    $0 * 2
}

print("Using Shorthand Arguments:", doubledNumbers)

// Same example using explicit parameter names
let doubledExplicit = numbers.map { number in
    return number * 2
}

print("Using Explicit Arguments:", doubledExplicit)

// Trailing closure syntax
func calculate(a: Int, b: Int, operation: (Int, Int) -> Int) -> Int {
    return operation(a, b)
}

let sum = calculate(a: 10, b: 20) { x, y in
    return x + y
}

print("Sum:", sum)


// MARK: - R4: Counter Closure and Captured State

print("\n===== R4: COUNTER CLOSURE =====")

func createCounter() -> () -> Int {

    // Variable is captured by the returned closure
    var count = 0

    let counter = {
        count += 1
        return count
    }

    return counter
}

let counter = createCounter()

print("Counter:", counter())
print("Counter:", counter())
print("Counter:", counter())
print("Counter:", counter())


// MARK: - R5: Avoid Retain Cycle Using Weak Self

print("\n===== R5: WEAK SELF =====")

class DataManager {

    var completion: (() -> Void)?

    let name: String

    init(name: String) {
        self.name = name
        print("DataManager Created:", name)
    }

    func loadData() {

        // [weak self] prevents a strong reference cycle
        completion = { [weak self] in

            // Safely unwrap weak self
            guard let self = self else {
                print("DataManager no longer exists")
                return
            }

            print("Loading data for:", self.name)
        }
    }

    deinit {
        print("DataManager Released:", name)
    }
}

do {
    let manager = DataManager(name: "Student Data")

    manager.loadData()

    // Execute stored closure
    manager.completion?()
}


// MARK: - Optional Extension: Retry Helper

print("\n===== RETRY HELPER =====")

// Accepts an operation closure and retries on failure
func retryOperation(
    maxAttempts: Int,
    operation: () -> Bool
) -> Bool {

    for attempt in 1...max(0, maxAttempts) {

        print("Attempt:", attempt)

        if operation() {
            print("Operation Successful!")
            return true
        }

        print("Operation Failed!")
    }

    print("All attempts failed.")
    return false
}

var attempts = 0

let result = retryOperation(maxAttempts: 3) {
    attempts += 1

    // Simulate success on third attempt
    return attempts == 3
}

print("Final Result:", result)

print("\n===== PROGRAM COMPLETED =====")
