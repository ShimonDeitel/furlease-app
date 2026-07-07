import Foundation

struct LeaseEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: Date = Date()
    var propertyName: String
    var depositAmount: Double

    init(id: UUID = UUID(), date: Date = Date(), propertyName: String, depositAmount: Double) {
        self.id = id
        self.date = date
        self.propertyName = propertyName
        self.depositAmount = depositAmount
    }
}

struct AppSettings: Codable, Equatable {
    var remindersEnabled: Bool = true
    var iCloudSyncEnabled: Bool = false
    var hapticsEnabled: Bool = true
}
