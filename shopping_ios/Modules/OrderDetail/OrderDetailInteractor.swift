//
//  OrderDetailInteractor.swift
//  shopping_ios
//
//  Created by Vladislav Pankratov on 17.06.2025.
//

import Foundation

protocol OrderDetailInteractable {
    func fetchStatus(orderId: UUID)
    func subscribeStatusUpdates(orderId: UUID)
    func cancelUpdates()
}

final class OrderDetailInteractor: OrderDetailInteractable {
    private let network = NetworkService.shared
    private var wsTask: URLSessionWebSocketTask?
    var presenter: OrderDetailPresentable?
    private let webSocketBase = "wss://sundayti.ru/kpo_3"

    func fetchStatus(orderId: UUID) {
        network.request(
            endpoint: "orders/status/\(orderId.uuidString)",
            method: .get,
            queryItems: nil,
            body: nil
        ) { (result: Result<OrderStatusResponse, NetworkError>) in
            switch result {
            case .success(let resp):
                self.presenter?.didFetchStatus(.success(resp.status))
            case .failure(let error):
                self.presenter?.didFetchStatus(.failure(error))
            }
        }
    }

    func subscribeStatusUpdates(orderId: UUID) {
        let urlString = "\(webSocketBase)/orders/status/\(orderId.uuidString)/ws"
        guard let url = URL(string: urlString) else {
            presenter?.didReceiveUpdate(.failure(.invalidURL))
            return
        }
        wsTask = URLSession.shared.webSocketTask(with: url)
        wsTask?.resume()
        listen()
    }

    private func listen() {
        wsTask?.receive { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(.string(let text)):
                if let data = text.data(using: .utf8),
                   let resp = try? JSONDecoder().decode(OrderStatusResponse.self, from: data) {
                    self.presenter?.didReceiveUpdate(.success(resp.status))
                }
                self.listen()

            case .success(.data):
                self.listen()

            case .failure(let error):
                self.presenter?.didReceiveUpdate(.failure(.unknown(message: error.localizedDescription)))

            @unknown default:
                break
            }
        }
    }

    func cancelUpdates() {
        wsTask?.cancel(with: .goingAway, reason: nil)
    }
}

struct OrderStatusResponse: Decodable {
    let status: OrderStatus
}
