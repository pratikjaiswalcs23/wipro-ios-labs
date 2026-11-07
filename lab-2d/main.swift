
import Foundation

// MARK: - R1: ValidationError Enum

print("===== R1: VALIDATION ERROR =====")

enum ValidationError: Error {
    case emptyName
    case invalidMark
    case invalidID
}

// MARK: - Student Model

struct Student {
    let id: Int
    let name: String
    let marks: Int
}


// MARK: - R2: Throwing Student Registration Function

print("\n===== R2: STUDENT REGISTRATION =====")

func registerStudent(id: Int, name: String, marks: Int) throws -> Student {

    // Validate student name
    guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
        throw ValidationError.emptyName
    }

    // Validate marks between 0 and 100
    guard marks >= 0 && marks <= 100 else {
        throw ValidationError.invalidMark
    }

    // Validate student ID
    guard id > 0 else {
        throw ValidationError.invalidID
    }

    return Student(id: id, name: name, marks: marks)
}


// MARK: - R3: Do Catch Error Handling

print("\n===== R3: DO CATCH HANDLING =====")

func displayRegistration(id: Int, name: String, marks: Int) {

    do {
        let student = try registerStudent(
            id: id,
            name: name,
            marks: marks
        )

        print("Registration Successful!")
        print("Student ID:", student.id)
        print("Student Name:", student.name)
        print("Student Marks:", student.marks)

    } catch ValidationError.emptyName {
        print("Error: Student name cannot be empty.")

    } catch ValidationError.invalidMark {
        print("Error: Marks must be between 0 and 100.")

    } catch ValidationError.invalidID {
        print("Error: Student ID must be greater than zero.")

    } catch {
        print("Unknown Error:", error)
    }
}

// Successful registration
displayRegistration(id: 101, name: "Pratik", marks: 92)

// Empty name
displayRegistration(id: 102, name: "", marks: 85)

// Invalid marks
displayRegistration(id: 103, name: "Rahul", marks: 120)

// Invalid ID
displayRegistration(id: -1, name: "Aman", marks: 75)


// MARK: - R4: Throws vs Optional vs Result

print("\n===== R4: ERROR HANDLING COMPARISON =====")

// 1. Optional Return
func findStudentMarks(id: Int) -> Int? {
    let marks: [Int: Int] = [
        101: 92,
        102: 85,
        103: 76
    ]

    return marks[id]
}

print("Optional Result:", findStudentMarks(id: 101) ?? -1)
print("Missing Student:", findStudentMarks(id: 999) ?? -1)


// 2. Throws
func validateMarks(_ marks: Int) throws -> Int {

    guard marks >= 0 && marks <= 100 else {
        throw ValidationError.invalidMark
    }

    return marks
}

do {
    let result = try validateMarks(90)
    print("Throws Result:", result)

} catch {
    print("Throws Error: Invalid marks")
}


// 3. Result
func checkMarks(_ marks: Int) -> Result<Int, ValidationError> {

    guard marks >= 0 && marks <= 100 else {
        return .failure(.invalidMark)
    }

    return .success(marks)
}

let result = checkMarks(110)

switch result {
case .success(let marks):
    print("Result Success:", marks)

case .failure(.invalidMark):
    print("Result Failure: Invalid marks")

case .failure(.emptyName):
    print("Result Failure: Empty name")

case .failure(.invalidID):
    print("Result Failure: Invalid ID")
}


// MARK: - R5: Safe Invalid Input Handling

print("\n===== R5: SAFE INPUT HANDLING =====")

let testCases = [
    (101, "Pratik", 92),
    (102, "", 85),
    (103, "Rahul", 120),
    (-1, "Aman", 75),
    (104, "Rohit", 0),
    (105, "Neha", 100)
]

for test in testCases {
    print("\nTesting ID:", test.0)

    displayRegistration(
        id: test.0,
        name: test.1,
        marks: test.2
    )
}


// MARK: - Optional Extension: Simulated Network Result

print("\n===== OPTIONAL: NETWORK RESULT =====")

enum NetworkError: Error {
    case serverError
    case noInternet
}

func fetchData(success: Bool) -> Result<String, NetworkError> {

    if success {
        return .success("Student data received successfully.")
    } else {
        return .failure(.serverError)
    }
}

func displayNetworkResult(_ result: Result<String, NetworkError>) {

    switch result {
    case .success(let data):
        print("Success:", data)

    case .failure(.serverError):
        print("Error: Server is temporarily unavailable.")

    case .failure(.noInternet):
        print("Error: Please check your internet connection.")
    }
}

displayNetworkResult(fetchData(success: true))
displayNetworkResult(fetchData(success: false))


print("\n===== PROGRAM COMPLETED =====")
