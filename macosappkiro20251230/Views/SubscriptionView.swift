//
//  SubscriptionView.swift
//  macosappkiro20251230
//
//  Created by 鋒兄 on 2025/12/30.
//

import SwiftUI
import AppKit

struct SubscriptionView: View {
    @StateObject private var viewModel = SubscriptionViewModel()
    @State private var showingAddSubscription = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text("訂閱管理")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("總消費")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(viewModel.totalMonthlyAmount)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            
            HStack {
                Text("共 \(viewModel.subscriptions.count) 個訂閱服務")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                }
                
                Button("重新整理") {
                    viewModel.refreshData()
                }
                .buttonStyle(.borderless)
                .foregroundColor(.blue)
            }
            .padding(.horizontal)
            
            // Error Message
            if let errorMessage = viewModel.errorMessage {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal)
            }
            
            // Statistics Cards
            if let stats = viewModel.stats {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        StatCard(
                            title: "總訂閱",
                            value: "\(stats.totalSubscriptions)",
                            icon: "calendar",
                            color: .blue
                        )
                        StatCard(
                            title: "活躍訂閱",
                            value: "\(stats.activeSubscriptions)",
                            icon: "checkmark.circle.fill",
                            color: .green
                        )
                        StatCard(
                            title: "3天內到期",
                            value: "\(stats.expiring3Days)",
                            icon: "clock.fill",
                            color: .red
                        )
                        StatCard(
                            title: "7天內到期",
                            value: "\(stats.expiring7Days)",
                            icon: "exclamationmark.triangle.fill",
                            color: .orange
                        )
                        StatCard(
                            title: "已過期",
                            value: "\(stats.expired)",
                            icon: "xmark.circle.fill",
                            color: .red
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("搜尋訂閱服務...", text: $viewModel.searchText)
                    .textFieldStyle(.plain)
                
                if !viewModel.searchText.isEmpty {
                    Button("清除") {
                        viewModel.searchText = ""
                    }
                    .buttonStyle(.borderless)
                    .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)
            .padding(.horizontal)
            
            // Subscription List
            VStack(alignment: .leading, spacing: 0) {
                // Header Row
                HStack {
                    Text("服務名稱")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("下次付費日期")
                        .font(.headline)
                        .frame(width: 120, alignment: .center)
                    
                    Text("月費")
                        .font(.headline)
                        .frame(width: 100, alignment: .center)
                    
                    Text("狀態")
                        .font(.headline)
                        .frame(width: 80, alignment: .center)
                    
                    Text("操作")
                        .font(.headline)
                        .frame(width: 100, alignment: .center)
                }
                .padding()
                .background(Color(NSColor.controlBackgroundColor))
                
                Divider()
                
                if viewModel.filteredSubscriptions.isEmpty && !viewModel.isLoading {
                    VStack(spacing: 16) {
                        Image(systemName: "calendar.badge.exclamationmark")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        
                        Text(viewModel.searchText.isEmpty ? "尚無訂閱服務" : "找不到符合條件的訂閱")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("請檢查 Contentful 中的訂閱資料")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.filteredSubscriptions) { subscription in
                                ContentfulSubscriptionRow(subscription: subscription, viewModel: viewModel)
                                Divider()
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadSubscriptions()
        }
    }
}

struct ContentfulSubscriptionRow: View {
    let subscription: ContentfulSubscription
    let viewModel: SubscriptionViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(subscription.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                if let category = subscription.category {
                    Text(category)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(4)
                }
                
                HStack {
                    Text(viewModel.getStatusText(for: subscription))
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(viewModel.getStatusColor(for: subscription).opacity(0.2))
                        .foregroundColor(viewModel.getStatusColor(for: subscription))
                        .cornerRadius(4)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(viewModel.formatDate(subscription.nextPaymentDate))
                .font(.subheadline)
                .frame(width: 120, alignment: .center)
            
            Text(viewModel.formatAmount(subscription.amount, currency: subscription.currency))
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(width: 100, alignment: .center)
            
            Circle()
                .fill(subscription.isActive ? Color.green : Color.red)
                .frame(width: 8, height: 8)
                .frame(width: 80, alignment: .center)
            
            HStack(spacing: 4) {
                if let url = subscription.url {
                    Button("網站") {
                        if let websiteURL = URL(string: url) {
                            NSWorkspace.shared.open(websiteURL)
                        }
                    }
                    .buttonStyle(.borderless)
                    .foregroundColor(.blue)
                    .font(.caption)
                }
                
                Button("詳情") {
                    // Show details
                }
                .buttonStyle(.borderless)
                .foregroundColor(.blue)
                .font(.caption)
            }
            .frame(width: 100, alignment: .center)
        }
        .padding()
    }
}

private extension SubscriptionViewModel {
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}