//
//  BalanceView.swift
//  shopping_ios
//
//  Created by Vladislav Pankratov on 20.06.2025.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
struct BalanceView: View {
    @StateObject private var presenter = BalancePresenter()
    private let interactor: BalanceInteractable
    private let userId: UUID
    @State private var topUpAmount: String = ""

    init(userId: UUID) {
        self.userId = userId
        let inter = BalanceInteractor()
        inter.presenter = presenter
        self.interactor = inter
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let error = presenter.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }
                Text("Balance: \(presenter.balanceText)")
                    .font(.largeTitle)

                HStack {
                    TextField("Amount", text: $topUpAmount)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Top Up") {
                        if let amount = Decimal(string: topUpAmount) {
                            interactor.topUp(userId: userId, amount: amount)
                        }
                    }
                }
                .padding()

                Spacer()
            }
            .padding()
            .navigationTitle("Balance")
            .onAppear {
                interactor.fetchBalance(for: userId)
            }
        }
    }
}
