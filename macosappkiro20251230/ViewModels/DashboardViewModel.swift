//
//  DashboardViewModel.swift
//  macosappkiro20251230
//
//  Created by 鋒兄 on 2025/12/30.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var subscriptionStats: SubscriptionStats?
    @Published var foodStats: FoodStats?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var recentAlerts: [DashboardAlert] = []
    
    private let contentfulService = ContentfulService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadDashboardData()
    }
    
    func loadDashboardData() {
        isLoading = true
        errorMessage = nil
        
        let subscriptionStatsPublisher = contentfulService.fetchSubscriptionStats()
        let foodStatsPublisher = contentfulService.fetchFoodStats()
        let alertsPublisher = loadRecentAlerts()
        
        subscriptionStatsPublisher
            .combineLatest(foodStatsPublisher, alertsPublisher)
            .sink(
                receiveCompletion: { [weak self] completion in
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        if case .failure(let error) = completion {
                            self?.errorMessage = "載入儀表板資料失敗: \(error.localizedDescription)"
                        }
                    }
                },
                receiveValue: { [weak self] subscriptionStats, foodStats, alerts in
                    DispatchQueue.main.async {
                        self?.subscriptionStats = subscriptionStats
                        self?.foodStats = foodStats
                        self?.recentAlerts = alerts
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    private func loadRecentAlerts() -> AnyPublisher<[DashboardAlert], Error> {
        let expiringFoodsPublisher = contentfulService.fetchExpiringFoods(days: 7)
        let expiringSubscriptionsPublisher = contentfulService.fetchExpiringSubscriptions(days: 7)
        
        return expiringFoodsPublisher
            .combineLatest(expiringSubscriptionsPublisher)
            .map { expiringFoods, expiringSubscriptions in
                var alerts: [DashboardAlert] = []
                
                // Food alerts
                for food in expiringFoods.prefix(5) {
                    let days = Calendar.current.dateComponents([.day], from: Date(), to: food.expiryDate).day ?? 0
                    if days <= 7 {
                        alerts.append(DashboardAlert(
                            id: "food_\(food.id)",
                            type: .foodExpiring,
                            title: "食品即將過期",
                            message: "\(food.name) 將在 \(days) 天後過期",
                            severity: days <= 3 ? .high : .medium,
                            createdAt: Date()
                        ))
                    }
                }
                
                // Subscription alerts
                for subscription in expiringSubscriptions.prefix(5) {
                    let days = Calendar.current.dateComponents([.day], from: Date(), to: subscription.nextPaymentDate).day ?? 0
                    if days <= 7 {
                        alerts.append(DashboardAlert(
                            id: "subscription_\(subscription.id)",
                            type: .subscriptionExpiring,
                            title: "訂閱即將到期",
                            message: "\(subscription.name) 將在 \(days) 天後到期",
                            severity: days <= 3 ? .high : .medium,
                            createdAt: Date()
                        ))
                    }
                }
                
                return alerts.sorted { $0.createdAt > $1.createdAt }
            }
            .eraseToAnyPublisher()
    }
    
    func refreshData() {
        loadDashboardData()
    }
    
    // MARK: - Computed Properties
    var totalFoodItems: Int {
        foodStats?.totalFoods ?? 0
    }
    
    var totalSubscriptions: Int {
        subscriptionStats?.totalSubscriptions ?? 0
    }
    
    var totalMonthlyAmount: String {
        guard let stats = subscriptionStats else { return "NT$ 0" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "TWD"
        formatter.locale = Locale(identifier: "zh_TW")
        return formatter.string(from: NSNumber(value: stats.totalMonthlyAmount)) ?? "NT$ \(Int(stats.totalMonthlyAmount))"
    }
    
    var criticalAlertsCount: Int {
        recentAlerts.filter { $0.severity == .high }.count
    }
    
    var warningAlertsCount: Int {
        recentAlerts.filter { $0.severity == .medium }.count
    }
}

// MARK: - Supporting Models
struct DashboardAlert: Identifiable {
    let id: String
    let type: AlertType
    let title: String
    let message: String
    let severity: AlertSeverity
    let createdAt: Date
}

enum AlertType {
    case foodExpiring
    case subscriptionExpiring
    case systemNotification
}

enum AlertSeverity {
    case low
    case medium
    case high
    
    var color: Color {
        switch self {
        case .low: return .blue
        case .medium: return .orange
        case .high: return .red
        }
    }
    
    var icon: String {
        switch self {
        case .low: return "info.circle.fill"
        case .medium: return "exclamationmark.triangle.fill"
        case .high: return "exclamationmark.octagon.fill"
        }
    }
}