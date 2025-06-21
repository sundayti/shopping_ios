//
//  shopping_iosApp.swift
//  shopping_ios
//
//  Created by Vladislav Pankratov on 17.06.2025.
//

import SwiftUI

@main
struct shopping_iosApp: App {
    @StateObject private var accountVM = AccountsPresenter()

    init() {
        // При старте фетчим существующие аккаунты
        let inter = AccountsInteractor()
        inter.presenter = accountVM
        inter.fetchAccounts()
    }

    var body: some Scene {
        WindowGroup {
            if let current = accountVM.selectedAccount {
                MainTabView(currentAccount: current)
                    .environmentObject(accountVM)
            } else {
                AccountsView()
            }
        }
    }
}

struct MainTabView: View {
    let currentAccount: UUID
    @EnvironmentObject var accountVM: AccountsPresenter

    var body: some View {
        TabView(selection: $accountVM.selectedAccount) {
            AccountsView()
                .tabItem { Label("Accounts", systemImage: "person.circle") }
                .tag(accountVM.selectedAccount)

            OrdersListView(accountId: currentAccount)
                .tabItem { Label("Orders", systemImage: "list.bullet") }
                .tag(currentAccount)

            BalanceView(userId: currentAccount)
                .tabItem { Label("Balance", systemImage: "creditcard") }
                .tag(currentAccount)
        }
    }
}
