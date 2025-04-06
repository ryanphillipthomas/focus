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
                default:
                    self.iCloudAvailable = false
                    if let error = error {
                        print("iCloud status error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
