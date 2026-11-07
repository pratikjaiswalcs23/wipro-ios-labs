
import Foundation

// MARK: - R1: Reusable Functions

print("===== R1: REUSABLE FUNCTIONS =====")

// Function 1: Calculate Mean
func calculateMean(numbers: [Double]) -> Double {
    guard !numbers.isEmpty else {
        return 0.0
    }

    return numbers.reduce(0, +) / Double(numbers.count)
}

// Function 2: Find Maximum
func findMaximum(numbers: [Int]) -> Int? {
    return numbers.max()
}

// Function 3: Validate Email
func validateEmail(email: String) -> Bool {
    let parts = email.split(separator: "@")

    return parts.count == 2 &&
           parts[0].contains(where: { $0.isLetter || $0.isNumber }) &&
           parts[1].contains(".")
}

// Function 4: Format Display Name
func formatDisplayName(firstName: String, lastName: String) -> String {
    return "\(firstName.capitalized) \(lastName.capitalized)"
}

// Function 5: Calculate Total
func calculateTotal(amounts: [Double]) -> Double {
    return amounts.reduce(0, +)
}

print("Mean:", calculateMean(numbers: [10, 20, 30, 40]))
print("Maximum:", findMaximum(numbers: [15, 45, 25, 60]) ?? 0)
print("Email Valid:", validateEmail(email: "pratik@gmail.com"))
print("Display Name:", formatDisplayName(firstName: "pratik", lastName: "jaiswal"))
print("Total:", calculateTotal(amounts: [100, 200, 300]))


// MARK: - R2: Map, Filter and Reduce

print("\n===== R2: HIGHER ORDER FUNCTIONS =====")

struct Transaction {
    let category: String
    let amount: Double
    let isExpense: Bool
}

let transactions = [
    Transaction(category: "Food", amount: 500, isExpense: true),
    Transaction(category: "Travel", amount: 300, isExpense: true),
    Transaction(category: "Shopping", amount: 1000, isExpense: true),
    Transaction(category: "Salary", amount: 5000, isExpense: false),
    Transaction(category: "Food", amount: 200, isExpense: true)
]

// Filter: Select only expenses
let expenses = transactions.filter { $0.isExpense }

print("Expense Count:", expenses.count)

// Map: Extract expense amounts
let expenseAmounts = expenses.map { $0.amount }

print("Expense Amounts:", expenseAmounts)

// Reduce: Calculate total expenses
let totalExpenses = expenseAmounts.reduce(0, +)

print("Total Expenses:", totalExpenses)


// MARK: - R3: Sort Students

print("\n===== R3: SORT STUDENTS =====")

struct Student {
    let name: String
    let marks: Int
}

let students = [
    Student(name: "Rahul", marks: 85),
    Student(name: "Pratik", marks: 95),
    Student(name: "Aman", marks: 85),
    Student(name: "Rohit", marks: 90),
    Student(name: "Ankit", marks: 95)
]

// Sort by marks descending, then name ascending
let sortedStudents = students.sorted {
    if $0.marks != $1.marks {
        return $0.marks > $1.marks
    }

    return $0.name < $1.name
}

for student in sortedStudents {
    print("\(student.name): \(student.marks)")
}


// MARK: - R4: Loop vs Higher Order Functions

print("\n===== R4: LOOP VS HIGHER ORDER =====")

let numbers = [1, 2, 3, 4, 5, 6]

// Loop-based approach
var loopTotal = 0

for number in numbers {
    if number % 2 == 0 {
        loopTotal += number * number
    }
}

print("Loop Result:", loopTotal)

// Higher-order function approach
let functionalTotal = numbers
    .filter { $0 % 2 == 0 }
    .map { $0 * $0 }
    .reduce(0, +)

print("Higher Order Result:", functionalTotal)


// MARK: - R5: Clear Parameters and Return Types

print("\n===== R5: FUNCTION TESTING =====")

let meanResult: Double = calculateMean(numbers: [20, 30, 40])
let maxResult: Int? = findMaximum(numbers: [10, 50, 30])
let emailResult: Bool = validateEmail(email: "test@gmail.com")
let nameResult: String = formatDisplayName(
    firstName: "hello",
    lastName: "world"
)

print("Mean Result:", meanResult)
print("Maximum Result:", maxResult ?? 0)
print("Email Result:", emailResult)
print("Name Result:", nameResult)


// MARK: - Optional Extension: Spending by Category

print("\n===== SPENDING BY CATEGORY =====")

let spendingReport = Dictionary(grouping: expenses, by: { $0.category })
    .mapValues { categoryTransactions in
        categoryTransactions
            .map { $0.amount }
            .reduce(0, +)
    }

for category in spendingReport.keys.sorted() {
    print("\(category): \(spendingReport[category] ?? 0)")
}

print("\n===== PROGRAM COMPLETED =====")
