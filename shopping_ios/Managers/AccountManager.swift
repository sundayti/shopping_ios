//
//  AccountManager.swift
//  shopping_ios
//
//  Created by Vladislav Pankratov on 17.06.2025.
//

import Foundation

final class AccountManager {
    static let shared = AccountManager()
    private let defaults = UserDefaults.standard
    private let prefix = "User_"

    var accounts: [UUID] {
        (0..<defaults.integer(forKey: "count")).compactMap { idx in
            defaults.uuid(forKey: "\(prefix)\(idx+1)")
        }
    }

    func add(_ id: UUID) {
        var count = defaults.integer(forKey: "count")
        count += 1
        defaults.set(id, forKey: "\(prefix)\(count)")
        defaults.set(count, forKey: "count")
    }

    func current() -> UUID? {
        accounts.first
    }
}
