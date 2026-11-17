
import SwiftUI

// MARK: - Configuration Model
struct AuditItem: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let category: String
    let icon: String
}

// MARK: - Main View
struct ContentView: View {

    @State private var completedItems: Set<String> = []
    @State private var selectedTab = "Audit"
    @State private var showResetAlert = false

    let items = [
        AuditItem(
            title: "Product Name",
            detail: "Verify the application product name.",
            category: "General",
            icon: "app"
        ),
        AuditItem(
            title: "Bundle Identifier",
            detail: "Check the unique application identifier.",
            category: "General",
            icon: "number"
        ),
        AuditItem(
            title: "Version and Build",
            detail: "Verify version 1.0 and build number 1.",
            category: "General",
            icon: "tag"
        ),
        AuditItem(
            title: "Deployment Target",
            detail: "Check minimum supported iOS version.",
            category: "General",
            icon: "iphone"
        ),
        AuditItem(
            title: "Supported Orientations",
            detail: "Inspect portrait and landscape settings.",
            category: "General",
            icon: "rotate"
        ),
        AuditItem(
            title: "Code Signing",
            detail: "Inspect signing team and certificate.",
            category: "Signing",
            icon: "signature"
        ),
        AuditItem(
            title: "Info Settings",
            detail: "Review app metadata and privacy descriptions.",
            category: "Privacy",
            icon: "info.circle"
        ),
        AuditItem(
            title: "Privacy Permissions",
            detail: "Ensure only necessary permissions are requested.",
            category: "Privacy",
            icon: "lock.shield"
        ),
        AuditItem(
            title: "Debug Configuration",
            detail: "Inspect debugging and optimization settings.",
            category: "Build",
            icon: "hammer"
        ),
        AuditItem(
            title: "Release Configuration",
            detail: "Inspect production build settings.",
            category: "Build",
            icon: "shippingbox"
        )
    ]

    var progress: Double {
        Double(completedItems.count) / Double(items.count)
    }

    var percentage: Int {
        Int(progress * 100)
    }

    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {

                auditScreen
                    .tabItem {
                        Label("Audit", systemImage: "checklist")
                    }
                    .tag("Audit")

                settingsScreen
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
                    .tag("Settings")

                aboutScreen
                    .tabItem {
                        Label("About", systemImage: "info.circle")
                    }
                    .tag("About")
            }
            .tint(.blue)
        }
        .alert("Reset Checklist?", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                completedItems.removeAll()
            }
        } message: {
            Text("All completed checklist items will be cleared.")
        }
    }

    // MARK: - Audit Screen
    var auditScreen: some View {
        VStack(spacing: 15) {

            VStack(spacing: 8) {
                Image(systemName: "checkmark.shield.fill")
                    .font(.system(size: 45))
                    .foregroundColor(.blue)

                Text("Project Configuration Audit")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Review your application settings")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 15)

            // Progress Card
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Audit Progress")
                        .fontWeight(.semibold)

                    Spacer()

                    Text("\(percentage)%")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }

                ProgressView(value: progress)
                    .tint(.blue)

                Text("\(completedItems.count) of \(items.count) tasks completed")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.blue.opacity(0.08))
            .cornerRadius(15)
            .padding(.horizontal)

            // Checklist
            List {
                ForEach(items) { item in
                    Button {
                        toggleItem(item.title)
                    } label: {
                        HStack(spacing: 12) {

                            Image(systemName: item.icon)
                                .font(.title3)
                                .foregroundColor(.blue)
                                .frame(width: 30)

                            VStack(alignment: .leading, spacing: 5) {
                                Text(item.title)
                                    .font(.headline)
                                    .foregroundColor(.primary)

                                Text(item.detail)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)

                                Text(item.category)
                                    .font(.caption2)
                                    .foregroundColor(.blue)
                            }

                            Spacer()

                            Image(systemName:
                                completedItems.contains(item.title)
                                ? "checkmark.circle.fill"
                                : "circle"
                            )
                            .font(.title2)
                            .foregroundColor(
                                completedItems.contains(item.title)
                                ? .green : .gray
                            )
                        }
                        .padding(.vertical, 5)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .listStyle(.insetGrouped)

            Button(role: .destructive) {
                showResetAlert = true
            } label: {
                Label("Reset Checklist", systemImage: "arrow.counterclockwise")
            }
            .padding(.bottom, 8)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Audit Checklist")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Toggle Checklist
    func toggleItem(_ title: String) {
        if completedItems.contains(title) {
            completedItems.remove(title)
        } else {
            completedItems.insert(title)
        }
    }

    // MARK: - Settings Screen
    var settingsScreen: some View {
        List {

            Section("General Settings") {
                settingRow("Product Name", value: "ConfigurationAudit")
                settingRow("Bundle ID", value: "com.yourname.ConfigurationAudit")
                settingRow("Version", value: "1.0")
                settingRow("Build Number", value: "1")
                settingRow("Deployment Target", value: "iOS 17.0")
                settingRow("Device", value: "iPhone")
                settingRow("Orientation", value: "Portrait / Landscape")
            }

            Section("Signing & Capabilities") {
                settingRow("Automatic Signing", value: "Enabled")
                settingRow("Development Team", value: "Configure in Xcode")
                settingRow("Certificate", value: "Xcode Managed")
            }

            Section("Privacy") {
                settingRow("Camera Access", value: "Not Required")
                settingRow("Location Access", value: "Not Required")
                settingRow("Photo Library", value: "Not Required")
            }

            Section("Build Configurations") {
                settingRow("Debug", value: "Development")
                settingRow("Release", value: "Production")
            }
        }
        .navigationTitle("App Settings")
    }

    // MARK: - Reusable Setting Row
    func settingRow(_ title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.trailing)
        }
    }

    // MARK: - About Screen
    var aboutScreen: some View {
        ScrollView {
            VStack(spacing: 20) {

                Image(systemName: "iphone.gen3")
                    .font(.system(size: 65))
                    .foregroundColor(.blue)
                    .padding(25)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(20)

                Text("Configuration Audit")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Lab 9 – Project Configuration Audit")
                    .font(.headline)
                    .foregroundColor(.secondary)

                Text("This application helps developers understand and inspect common Xcode project settings, application metadata, signing configuration, privacy requirements and build configurations.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)

                Divider()

                VStack(alignment: .leading, spacing: 12) {
                    Label("SwiftUI Interface", systemImage: "swift")
                    Label("Configuration Checklist", systemImage: "checklist")
                    Label("Progress Tracking", systemImage: "chart.bar")
                    Label("No Sensitive Permissions", systemImage: "lock.shield")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(15)

                Text("Version 1.0 | Build 1")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .navigationTitle("About")
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
