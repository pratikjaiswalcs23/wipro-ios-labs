
import SwiftUI

// MARK: - Model

struct PerformanceItem: Identifiable {
    let id: Int
    let title: String
    let value: Int
}

// MARK: - Performance View Model

@MainActor
final class PerformanceViewModel: ObservableObject {

    @Published var items: [PerformanceItem] = []
    @Published var optimizedMode = false
    @Published var isLoading = false

    func generateItems() {
        isLoading = true

        DispatchQueue.global(qos: .userInitiated).async {
            let generated = (1...5000).map { index in
                PerformanceItem(
                    id: index,
                    title: "Performance Item \(index)",
                    value: index * 10
                )
            }

            DispatchQueue.main.async {
                self.items = generated
                self.isLoading = false
            }
        }
    }

    func clearItems() {
        items.removeAll()
    }

    // Deliberately expensive calculation for baseline mode
    func expensiveCalculation(_ number: Int) -> Int {
        var result = 0

        for i in 0..<1000 {
            result += (number * i) % 97
        }

        return result
    }
}

// MARK: - Main UI

struct ContentView: View {

    @StateObject private var viewModel = PerformanceViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {

                Text("Instruments Performance Lab")
                    .font(.title2)
                    .bold()

                Toggle(
                    "Optimized Mode",
                    isOn: $viewModel.optimizedMode
                )
                .accessibilityIdentifier("optimizedToggle")
                .padding(.horizontal)

                HStack {
                    Button("Generate 5000 Items") {
                        viewModel.generateItems()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Clear") {
                        viewModel.clearItems()
                    }
                    .buttonStyle(.bordered)
                }

                Text("Total Items: \(viewModel.items.count)")
                    .font(.headline)

                if viewModel.isLoading {
                    ProgressView("Generating items...")
                }

                List(viewModel.items) { item in
                    if viewModel.optimizedMode {
                        OptimizedRow(item: item)
                    } else {
                        BaselineRow(
                            item: item,
                            calculation: viewModel.expensiveCalculation(
                                item.value
                            )
                        )
                    }
                }
                .accessibilityIdentifier("performanceList")
            }
            .padding(.top)
            .navigationTitle("Lab 11")
        }
    }
}

// MARK: - Baseline Row

struct BaselineRow: View {

    let item: PerformanceItem
    let calculation: Int

    var body: some View {
        VStack(alignment: .leading) {
            Text(item.title)
                .font(.headline)

            Text("Value: \(item.value)")
                .font(.subheadline)

            Text("Calculation: \(calculation)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 5)
    }
}

// MARK: - Optimized Row

struct OptimizedRow: View {

    let item: PerformanceItem

    var body: some View {
        VStack(alignment: .leading) {
            Text(item.title)
                .font(.headline)

            Text("Value: \(item.value)")
                .font(.subheadline)
        }
        .padding(.vertical, 5)
    }
}
