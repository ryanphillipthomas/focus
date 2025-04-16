//
//  iCloudStatusManager.swift
//  Focus
//
//  Created by Ryan Thomas on 4/6/25.
//


import Foundation
import CloudKit

class iCloudStatusManager: ObservableObject {
    @Published var iCloudAvailable: Bool = false

    init() {
        checkiCloudStatus()
    }

    func checkiCloudStatus() {
        CKContainer.default().accountStatus { status, error in
            DispatchQueue.main.async {
                switch status {
                case .available:
                    self.iCloudAvailable = true
                    InAppLogStore.shared.append("iCloud is available.", for: "iCloud", type: .icloud)
                case .noAccount:
                    self.iCloudAvailable = false
                    InAppLogStore.shared.append("iCloud unavailable: No iCloud account.", for: "iCloud", type: .icloud)
                case .restricted:
                    self.iCloudAvailable = false
                    InAppLogStore.shared.append("iCloud unavailable: Access is restricted.", for: "iCloud", type: .icloud)
                case .couldNotDetermine:
                    self.iCloudAvailable = false
                    InAppLogStore.shared.append("iCloud unavailable: Could not determine status.", for: "iCloud", type: .icloud)
                case .temporarilyUnavailable:
                    self.iCloudAvailable = false
                    InAppLogStore.shared.append("iCloud teporarily unavailable: Could not determine status.", for: "iCloud", type: .icloud)
                @unknown default:
                    self.iCloudAvailable = false
                    InAppLogStore.shared.append("iCloud unavailable: Unknown error.", for: "iCloud", type: .icloud)
                }

                if let error = error {
                    InAppLogStore.shared.append("iCloud status error: \(error.localizedDescription)", for: "iCloud", type: .icloud)
                }
            }
        }
    }
}

