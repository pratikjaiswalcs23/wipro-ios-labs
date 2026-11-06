
import Foundation

// Lab 1B: Bank Account

public class BankAccount {

    // Private: Cannot be accessed directly outside this class
    private var balance: Double

    public let accountHolder: String

    // Read-only balance for external callers
    public var currentBalance: Double {
        return balance
    }

    // Read-only transaction history
    public private(set) var transactions: [String] = []

    // Public initializer with validation
    public init?(accountHolder: String, openingBalance: Double) {

        if accountHolder.trimmingCharacters(in: .whitespaces).isEmpty {
            return nil
        }

        if !openingBalance.isFinite || openingBalance < 0 {
            return nil
        }

        self.accountHolder = accountHolder
        self.balance = openingBalance

        transactions.append("Account opened: \(openingBalance)")
    }

    // Public deposit method
    public func deposit(amount: Double) -> Bool {

        guard amount.isFinite && amount > 0 else {
            print("Invalid deposit amount")
            return false
        }

        guard (balance + amount).isFinite else {
            print("Deposit amount is too large")
            return false
        }

        balance += amount

        transactions.append("Deposited: \(amount)")

        print("Deposit successful: \(amount)")
        return true
    }

    // Public withdraw method
    public func withdraw(amount: Double) -> Bool {

        guard amount.isFinite && amount > 0 else {
            print("Invalid withdrawal amount")
            return false
        }

        guard amount <= balance else {
            print("Insufficient balance")
            return false
        }

        balance -= amount

        transactions.append("Withdrawn: \(amount)")

        print("Withdrawal successful: \(amount)")
        return true
    }

    public func displayBalance() {
        print("Account Holder: \(accountHolder)")
        print("Current Balance: \(balance)")
    }
}

// Fileprivate: Accessible only within this source file
fileprivate func formatAmount(_ amount: Double) -> String {
    return String(format: "%.2f", amount)
}

// Internal: Accessible within the same module
func showAccountMessage() {
    print("Welcome to Bank Account Management System")
}

