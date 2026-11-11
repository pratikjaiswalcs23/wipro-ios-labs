
import SwiftUI
import Combine

final class UnsafeCounter {
    var count = 0

    func increment() {
        count += 1
    }
}

actor SafeCounter {
    private var count = 0

    func increment() {
        count += 1
    }

    func getCount() -> Int {
        return count
    }
}

@MainActor
class CounterViewModel: ObservableObject {
    @Published var unsafeResult = 0
    @Published var safeResult = 0
    @Published var status = "Choose an operation"
    @Published var isLoading = false

    func runUnsafe() {
        guard !isLoading else { return }

        isLoading = true
        status = "Running unsafe counter..."

        DispatchQueue.global().async {
            let counter = UnsafeCounter()

            DispatchQueue.concurrentPerform(iterations: 10000) { _ in
                counter.increment()
            }

            let result = counter.count

            DispatchQueue.main.async {
                self.unsafeResult = result
                self.status = "Unsafe counter completed"
                self.isLoading = false
            }
        }
    }

    func runSafe() {
        guard !isLoading else { return }

        isLoading = true
        status = "Running safe actor counter..."

        Task {
            let counter = SafeCounter()

            await withTaskGroup(of: Void.self) { group in
                for _ in 0..<10000 {
                    group.addTask {
                        await counter.increment()
                    }
                }
            }

            let result = await counter.getCount()

            safeResult = result
            status = "Safe counter completed"
            isLoading = false
        }
    }

    func reset() {
        guard !isLoading else { return }

        unsafeResult = 0
        safeResult = 0
        status = "Counter reset successfully"
    }
}

struct ContentView: View {
    @StateObject private var viewModel = CounterViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 25) {

                Text("Concurrency Safety")
                    .font(.largeTitle)
                    .bold()

                Text("Data Race vs Actor")
                    .font(.headline)
                    .foregroundColor(.secondary)

                VStack(spacing: 12) {
                    Text("Unsafe Counter")
                        .font(.title2)
                        .bold()

                    Text("\(viewModel.unsafeResult)")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.red)

                    Text("Expected Result: 10000")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(15)

                VStack(spacing: 12) {
                    Text("Safe Counter (Actor)")
                        .font(.title2)
                        .bold()

                    Text("\(viewModel.safeResult)")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.green)

                    Text("Expected Result: 10000")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(15)

                Button("Run Unsafe Counter") {
                    viewModel.runUnsafe()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .disabled(viewModel.isLoading)

                Button("Run Safe Counter") {
                    viewModel.runSafe()
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .disabled(viewModel.isLoading)

                Button("Reset") {
                    viewModel.reset()
                }
                .buttonStyle(.bordered)
                .disabled(viewModel.isLoading)

                if viewModel.isLoading {
                    ProgressView()
                }

                Text(viewModel.status)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

                Spacer()
            }
            .padding()
            .navigationTitle("Lab 5D")
        }
    }
}

@main
struct Lab5DApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
