
import Foundation

// MARK: - R1: Struct and Class

print("===== R1: STRUCT AND CLASS =====")

// Struct: Value Type
struct Course {
    var name: String
    var duration: Int
}

// Class: Reference Type
class CourseManager {
    var course: Course

    init(course: Course) {
        self.course = course
    }
}

let originalCourse = Course(name: "Swift", duration: 30)
let manager = CourseManager(course: originalCourse)

print("Course Name:", manager.course.name)
print("Course Duration:", manager.course.duration)


// MARK: - R2: Value vs Reference Behaviour

print("\n===== R2: VALUE VS REFERENCE =====")

// Struct Copy
var course1 = Course(name: "Java", duration: 40)
var course2 = course1

course2.name = "Python"
course2.duration = 50

print("Original Struct:", course1.name, course1.duration)
print("Copied Struct:", course2.name, course2.duration)

// Class Copy
let manager1 = CourseManager(
    course: Course(name: "Java", duration: 40)
)

let manager2 = manager1

manager2.course.name = "Python"
manager2.course.duration = 50

print("Original Class Object:", manager1.course.name,
      manager1.course.duration)

print("Copied Class Reference:", manager2.course.name,
      manager2.course.duration)


// MARK: - R3: Teacher and Classroom

print("\n===== R3: WEAK REFERENCE =====")

class Teacher {
    let name: String
    weak var classroom: Classroom?

    init(name: String) {
        self.name = name
        print("Teacher Created:", name)
    }

    deinit {
        print("Teacher Released:", name)
    }
}

class Classroom {
    let roomNumber: Int
    var teacher: Teacher?

    init(roomNumber: Int) {
        self.roomNumber = roomNumber
        print("Classroom Created:", roomNumber)
    }

    deinit {
        print("Classroom Released:", roomNumber)
    }
}

do {
    let teacher = Teacher(name: "Mr. Sharma")
    let classroom = Classroom(roomNumber: 101)

    classroom.teacher = teacher
    teacher.classroom = classroom

    print("Teacher:", classroom.teacher?.name ?? "None")
    print("Classroom:", teacher.classroom?.roomNumber ?? 0)
}


// MARK: - R4: Strong Reference Cycle and Solution

print("\n===== R4: STRONG REFERENCE CYCLE =====")

class ClosureOwner {
    let name: String
    var action: (() -> Void)?

    init(name: String) {
        self.name = name
        print("Owner Created:", name)
    }

    func createStrongCycle() {
        // Strong capture of self creates a retain cycle
        action = {
            print("Strong Capture:", self.name)
        }
    }

    func createWeakCapture() {
        // Weak capture prevents the retain cycle
        action = { [weak self] in
            guard let self = self else {
                print("Owner no longer exists")
                return
            }

            print("Weak Capture:", self.name)
        }
    }

    deinit {
        print("Owner Released:", name)
    }
}

// Demonstrate strong cycle and manually break it
do {
    let owner = ClosureOwner(name: "Strong Owner")

    owner.createStrongCycle()
    owner.action?()

    // Break the strong reference cycle
    owner.action = nil
}

// Demonstrate weak capture solution
do {
    let owner = ClosureOwner(name: "Weak Owner")

    owner.createWeakCapture()
    owner.action?()
}


// MARK: - R5: Value Semantics, Reference Semantics and ARC

print("\n===== R5: MEMORY MANAGEMENT =====")

print("""
1. Struct:
   Struct is a value type.
   Copying creates an independent value.
   Changes in the copy do not affect the original.

2. Class:
   Class is a reference type.
   Copying a class variable copies its reference.
   Both variables point to the same object.

3. ARC:
   Automatic Reference Counting manages
   the lifetime of class instances.

4. Strong Reference:
   Keeps an object alive.

5. Weak Reference:
   Does not keep an object alive.
   It becomes nil when the object is released.

6. Unowned Reference:
   Does not keep an object alive.
   It is used when the referenced object
   is guaranteed to outlive the reference.
""")

print("\n===== PROGRAM COMPLETED =====")
