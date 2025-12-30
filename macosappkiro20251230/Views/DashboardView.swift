//
//  DashboardView.swift
//  macosappkiro20251230
//
//  Created by 鋒兄 on 2025/12/30.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    Text("儀表板")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("鋒兄Next資訊管理 - 數據直觀與分析")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        if viewModel.isLoading {
                            HStack {
                                ProgressView()
                                    .scaleEffect(0.8)
                                Text("載入中...")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        } else {
                            Button("重新整理") {
                                viewModel.refreshData()
                            }
                            .buttonStyle(.borderless)
                            .foregroundColor(.blue)
                        }
                    }
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
                
                // Stats Cards
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                    StatCard(
                        title: "食品項目",
                        value: "\(viewModel.totalFoodItems)",
                        icon: "cube.fill",
                        color: .blue
                    )
                    StatCard(
                        title: "訂閱服務",
                        value: "\(viewModel.totalSubscriptions)",
                        icon: "calendar",
                        color: .green
                    )
                    StatCard(
                        title: "需要關注",
                        value: "\(viewModel.criticalAlertsCount + viewModel.warningAlertsCount)",
                        icon: "exclamationmark.triangle.fill",
                        color: .orange
                    )
                    StatCard(
                        title: "月費總計",
                        value: viewModel.totalMonthlyAmount,
                        icon: "dollarsign.circle.fill",
                        color: .purple
                    )
                }
                .padding(.horizontal)
                
                // Management Sections
                HStack(alignment: .top, spacing: 20) {
                    // Food Management Stats
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "cube.fill")
                                .foregroundColor(.blue)
                            Text("食品管理統計")
                                .font(.headline)
                        }
                        
                        if let foodStats = viewModel.foodStats {
                            VStack(alignment: .leading, spacing: 12) {
                                StatRow(label: "正常食品", value: "\(foodStats.normalFoods)", color: .green)
                                StatRow(label: "7天內過期", value: "\(foodStats.expiring7Days)", color: .orange)
                                StatRow(label: "30天內過期", value: "\(foodStats.expiring30Days)", color: .yellow)
                                StatRow(label: "已過期", value: "\(foodStats.expired)", color: .red)
                            }
                        } else {
                            VStack(alignment: .leading, spacing: 12) {
                                StatRow(label: "載入中...", value: "-", color: .gray)
                            }
                        }
                        
                        Button("前往食品管理") {
                            // Action - This would be handled by parent view
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                    .padding()
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(12)
                    
                    // Subscription Management Stats
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.green)
                            Text("訂閱管理統計")
                                .font(.headline)
                        }
                        
                        if let subscriptionStats = viewModel.subscriptionStats {
                            VStack(alignment: .leading, spacing: 12) {
                                StatRow(label: "活躍訂閱", value: "\(subscriptionStats.activeSubscriptions)", color: .green)
                                StatRow(label: "3天內到期", value: "\(subscriptionStats.expiring3Days)", color: .red)
                                StatRow(label: "7天內到期", value: "\(subscriptionStats.expiring7Days)", color: .orange)
                                StatRow(label: "已過期", value: "\(subscriptionStats.expired)", color: .red)
                            }
                        } else {
                            VStack(alignment: .leading, spacing: 12) {
                                StatRow(label: "載入中...", value: "-", color: .gray)
                            }
                        }
                        
                        Button("前往訂閱管理") {
                            // Action - This would be handled by parent view
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .tint(.green)
                    }
                    .padding()
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                // Quick Actions
                VStack(alignment: .leading, spacing: 16) {
                    Text("快速操作")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                        QuickActionCard(title: "新增食品", subtitle: "快速添加食品項目", icon: "cube.fill", color: .blue)
                        QuickActionCard(title: "新增訂閱", subtitle: "管理訂閱服務", icon: "calendar", color: .green)
                        QuickActionCard(title: "檢查過期", subtitle: "查看即將過期項目", icon: "exclamationmark.triangle.fill", color: .orange)
                        QuickActionCard(title: "查看報告", subtitle: "詳細統計報告", icon: "chart.bar.fill", color: .purple)
                    }
                    .padding(.horizontal)
                }
                
                // Recent Alerts
                if !viewModel.recentAlerts.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            Text("最新提醒")
                                .font(.headline)
                            
                            Spacer()
                            
                            Text("共 \(viewModel.recentAlerts.count) 項")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(viewModel.recentAlerts.prefix(5)) { alert in
                                AlertRow(alert: alert)
                            }
                        }
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                }
                
                // Contentful Connection Status
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "cloud.fill")
                            .foregroundColor(.blue)
                        Text("Contentful 連線狀態")
                            .font(.headline)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Circle()
                            .fill(viewModel.errorMessage == nil ? Color.green : Color.red)
                            .frame(width: 8, height: 8)
                        
                        Text(viewModel.errorMessage == nil ? "已連線 - 資料同步正常" : "連線異常 - 請檢查網路或 API 設定")
                            .font(.subheadline)
                            .foregroundColor(viewModel.errorMessage == nil ? .green : .red)
                        
                        Spacer()
                        
                        Text("Space ID: navontrqk0l3")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(8)
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            viewModel.loadDashboardData()
        }
    }
}

struct AlertRow: View {
    let alert: DashboardAlert
    
    var body: some View {
        HStack {
            Image(systemName: alert.severity.icon)
                .foregroundColor(alert.severity.color)
                .font(.caption)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(alert.title)
                    .font(.caption)
                    .fontWeight(.semibold)
                
                Text(alert.message)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(formatRelativeTime(alert.createdAt))
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
    
    private func formatRelativeTime(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}