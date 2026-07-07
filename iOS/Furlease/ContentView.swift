import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingAdd = false
    @State private var showingSettings = false
    @State private var showingPaywall = false
    @State private var editingEntry: LeaseEntry?

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                if store.entries.isEmpty {
                    emptyState
                } else {
                    List {
                        ForEach(store.entries) { entry in
                            entryRow(entry)
                                .listRowBackground(Theme.cardBackground)
                                .contentShape(Rectangle())
                                .onTapGesture { editingEntry = entry }
                        }
                        .onDelete { offsets in store.delete(at: offsets) }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Furlease")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAddMore {
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("addEntryButton")
                }
            }
            .sheet(isPresented: $showingAdd) {
                EntryEditView(entry: nil) { newEntry in
                    store.add(newEntry)
                }
            }
            .sheet(item: $editingEntry) { entry in
                EntryEditView(entry: entry) { updated in
                    store.update(updated)
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
        }
        .tint(Theme.accent)
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 44))
                .foregroundStyle(Theme.textSecondary)
            Text("No lease entries yet")
                .font(Theme.bodyFont)
                .foregroundStyle(Theme.textSecondary)
        }
    }

    private func entryRow(_ entry: LeaseEntry) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(String(describing: entry.propertyName))
                .font(Theme.bodyFont)
                .foregroundStyle(Theme.textPrimary)
            Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                .font(Theme.captionFont)
                .foregroundStyle(Theme.textSecondary)
        }
        .padding(.vertical, 4)
    }
}

struct EntryEditView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var f1Text: String = ""
    @State private var f2Text: String = ""
    var entry: LeaseEntry?
    var onSave: (LeaseEntry) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Lease") {
                    TextField("Propertyname", text: $f1Text)
                        .accessibilityIdentifier("field1TextField")
                    TextField("Depositamount", text: $f2Text)
                        .accessibilityIdentifier("field2TextField")
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                hideKeyboard()
            }
            .navigationTitle(entry == nil ? "Add Lease" : "Edit Lease")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("cancelButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                    }
                    .accessibilityIdentifier("saveEntryButton")
                }
            }
            .onAppear {
                if let entry {
                    f1Text = String(describing: entry.propertyName)
                    f2Text = String(describing: entry.depositAmount)
                }
            }
        }
    }

    private func save() {
        let f1Value: String = f1Text
        let f2Value: Double = Double(f2Text) ?? 0
        let result = LeaseEntry(id: entry?.id ?? UUID(), date: entry?.date ?? Date(), propertyName: f1Value, depositAmount: f2Value)
        onSave(result)
        dismiss()
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
