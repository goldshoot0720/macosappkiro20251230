//
//  FoodManagementView.swift
//  macosappkiro20251230
//
//  Created by 鋒兄 on 2025/12/30.
//

import SwiftUI

struct FoodManagementView: View {
    @StateObject private var viewModel = FoodViewModel()
    @State private var showingAddFood = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text("食品管理")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                HStack(spacing: 12) {
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                    }
                    
                    Button("重新整理") {
                        viewModel.refreshData()
                    }
                    .buttonStyle(.borderless)
                    .foregroundColor(.blue)
                    
                    Button("新增同步") {
                        // Action for syncing with Contentful
                    }
                    .buttonStyle(.borderless)
                    .foregroundColor(.blue)
                }
            }
            .padding()
            
            HStack {
                Text("共 \(viewModel.foods.count) 項食品")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if let stats = viewModel.stats {
                    Text("活躍: \(stats.activeFoods) | 即將過期: \(stats.expiring7Days) | 已過期: \(stats.expired)")
                        .font(.caption)
                        .foregroundColor(.secondary)
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
            
            // Statistics Cards
            if let stats = viewModel.stats {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        StatCard(
                            title: "總食品",
                            value: "\(stats.totalFoods)",
                            icon: "cube.fill",
                            color: .blue
                        )
                        StatCard(
                            title: "正常食品",
                            value: "\(stats.normalFoods)",
                            icon: "checkmark.circle.fill",
                            color: .green
                        )
                        StatCard(
                            title: "7天內過期",
                            value: "\(stats.expiring7Days)",
                            icon: "clock.fill",
                            color: .orange
                        )
                        StatCard(
                            title: "30天內過期",
                            value: "\(stats.expiring30Days)",
                            icon: "exclamationmark.triangle.fill",
                            color: .yellow
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
            
            // Search and Filter
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("搜尋食品名稱、品牌或分類...", text: $viewModel.searchText)
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
                
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.categories, id: \.self) { category in
                            Button(category) {
                                viewModel.selectedCategory = category
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                            .foregroundColor(viewModel.selectedCategory == category ? .white : .primary)
                            .background(
                                viewModel.selectedCategory == category ?
                                RoundedRectangle(cornerRadius: 6).fill(Color.blue) : nil
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.horizontal)
            
            // Quick Actions
            HStack(spacing: 12) {
                Button("顯示即將過期") {
                    viewModel.loadExpiringFoods(days: 7)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                
                Button("顯示已過期") {
                    viewModel.loadExpiringFoods(days: 0)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                
                Button("顯示全部") {
                    viewModel.loadFoods()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                
                Spacer()
            }
            .padding(.horizontal)
            
            // Food List
            VStack(alignment: .leading, spacing: 0) {
                // Header Row
                HStack {
                    Text("名稱")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("分類")
                        .font(.headline)
                        .frame(width: 80, alignment: .center)
                    
                    Text("有效期限")
                        .font(.headline)
                        .frame(width: 100, alignment: .center)
                    
                    Text("數量")
                        .font(.headline)
                        .frame(width: 60, alignment: .center)
                    
                    Text("狀態")
                        .font(.headline)
                        .frame(width: 80, alignment: .center)
                    
                    Text("圖片")
                        .font(.headline)
                        .frame(width: 60, alignment: .center)
                }
                .padding()
                .background(Color(NSColor.controlBackgroundColor))
                
                Divider()
                
                if viewModel.filteredFoods.isEmpty && !viewModel.isLoading {
                    VStack(spacing: 16) {
                        Image(systemName: "cube.transparent")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        
                        Text(viewModel.searchText.isEmpty ? "尚無食品資料" : "找不到符合條件的食品")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("請檢查 Contentful 中的食品資料")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.filteredFoods) { food in
                                ContentfulFoodRow(food: food, viewModel: viewModel)
                                Divider()
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadFoods()
        }
    }
}

struct ContentfulFoodRow: View {
    let food: ContentfulFood
    let viewModel: FoodViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(food.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                
                if let brand = food.brand {
                    Text(brand)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text(viewModel.getExpiryStatusText(for: food))
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(viewModel.getExpiryStatusColor(for: food).opacity(0.2))
                        .foregroundColor(viewModel.getExpiryStatusColor(for: food))
                        .cornerRadius(4)
                    
                    if food.isConsumed {
                        Text("已消耗")
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.gray)
                            .cornerRadius(4)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(food.category)
                .font(.caption)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.blue.opacity(0.2))
                .foregroundColor(.blue)
                .cornerRadius(4)
                .frame(width: 80, alignment: .center)
            
            Text(viewModel.formatDate(food.expiryDate))
                .font(.subheadline)
                .frame(width: 100, alignment: .center)
            
            HStack {
                Text("\(food.quantity)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                if let unit = food.unit {
                    Text(unit)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 60, alignment: .center)
            
            Circle()
                .fill(food.isConsumed ? Color.gray : viewModel.getExpiryStatusColor(for: food))
                .frame(width: 8, height: 8)
                .frame(width: 80, alignment: .center)
            
            // Food Image
            Group {
                if let imageUrl = food.imageUrl, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                ProgressView()
                                    .scaleEffect(0.5)
                            )
                    }
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                } else {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                                .font(.caption)
                        )
                }
            }
            .frame(width: 60, alignment: .center)
        }
        .padding()
        .opacity(food.isConsumed ? 0.6 : 1.0)
    }
}