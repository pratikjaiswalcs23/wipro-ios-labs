
import Foundation

// MARK: - Student Profile Model

struct Student {
    let id: Int
    let name: String
    var marks: Int?
    
    // Optional properties
    var address: String?
    var phone: String?
}

// Student Data
let students: [Int: Student] = [
    101: Student(id: 101, name: "Pratik", marks: 92,
                 address: "Mathura", phone: "9876543210"),
    102: Student(id: 102, name: "Rahul", marks: 85,
                 address: nil, phone: nil),
    103: Student(id: 103, name: "Aman", marks: nil,
                 address: "Delhi", phone: nil)
]


// MARK: - R1: Function Returning Optional Result

print("===== R1: OPTIONAL FUNCTION =====")

func getStudentMarks(id: Int) -> Int? {
    return students[id]?.marks
}

if let marks = getStudentMarks(id: 101) {
    print("Student 101 Marks:", marks)
} else {
    print("Marks not available")
}

// Searching missing student
if let marks = getStudentMarks(id: 105) {
    print("Student 105 Marks:", marks)
} else {
    print("Student 105 not found")
}


// MARK: - R2: Optional Handling Techniques

print("\n===== R2: OPTIONAL HANDLING =====")

// 1. if let
let studentName: String? = "Pratik"

if let name = studentName {
    print("If Let:", name)
} else {
    print("Name is missing")
}


// 2. guard let
func displayName(_ name: String?) {
    guard let validName = name else {
        print("Guard Let: Name is missing")
        return
    }

    print("Guard Let:", validName)
}

displayName("Rahul")
displayName(nil)


// 3. Optional Chaining
let student: Student? = students[101]

let studentAddress = student?.address
print("Optional Chaining:", studentAddress ?? "Address not available")


// 4. Nil Coalescing Operator
let phoneNumber: String? = nil

let phone = phoneNumber ?? "Phone number not provided"
print("Nil Coalescing:", phone)


// MARK: - R3: Missing Values Handling

print("\n===== R3: MISSING VALUES =====")

// Missing dictionary key
let missingStudent = students[999]

if let student = missingStudent {
    print("Student Found:", student.name)
} else {
    print("Student ID 999 does not exist")
}


// Empty text field handling
func processText(_ text: String?) {
    let safeText = text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

    if safeText.isEmpty {
        print("Text field is empty. Please enter a value.")
    } else {
        print("Entered Text:", safeText)
    }
}

processText("")
processText(nil)
processText("Hello Swift")


// MARK: - R4: Safe Unwrapping

print("\n===== R4: SAFE UNWRAPPING =====")

let optionalMarks: Int? = 95

if let marks = optionalMarks {
    print("Safely Unwrapped Marks:", marks)
} else {
    print("Marks are unavailable")
}

let unavailableMarks: Int? = nil

if let marks = unavailableMarks {
    print("Marks:", marks)
} else {
    print("No marks available")
}

print("No force unwrapping (!) is used in this program.")


// MARK: - Optional Extension: Profile Model

print("\n===== PROFILE MODEL =====")

struct Profile {
    let name: String
    var address: String?
    var phone: String?
}

let profile = Profile(
    name: "Pratik Jaiswal",
    address: nil,
    phone: "9876543210"
)

print("Name:", profile.name)
print("Address:", profile.address ?? "Address not provided")
print("Phone:", profile.phone ?? "Phone not provided")
