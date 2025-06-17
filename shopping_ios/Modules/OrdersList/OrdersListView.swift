//
//  OrdersListView.swift
//  shopping_ios
//
//  Created by Vladislav Pankratov on 17.06.2025.
//

import SwiftUI

struct OrdersListView: View {
    @StateObject private var presenter = OrdersListPresenter()
    private let interactor: OrdersListInteractable
    private let accountId: UUID

    init(accountId: UUID) {
        self.accountId = accountId
        let inter = OrdersListInteractor()
        inter.presenter = presenter
        self.interactor = inter
    }

    var body: some View {
        NavigationView {
            Group {
                if let error = presenter.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                } else {
                    List(presenter.orders) { order in
                        NavigationLink(
                            destination: OrderDetailView(order: order)
                        ) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(order.description)
                                    .font(.headline)
                                Text("Amount: \(order.amount.description)")
                                    .font(.subheadline)
                                Text(order.status.rawValue)
                                    .font(.caption)
                                    .foregroundColor(color(for: order.status))
                            }
                        }
                    }
                }
            }
            .navigationTitle("Orders")
            .onAppear {
                interactor.fetchOrders(for: accountId)
            }
        }
    }

    private func color(for status: OrderStatus) -> Color {
        switch status {
        case .New: return .orange
        case .Finished: return .green
        case .Cancelled: return .red
        }
    }
}
