import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published private(set) var entries: [LeaseEntry] = []
    @Published var settings: AppSettings
    @Published var isPro: Bool = false

    static let freeLimit = 40

    private let entriesURL: URL
    private let settingsURL: URL

    init() {
        let supportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: supportDir, withIntermediateDirectories: true)
        entriesURL = supportDir.appendingPathComponent("furlease_entries.json")
        settingsURL = supportDir.appendingPathComponent("furlease_settings.json")
        settings = AppSettings()
        load()
        if entries.isEmpty {
            entries = Store.seedData()
            save()
        }
    }

    static func seedData() -> [LeaseEntry] {
        [
        LeaseEntry(date: Calendar.current.date(byAdding: .day, value: -0, to: Date()) ?? Date(), propertyName: "Lease 1", depositAmount: 3.25),
        LeaseEntry(date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(), propertyName: "Lease 2", depositAmount: 6.50),
        LeaseEntry(date: Calendar.current.date(byAdding: .day, value: -6, to: Date()) ?? Date(), propertyName: "Lease 3", depositAmount: 9.75),
        LeaseEntry(date: Calendar.current.date(byAdding: .day, value: -9, to: Date()) ?? Date(), propertyName: "Lease 4", depositAmount: 13.00)
        ]
    }

    var canAddMore: Bool {
        isPro || entries.count < Store.freeLimit
    }

    func add(_ entry: LeaseEntry) {
        guard canAddMore else { return }
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: LeaseEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: LeaseEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: entriesURL),
           let decoded = try? JSONDecoder().decode([LeaseEntry].self, from: data) {
            entries = decoded
        }
        if let data = try? Data(contentsOf: settingsURL),
           let decoded = try? JSONDecoder().decode(AppSettings.self, from: data) {
            settings = decoded
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(entries) {
            try? data.write(to: entriesURL, options: .atomic)
        }
        if let data = try? JSONEncoder().encode(settings) {
            try? data.write(to: settingsURL, options: .atomic)
        }
    }
}
