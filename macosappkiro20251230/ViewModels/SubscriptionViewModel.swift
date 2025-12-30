//
//  SubscriptionViewModel.swift
//  macosappkiro20251230
//
//  Created by 鋒兄 on 2025/12/30.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class SubscriptionViewModel: ObservableObject {
    @Published var subscriptions: [ContentfulSubscription] = []
    @Published var stats: SubscriptionStats?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    
    private let contentfulService = ContentfulService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSearchBinding()
        loadSubscriptions()
    }
    
    private func setupSearchBinding() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                if searchText.isEmpty {
                    self?.loadSubscriptions()
                } else {
                    self?.searchSubscriptions(query: searchText)
                }
            }
            .store(in: &cancellables)
    }
    
    func loadSubscriptions() {
        isLoading = true
        errorMessage = nil
        
        let subscriptionsPublisher = contentfulService.fetchSubscriptions()
        let statsPublisher = contentfulService.fetchSubscriptionStats()
        
        subscriptionsPublisher
            .combineLatest(statsPublisher)
            .sink(
                receiveCompletion: { [weak self] completion in
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        if case .failure(let error) = completion {
                            self?.errorMessage = "載入訂閱資料失敗: \(error.localizedDescription)"
                        }
                    }
                },
                receiveValue: { [weak self] subscriptions, stats in
                    DispatchQueue.main.async {
                        self?.subscriptions = subscriptions
                        self?.stats = stats
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func searchSubscriptions(query: String) {
        isLoading = true
        errorMessage = nil
        
        contentfulService.searchSubscriptions(query: query)
            .sink(
                receiveCompletion: { [weak self] completion in
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        if case .failure(let error) = completion {
                            self?.errorMessage = "搜尋失敗: \(error.localizedDescription)"
                        }
                    }
                },
                receiveValue: { [weak self] subscriptions in
                    DispatchQueue.main.async {
                        self?.subscriptions = subscriptions
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func refreshData() {
        loadSubscriptions()
    }
    
    // MARK: - Helper Methods
    func formatAmount(_ amount: Double, currency: String = "TWD") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        formatter.locale = Locale(identifier: "zh_TW")
        return formatter.string(from: NSNumber(value: amount)) ?? "NT$ \(Int(amount))"
    }
    
    func getDaysUntilPayment(from date: Date) -> Int {
        Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
    }
    
    func getStatusColor(for subscription: ContentfulSubscription) -> Color {
        let days = getDaysUntilPayment(from: subscription.nextPaymentDate)
        
        if days < 0 {
            return .red
        } else if days <= 3 {
            return .red
        } else if days <= 7 {
            return .orange
        } else {
            return .green
        }
    }
    
    func getStatusText(for subscription: ContentfulSubscription) -> String {
        let days = getDaysUntilPayment(from: subscription.nextPaymentDate)
        
        if days < 0 {
            return "已過期"
        } else if days == 0 {
            return "今天到期"
        } else if days <= 3 {
            return "\(days) 天後"
        } else if days <= 7 {
            return "\(days) 天後"
        } else {
            return "\(days) 天後"
        }
    }
    
    var filteredSubscriptions: [ContentfulSubscription] {
        if searchText.isEmpty {
            return subscriptions
        } else {
            return subscriptions.filter { subscription in
                subscription.name.localizedCaseInsensitiveContains(searchText) ||
                subscription.category?.localizedCaseInsensitiveContains(searchText) == true
            }
        }
    }
    
    var totalMonthlyAmount: String {
        let total = subscriptions.filter { $0.isActive }.reduce(0) { $0 + $1.amount }
        return formatAmount(total)
    }
}