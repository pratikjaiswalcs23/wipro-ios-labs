
import Foundation

// MARK: - R1: Displayable Protocol

print("===== R1: PROTOCOL =====")

protocol Displayable {
    func display() -> String
}

struct Student: Displayable {
    let name: String
    let marks: Int

    func display() -> String {
        return "Student: \(name), Marks: \(marks)"
    }
}

struct Course: Displayable {
    let name: String
    let duration: Int

    func display() -> String {
        return "Course: \(name), Duration: \(duration) days"
    }
}

let student = Student(name: "Pratik", marks: 92)
let course = Course(name: "Swift", duration: 30)

print(student.display())
print(course.display())


// MARK: - R2: Extension

print("\n===== R2: EXTENSIONS =====")

// Extension adds a computed property to String
extension String {
    var wordCount: Int {
        return self.split(separator: " ").count
    }

    func reversedText() -> String {
        return String(self.reversed())
    }
}

let message = "Swift Programming Language"

print("Original Text:", message)
print("Word Count:", message.wordCount)
print("Reversed Text:", message.reversedText())


// MARK: - R3: Generic Stack

print("\n===== R3: GENERIC STACK =====")

struct Stack<T> {

    private var items: [T] = []

    // Push an element
    mutating func push(_ item: T) {
        items.append(item)
    }

    // Pop the top element
    mutating func pop() -> T? {
        return items.popLast()
    }

    // Peek at the top element
    func peek() -> T? {
        return items.last
    }

    // Check whether stack is empty
    var isEmpty: Bool {
        return items.isEmpty
    }
}

var intStack = Stack<Int>()

intStack.push(10)
intStack.push(20)
intStack.push(30)

print("Integer Stack Top:", intStack.peek() ?? 0)
print("Popped Element:", intStack.pop() ?? 0)
print("New Top:", intStack.peek() ?? 0)
print("Is Empty:", intStack.isEmpty)


// MARK: - R4: Protocol Constraint in Generic Function

print("\n===== R4: GENERIC FUNCTION =====")

// Protocol-constrained generic function
func displayItems<T: Displayable>(_ items: [T]) {
    for item in items {
        print(item.display())
    }
}

// Valid use: Student and Course conform to Displayable
displayItems([student])
displayItems([course])

// Invalid use example:
// displayItems([10, 20, 30])
// This produces a compile-time error because Int
// does not conform to Displayable.


// MARK: - R5: Extensions vs New Types

print("\n===== R5: EXTENSIONS VS NEW TYPES =====")

print("""
1. Extensions add new functionality to existing types.
2. Extensions can add computed properties and methods.
3. Extensions cannot add stored properties.
4. A new type is required when we need new stored state.
5. Structs and classes can store their own properties.
""")


// MARK: - Optional Extension: Stack Protocol

print("\n===== OPTIONAL: STACK PROTOCOL =====")

protocol StackProtocol {
    associatedtype Element

    mutating func push(_ item: Element)
    mutating func pop() -> Element?
    func peek() -> Element?
    var isEmpty: Bool { get }
}

// Stack conforms to custom protocol
extension Stack: StackProtocol {}

var stringStack = Stack<String>()

stringStack.push("Swift")
stringStack.push("Java")
stringStack.push("Python")

print("String Stack Top:", stringStack.peek() ?? "Empty")
print("String Stack Pop:", stringStack.pop() ?? "Empty")

var anotherIntStack = Stack<Int>()

anotherIntStack.push(100)
anotherIntStack.push(200)

print("Integer Stack Top:", anotherIntStack.peek() ?? 0)


// MARK: - Assertions and Testing

print("\n===== ASSERTION TESTS =====")

// Test 1: Student display
assert(student.display() == "Student: Pratik, Marks: 92")

// Test 2: Course display
assert(course.display() == "Course: Swift, Duration: 30 days")

// Test 3: Word count
assert(message.wordCount == 3)

// Test 4: Reversed text
assert("Swift".reversedText() == "tfiwS")

// Test 5: Stack push and peek
var testStack = Stack<Int>()
testStack.push(10)
assert(testStack.peek() == 10)

// Test 6: Stack pop
assert(testStack.pop() == 10)

// Test 7: Stack is empty
assert(testStack.isEmpty == true)

// Test 8: Stack with String
var testStringStack = Stack<String>()
testStringStack.push("Hello")
assert(testStringStack.peek() == "Hello")

// Test 9: Stack pop returns nil when empty
assert(testStringStack.pop() == "Hello")
assert(testStringStack.pop() == nil)

print("All 10 assertion checks passed!")

print("\n===== PROGRAM COMPLETED =====")
