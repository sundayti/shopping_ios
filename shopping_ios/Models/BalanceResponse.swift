//
//  BalanceResponse.swift
//  shopping_ios
//
//  Created by Vladislav Pankratov on 20.06.2025.
//

import Foundation

struct BalanceResponse: Decodable {
    let balance: Decimal

    private enum CodingKeys: String, CodingKey {
        case balance
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let balanceString = try container.decode(String.self, forKey: .balance)
        guard let decimal = Decimal(string: balanceString) else {
            throw DecodingError.dataCorruptedError(forKey: .balance, in: container, debugDescription: "Invalid decimal string")
        }
        balance = decimal
    }
}
