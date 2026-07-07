import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Preferences") {
                    Toggle("Reminders", isOn: Binding(
                        get: { store.settings.remindersEnabled },
                        set: { store.settings.remindersEnabled = $0; store.save() }
                    ))
                    .accessibilityIdentifier("remindersToggle")
                    Toggle("iCloud Sync", isOn: Binding(
                        get: { store.settings.iCloudSyncEnabled },
                        set: { store.settings.iCloudSyncEnabled = $0; store.save() }
                    ))
                    .accessibilityIdentifier("iCloudSyncToggle")
                    Toggle("Haptics", isOn: Binding(
                        get: { store.settings.hapticsEnabled },
                        set: { store.settings.hapticsEnabled = $0; store.save() }
                    ))
                    .accessibilityIdentifier("hapticsToggle")
                }
                Section("Furlease Pro") {
                    Button("Restore Purchases") {
                        Task { await purchases.restore() }
                    }
                    .accessibilityIdentifier("restorePurchasesButton")
                }
                Section("Legal") {
                    Link("Privacy Policy", destination: URL(string: "https://shimondeitel.github.io/furlease-app/privacy.html")!)
                    Link("Terms of Use", destination: URL(string: "https://shimondeitel.github.io/furlease-app/terms.html")!)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .accessibilityIdentifier("settingsDoneButton")
                }
            }
        }
    }
}
