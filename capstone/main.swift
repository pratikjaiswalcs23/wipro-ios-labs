
import SwiftUI
import XCTest

// =====================================================
// MARK: - MODEL
// =====================================================

enum ExpenseCategory: String, CaseIterable, Identifiable, Codable {
    case food = "Food"
    case travel = "Travel"
    case shopping = "Shopping"
    case education = "Education"
    case bills = "Bills"
    case other = "Other"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .food: return "fork.knife"
        case .travel: return "car.fill"
        case .shopping: return "bag.fill"
        case .education: return "book.fill"
        case .bills: return "doc.text.fill"
        case .other: return "ellipsis.circle"
        }
    }
}

struct Expense: Identifiable, Codable {
    var id = UUID()
    var title: String
    var amount: Double
    var category: ExpenseCategory
    var date: Date
}

// =====================================================
// MARK: - SERVICE
// =====================================================

final class ExpenseService {

    private let key = "ExpenseMateData"

    func load() -> [Expense] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }

        return (try? JSONDecoder().decode([Expense].self, from: data)) ?? []
    }

    func save(_ expenses: [Expense]) {
        guard let data = try? JSONEncoder().encode(expenses) else {
            return
        }

        UserDefaults.standard.set(data, forKey: key)
    }
}

// =====================================================
// MARK: - VIEW MODEL
// =====================================================

@MainActor
final class ExpenseViewModel: ObservableObject {

    @Published var expenses: [Expense] = []
    @Published var budget: Double = 10000

    private let service: ExpenseService

    init(service: ExpenseService = ExpenseService()) {
        self.service = service
        self.expenses = service.load()
    }

    var monthlyExpenses: [Expense] {
        expenses.filter {
            Calendar.current.isDate(
                $0.date,
                equalTo: Date(),
                toGranularity: .month
            )
        }
    }

    var totalSpent: Double {
        monthlyExpenses.reduce(0) { $0 + $1.amount }
    }

    var remainingBudget: Double {
        budget - totalSpent
    }

    var progress: Double {
        guard budget > 0 else { return 0 }
        return min(totalSpent / budget, 1)
    }

    var categoryTotals: [(ExpenseCategory, Double)] {
        ExpenseCategory.allCases.map { category in
            (
                category,
                monthlyExpenses
                    .filter { $0.category == category }
                    .reduce(0) { $0 + $1.amount }
            )
        }
        .filter { $0.1 > 0 }
        .sorted { $0.1 > $1.1 }
    }

    @discardableResult
    func addExpense(
        title: String,
        amount: Double,
        category: ExpenseCategory
    ) -> Bool {

        let cleanTitle = title.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanTitle.isEmpty,
              amount.isFinite,
              amount > 0 else {
            return false
        }

        let expense = Expense(
            title: cleanTitle,
            amount: amount,
            category: category,
            date: Date()
        )

        expenses.insert(expense, at: 0)
        service.save(expenses)

        return true
    }

    func deleteExpense(_ expense: Expense) {
        expenses.removeAll { $0.id == expense.id }
        service.save(expenses)
    }

    func search(_ query: String) -> [Expense] {
        guard !query.isEmpty else { return expenses }

        return expenses.filter {
            $0.title.localizedCaseInsensitiveContains(query)
        }
    }

    @discardableResult
    func updateBudget(_ value: Double) -> Bool {
        guard value.isFinite, value > 0 else {
            return false
        }

        budget = value
        return true
    }
}

// =====================================================
// MARK: - MAIN APP
// =====================================================

struct ContentView: View {

    @StateObject private var vm = ExpenseViewModel()

    var body: some View {
        TabView {

            NavigationStack {
                DashboardView(vm: vm)
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            NavigationStack {
                TransactionView(vm: vm)
            }
            .tabItem {
                Label("Transactions", systemImage: "list.bullet")
            }

            NavigationStack {
                AddExpenseView(vm: vm)
            }
            .tabItem {
                Label("Add", systemImage: "plus.circle.fill")
            }

            NavigationStack {
                InsightsView(vm: vm)
            }
            .tabItem {
                Label("Insights", systemImage: "chart.pie.fill")
            }
        }
        .tint(.blue)
    }
}

// =====================================================
// MARK: - DASHBOARD SCREEN
// =====================================================

struct DashboardView: View {

    @ObservedObject var vm: ExpenseViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                VStack(alignment: .leading, spacing: 10) {
                    Text("Total Monthly Spending")
                        .foregroundStyle(.white.opacity(0.8))

                    Text(vm.totalSpent, format: .currency(code: "INR"))
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)

