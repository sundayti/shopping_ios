//
//  AccountsView.swift
//  shopping_ios
//
//  Created by Tom Tim on 17.06.2025.
//

import SwiftUI

struct AccountsView: View {
    @StateObject private var presenter: AccountsPresenter
    private let interactor: AccountsInteractable

    init() {
        let presenter = AccountsPresenter()
        let interactor = AccountsInteractor()
        interactor.presenter = presenter
        _presenter = StateObject(wrappedValue: presenter)
        self.interactor = interactor
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                if let error = presenter.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }

                if !presenter.accounts.isEmpty {
                    Picker("Account", selection: $presenter.selectedAccount) {
                        ForEach(presenter.accounts, id: \UUID.self) { id in
                            Text(id.uuidString.prefix(8) + "...")
                                .tag(Optional(id))
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                } else {
                    Text("No accounts. Create one.")
                        .foregroundColor(.gray)
                }

                Button(action: {
                    interactor.createAccount()
                }) {
                    Text("Create New Account")
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Accounts")
            .onAppear {
                interactor.fetchAccounts()
            }
        }
    }
}
