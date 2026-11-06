
import Foundation

// R1: Student Details

let studentName: String = "Pratik Jaiswal"
let rollNumber: Int = 101

let marks: [Int] = [85, 78, 90, 65, 72]
var attendance: Double = 85.5

print("========== STUDENT DETAILS ==========")
print("Name: \(studentName)")
print("Roll Number: \(rollNumber)")
print("Marks: \(marks)")
print("Attendance: \(attendance)%")

// R2: Total, Average, Percentage and Pass/Fail

let totalSubjects = marks.count
let totalMarks = marks.reduce(0, +)
let maximumMarks = totalSubjects * 100

let average = Double(totalMarks) / Double(totalSubjects)
let percentage = Double(totalMarks) / Double(maximumMarks) * 100

let passingMarks = 40
let minimumAttendance = 75.0

let allMarksValid = marks.allSatisfy { $0 >= 0 && $0 <= 100 }
let passedAllSubjects = marks.allSatisfy { $0 >= passingMarks }
let attendanceValid = attendance >= 0 && attendance <= 100
let attendanceEligible = attendance >= minimumAttendance

let isPass = allMarksValid && passedAllSubjects &&
             attendanceValid && attendanceEligible

print("\n========== RESULT ==========")
print("Total Marks: \(totalMarks)/\(maximumMarks)")
print("Average: \(average)")
print("Percentage: \(percentage)%")
print("Result: \(isPass ? "PASS" : "FAIL")")

// R3: Operators

let a = 20
let b = 10

// Arithmetic Operators
print("\n--- Arithmetic Operators ---")
print("Addition: \(a + b)")
print("Subtraction: \(a - b)")
print("Multiplication: \(a * b)")
print("Division: \(a / b)")
print("Modulus: \(a % b)")

// Comparison Operators
print("\n--- Comparison Operators ---")
print("Equal: \(a == b)")
print("Not Equal: \(a != b)")
print("Greater: \(a > b)")
print("Less: \(a < b)")
print("Greater or Equal: \(a >= b)")
print("Less or Equal: \(a <= b)")

// Logical Operators
print("\n--- Logical Operators ---")
print("AND: \(passedAllSubjects && attendanceEligible)")
print("OR: \(passedAllSubjects || attendanceEligible)")
print("NOT: \(!passedAllSubjects)")

// Compound Assignment Operators
var score = 10

score += 5
print("\nAfter += : \(score)")

score -= 3
print("After -= : \(score)")

score *= 2
print("After *= : \(score)")

score /= 4
print("After /= : \(score)")

// Nil Coalescing Operator
let optionalName: String? = nil
let displayName = optionalName ?? studentName

print("\nNil Coalescing: \(displayName)")

// R4: Grade Calculation using Function and If-Else

func calculateGrade(percentage: Double, passed: Bool) -> String {

    if !passed {
        return "F"
    }

    if percentage >= 90 {
        return "A+"
    } else if percentage >= 80 {
        return "A"
    } else if percentage >= 70 {
        return "B"
    } else if percentage >= 60 {
        return "C"
    } else if percentage >= 50 {
        return "D"
    } else {
        return "E"
    }
}

let grade = calculateGrade(
    percentage: percentage,
    passed: isPass
)

// Switch Statement
print("\n========== GRADE ==========")

switch grade {
case "A+":
    print("Excellent Performance")
case "A":
    print("Very Good Performance")
case "B":
    print("Good Performance")
case "C":
    print("Average Performance")
case "D":
    print("Below Average")
case "E":
    print("Just Passed")
default:
    print("Failed")
}

print("Final Grade: \(grade)")

// R5: Boundary Value Validation

func validateMark(_ mark: Int) -> String {

    if mark < 0 || mark > 100 {
        return "INVALID"
    } else if mark < passingMarks {
        return "FAIL"
    } else {
        return "PASS"
    }
}

func validateAttendance(_ value: Double) -> String {

    if value < 0 || value > 100 {
        return "INVALID"
    } else if value < minimumAttendance {
        return "LOW ATTENDANCE"
    } else {
        return "VALID"
    }
}

print("\n========== BOUNDARY TESTING ==========")

let testMarks = [0, 39, 40, 100, -1, 101]

for mark in testMarks {
    print("Mark \(mark): \(validateMark(mark))")
}

let testAttendance = [75.0, 100.0, -5.0, 110.0]

for value in testAttendance {
    print("Attendance \(value)%: \(validateAttendance(value))")
}

print("\n========== PROGRAM COMPLETED ==========")