                    Text("ExpenseMate Dashboard")
                        .foregroundStyle(.white.opacity(0.8))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))

                HStack {
                    dashboardCard(
                        title: "Budget",
                        value: vm.budget
                    )

                    dashboardCard(
                        title: "Remaining",
                        value: vm.remainingBudget
                    )
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Budget Progress")
                        .font(.headline)

                    ProgressView(value: vm.progress)
                        .tint(vm.remainingBudget < 0 ? .red : .green)

                    Text("\(Int(vm.progress * 100))% budget used")
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 15))

                Text("Recent Expenses")
                    .font(.title2.bold())

                if vm.expenses.isEmpty {
                    ContentUnavailableView(
                        "No Expenses",
                        systemImage: "tray",
                        description: Text("Add your first expense.")
                    )
                } else {
                    ForEach(Array(vm.expenses.prefix(5))) { expense in
                        ExpenseRow(expense: expense)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("ExpenseMate")
    }

    private func dashboardCard(
        title: String,
        value: Double
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundStyle(.secondary)

            Text(value, format: .currency(code: "INR"))
                .font(.headline)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

// =====================================================
// MARK: - TRANSACTIONS SCREEN
// =====================================================

struct TransactionView: View {

    @ObservedObject var vm: ExpenseViewModel

    @State private var searchText = ""
    @State private var category: ExpenseCategory?

    var filteredExpenses: [Expense] {
        vm.search(searchText).filter {
            category == nil || $0.category == category
        }
    }

    var body: some View {
        List {

            Section("Filter") {
                Picker("Category", selection: $category) {
                    Text("All Categories")
                        .tag(Optional<ExpenseCategory>.none)

                    ForEach(ExpenseCategory.allCases) { item in
                        Text(item.rawValue)
                            .tag(Optional(item))
                    }
                }
            }

            Section("Transactions") {
                if filteredExpenses.isEmpty {
                    ContentUnavailableView(
                        "No Transactions Found",
                        systemImage: "magnifyingglass"
                    )
                } else {
                    ForEach(filteredExpenses) { expense in
                        ExpenseRow(expense: expense)
                    }
                    .onDelete { offsets in
                        let selected = offsets.map {
                            filteredExpenses[$0]
                        }

                        selected.forEach {
                            vm.deleteExpense($0)
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText)
        .navigationTitle("Transactions")
        .toolbar {
            EditButton()
        }
    }
}

// =====================================================
// MARK: - ADD EXPENSE SCREEN
// =====================================================

struct AddExpenseView: View {

    @ObservedObject var vm: ExpenseViewModel

    @State private var title = ""
    @State private var amount = ""
    @State private var category: ExpenseCategory = .food
    @State private var errorMessage = ""
    @State private var showSuccess = false

    var body: some View {
        Form {

            Section("Expense Details") {

                TextField("Expense Title", text: $title)
                    .accessibilityIdentifier("expenseTitle")

                TextField("Amount in ₹", text: $amount)
                    .keyboardType(.decimalPad)
                    .accessibilityIdentifier("expenseAmount")

                Picker("Category", selection: $category) {
                    ForEach(ExpenseCategory.allCases) { item in
                        Text(item.rawValue).tag(item)
                    }
                }
            }

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }

            Button("Save Expense") {
                saveExpense()
            }
            .accessibilityIdentifier("saveExpense")
            .frame(maxWidth: .infinity)

            if showSuccess {
                Text("Expense added successfully!")
                    .foregroundStyle(.green)
            }
        }
        .navigationTitle("Add Expense")
    }

    private func saveExpense() {
        guard let value = Double(amount),
              value.isFinite,
              value > 0 else {
            errorMessage = "Please enter a valid amount."
            showSuccess = false
            return
        }

        if vm.addExpense(
            title: title,
            amount: value,
            category: category
        ) {
            title = ""
            amount = ""
            errorMessage = ""
            showSuccess = true
        } else {
            errorMessage = "Please enter a valid title and amount."
            showSuccess = false
        }
    }
}

// =====================================================
// MARK: - INSIGHTS SCREEN
// =====================================================

struct InsightsView: View {

    @ObservedObject var vm: ExpenseViewModel

    @State private var budgetText = ""
    @State private var message = ""

    var body: some View {
        List {

            Section("Monthly Summary") {
                LabeledContent(
                    "Total Spent",
                    value: vm.totalSpent.formatted(.currency(code: "INR"))
                )

                LabeledContent(
                    "Monthly Budget",
                    value: vm.budget.formatted(.currency(code: "INR"))
                )

                LabeledContent(
                    "Remaining",
                    value: vm.remainingBudget.formatted(.currency(code: "INR"))
                )
            }

            Section("Category Breakdown") {
                if vm.categoryTotals.isEmpty {
                    ContentUnavailableView(
                        "No Data Available",
                        systemImage: "chart.pie"
                    )
                } else {
                    ForEach(vm.categoryTotals, id: \.0) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(item.0.rawValue)
                                Spacer()
                                Text(
                                    item.1,
                                    format: .currency(code: "INR")
                                )
                            }

                            ProgressView(
                                value: vm.totalSpent > 0
                                ? item.1 / vm.totalSpent : 0
                            )
                        }
                    }
                }
            }

            Section("Update Budget") {
                TextField("Enter new budget", text: $budgetText)
                    .keyboardType(.decimalPad)

                Button("Update Budget") {
                    if let value = Double(budgetText),
                       vm.updateBudget(value) {
                        message = "Budget updated successfully!"
                        budgetText = ""
                    } else {
                        message = "Enter a valid budget greater than zero."
                    }
                }

                if !message.isEmpty {
                    Text(message)
                        .foregroundStyle(.blue)
                }
            }
        }
        .navigationTitle("Insights")
    }
}

// =====================================================
// MARK: - REUSABLE ROW
// =====================================================

struct ExpenseRow: View {

    let expense: Expense

    var body: some View {
        HStack(spacing: 12) {

            Image(systemName: expense.category.icon)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 40, height: 40)
                .background(.blue.opacity(0.1))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 5) {
                Text(expense.title)
                    .font(.headline)

                Text(expense.category.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(expense.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(
                expense.amount,
                format: .currency(code: "INR")
            )
            .bold()
        }
        .padding(.vertical, 5)
    }
}

// =====================================================
// MARK: - UNIT TESTS
// NOTE: Keep this test class in a separate XCTest target
// if you want Xcode to discover and execute these tests.
// =====================================================

@MainActor
final class ExpenseMateTests: XCTestCase {

    func makeVM() -> ExpenseViewModel {
        ExpenseViewModel(
            service: ExpenseService()
        )
    }

    func testAddValidExpense() {
        let vm = makeVM()
        let title = "Test \(UUID().uuidString)"

        XCTAssertTrue(
            vm.addExpense(
                title: title,
                amount: 100,
                category: .food
            )
        )

        XCTAssertTrue(vm.search(title).contains {
            $0.title == title
        })
    }

    func testRejectEmptyTitle() {
        let vm = makeVM()

        XCTAssertFalse(
            vm.addExpense(
                title: " ",
                amount: 100,
                category: .food
            )
        )
    }

    func testRejectZeroAmount() {
        let vm = makeVM()

        XCTAssertFalse(
            vm.addExpense(
                title: "Test",
                amount: 0,
                category: .food
            )
        )
    }

    func testRejectNegativeAmount() {
        let vm = makeVM()

        XCTAssertFalse(
            vm.addExpense(
                title: "Test",
                amount: -100,
                category: .travel
            )
        )
    }

    func testRejectInfiniteAmount() {
        let vm = makeVM()

        XCTAssertFalse(
            vm.addExpense(
                title: "Test",
                amount: .infinity,
                category: .other
            )
        )
    }

    func testSearchExpense() {
        let vm = makeVM()
        let title = "Search \(UUID().uuidString)"

        _ = vm.addExpense(
            title: title,
            amount: 200,
            category: .education
        )

        XCTAssertTrue(vm.search(title).contains {
            $0.title == title
        })
    }

    func testDeleteExpense() {
        let vm = makeVM()
        let title = "Delete \(UUID().uuidString)"

        _ = vm.addExpense(
            title: title,
            amount: 300,
            category: .shopping
        )

        let expense = vm.search(title).first!
        vm.deleteExpense(expense)

        XCTAssertFalse(vm.expenses.contains {
            $0.id == expense.id
        })
    }

    func testUpdateValidBudget() {
        let vm = makeVM()

        XCTAssertTrue(vm.updateBudget(15000))
        XCTAssertEqual(vm.budget, 15000)
    }

    func testRejectInvalidBudget() {
        let vm = makeVM()

        XCTAssertFalse(vm.updateBudget(0))
        XCTAssertFalse(vm.updateBudget(-500))
    }

    func testMonthlyTotalCalculation() {
        let vm = makeVM()
        let oldTotal = vm.totalSpent

        _ = vm.addExpense(
            title: "Total \(UUID().uuidString)",
            amount: 500,
            category: .food
        )

        XCTAssertEqual(
            vm.totalSpent,
            oldTotal + 500,
            accuracy: 0.001
        )
    }
}
