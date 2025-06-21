//
//  BalanceView.swift
//  shopping_ios
//
//  Created by Vladislav Pankratov on 17.06.2025.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
struct BalanceView: View {
    @StateObject private var presenter: BalancePresenter
    private let interactor: BalanceInteractable
    private let userId: UUID
    @State private var topUpAmount: String = ""

    init(userId: UUID) {
        self.userId = userId
        let presenter = BalancePresenter()
        let interactor = BalanceInteractor()
        interactor.presenter = presenter
        _presenter = StateObject(wrappedValue: presenter)
        self.interactor = interactor
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
                      #if os(iOS)
                      .keyboardType(UIKeyboardType.decimalPad)
                      #endif
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
