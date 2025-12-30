//
//  FoodViewModel.swift
//  macosappkiro20251230
//
//  Created by 鋒兄 on 2025/12/30.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class FoodViewModel: ObservableObject {
    @Published var foods: [ContentfulFood] = []
    @Published var stats: FoodStats?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var selectedCategory = "全部"
    
    private let contentfulService = ContentfulService.shared
    private var cancellables = Set<AnyCancellable>()
    
    let categories = ["全部", "蛋類", "水果", "乳製品", "肉類", "堅果", "飲料", "零食", "罐頭", "調味料", "麵包", "蛋糕", "其他"]
    
    init() {
        setupSearchBinding()
        loadFoods()
    }
    
    private func setupSearchBinding() {
        let searchTextPublisher = $searchText
        let categoryPublisher = $selectedCategory
        
        searchTextPublisher
            .combineLatest(categoryPublisher)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates { $0.0 == $1.0 && $0.1 == $1.1 }
            .sink { [weak self] searchText, category in
                if searchText.isEmpty && category == "全部" {
                    self?.loadFoods()
                } else {
                    self?.filterFoods()
                }
            }
            .store(in: &cancellables)
    }
    
    func loadFoods() {
        isLoading = true
        errorMessage = nil
        
        let foodsPublisher = contentfulService.fetchFoods()
        let statsPublisher = contentfulService.fetchFoodStats()
        
        foodsPublisher
            .combineLatest(statsPublisher)
            .sink(
                receiveCompletion: { [weak self] completion in
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        if case .failure(let error) = completion {
                            self?.errorMessage = "載入食品資料失敗: \(error.localizedDescription)"
                        }
                    }
                },
                receiveValue: { [weak self] foods, stats in
                    DispatchQueue.main.async {
                        self?.foods = foods
                        self?.stats = stats
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func searchFoods(query: String) {
        isLoading = true
        errorMessage = nil
        
        contentfulService.searchFoods(query: query)
            .sink(
                receiveCompletion: { [weak self] completion in
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        if case .failure(let error) = completion {
                            self?.errorMessage = "搜尋失敗: \(error.localizedDescription)"
                        }
                    }
                },
                receiveValue: { [weak self] foods in
                    DispatchQueue.main.async {
                        self?.foods = foods
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func filterFoods() {
        var filtered = foods
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { food in
                food.name.localizedCaseInsensitiveContains(searchText) ||
                food.category.localizedCaseInsensitiveContains(searchText) ||
                food.brand?.localizedCaseInsensitiveContains(searchText) == true
            }
        }
        
        // Filter by category
        if selectedCategory != "全部" {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        foods = filtered
    }
    
    func loadExpiringFoods(days: Int = 7) {
        isLoading = true
        errorMessage = nil
        
        contentfulService.fetchExpiringFoods(days: days)
            .sink(
                receiveCompletion: { [weak self] completion in
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        if case .failure(let error) = completion {
                            self?.errorMessage = "載入即將過期食品失敗: \(error.localizedDescription)"
                        }
                    }
                },
                receiveValue: { [weak self] foods in
                    DispatchQueue.main.async {
                        self?.foods = foods
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func refreshData() {
        loadFoods()
    }
    
    // MARK: - Helper Methods
    func getDaysUntilExpiry(from date: Date) -> Int {
        Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
    }
    
    func getExpiryStatusColor(for food: ContentfulFood) -> Color {
        let days = getDaysUntilExpiry(from: food.expiryDate)
        
        if days < 0 {
            return .red
        } else if days <= 7 {
            return .orange
        } else if days <= 30 {
            return .yellow
        } else {
            return .green
        }
    }
    
    func getExpiryStatusText(for food: ContentfulFood) -> String {
        let days = getDaysUntilExpiry(from: food.expiryDate)
        
        if days < 0 {
            return "已過期"
        } else if days == 0 {
            return "今天過期"
        } else if days <= 7 {
            return "\(days) 天後過期"
        } else if days <= 30 {
            return "\(days) 天後過期"
        } else {
            return "\(days) 天後過期"
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "zh_TW")
        return formatter.string(from: date)
    }
    
    var filteredFoods: [ContentfulFood] {
        var filtered = foods
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { food in
                food.name.localizedCaseInsensitiveContains(searchText) ||
                food.category.localizedCaseInsensitiveContains(searchText) ||
                food.brand?.localizedCaseInsensitiveContains(searchText) == true
            }
        }
        
        // Filter by category
        if selectedCategory != "全部" {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        return filtered.sorted { $0.expiryDate < $1.expiryDate }
    }
    
    var activeFoods: [ContentfulFood] {
        foods.filter { !$0.isConsumed }
    }
    
    var expiringFoods: [ContentfulFood] {
        let calendar = Calendar.current
        let now = Date()
        
        return activeFoods.filter { food in
            let days = calendar.dateComponents([.day], from: now, to: food.expiryDate).day ?? 0
            return days >= 0 && days <= 7
        }
    }
    
    var expiredFoods: [ContentfulFood] {
        activeFoods.filter { $0.expiryDate < Date() }
    }
}