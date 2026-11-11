
import SwiftUI

// MARK: - APP

@main
struct Lab4BApp: App {

    @Environment(\.scenePhase) private var scenePhase

    init() {
        print("App: Application launched")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onChange(of: scenePhase) { newPhase in
                    switch newPhase {
                    case .active:
                        print("Scene: Active")
                    case .inactive:
                        print("Scene: Inactive")
                    case .background:
                        print("Scene: Background")
                    @unknown default:
                        print("Scene: Unknown")
                    }
                }
        }
    }
}

// MARK: - HOME SCREEN

struct ContentView: View {

    @State private var refreshCount = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {

                Text("App Lifecycle Demo")
                    .font(.largeTitle.bold())

                Image(systemName: "iphone")
                    .font(.system(size: 70))
                    .foregroundColor(.blue)

                Text("Home Screen")
                    .font(.title2.bold())

                Text("Refresh Count: \(refreshCount)")
                    .font(.headline)

                Button("Refresh Data") {
                    refreshData()
                }
                .buttonStyle(.borderedProminent)

                NavigationLink("Go to Second Screen") {
                    SecondScreen()
                }
                .buttonStyle(.bordered)

            }
            .padding()
            .onAppear {
                print("Home Screen: onAppear")
                refreshData()
            }
            .onDisappear {
                print("Home Screen: onDisappear")
            }
            .navigationTitle("Home")
        }
    }

    // Lightweight refresh action
    func refreshData() {
        refreshCount += 1
        print("Home Screen: Data refreshed")
    }
}

// MARK: - SECOND SCREEN

struct SecondScreen: View {

    var body: some View {
        VStack(spacing: 25) {

            Image(systemName: "rectangle.stack")
                .font(.system(size: 70))
                .foregroundColor(.green)

            Text("Second Screen")
                .font(.largeTitle.bold())

            Text("Observe lifecycle events")
                .font(.headline)

            Text("Go back to see the Home screen appear again.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)

        }
        .padding()
        .navigationTitle("Second Screen")
        .onAppear {
            print("Second Screen: onAppear")
        }
        .onDisappear {
            print("Second Screen: onDisappear")
        }
    }
}
