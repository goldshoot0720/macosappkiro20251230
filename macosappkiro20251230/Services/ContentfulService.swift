//
//  ContentfulService.swift
//  macosappkiro20251230
//
//  Created by 鋒兄 on 2025/12/30.
//

import Foundation
import Combine

class ContentfulService: ObservableObject {
    static let shared = ContentfulService()
    
    private let spaceId = "navontrqk0l3"
    private let deliveryToken = "83Q5hThGBPCIgXAYX7Fc-gSUN-psxg_j-F-gXSskQBc"
    private let previewToken = "UF4LUIjrAsM0HeNXjEWwL7jrLgIfaP2ID4Vzk_gH-bY"
    
    private let baseURL = "https://cdn.contentful.com"
    private let previewURL = "https://preview.contentful.com"
    private let managementURL = "https://api.contentful.com"
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {}
    
    // MARK: - Generic Request Methods
    private func makeRequest<T: Codable>(
        url: URL,
        method: HTTPMethod = .GET,
        body: Data? = nil,
        responseType: T.Type,
        usePreview: Bool = false
    ) -> AnyPublisher<T, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("Bearer \(usePreview ? previewToken : deliveryToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            request.httpBody = body
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Subscription Methods
    func fetchSubscriptions(usePreview: Bool = false) -> AnyPublisher<[ContentfulSubscription], Error> {
        let url = URL(string: "\(usePreview ? previewURL : baseURL)/spaces/\(spaceId)/entries?content_type=subscription")!
        
        return makeRequest(
            url: url,
            responseType: ContentfulResponse<ContentfulEntry<SubscriptionFields>>.self,
            usePreview: usePreview
        )
        .map { response in
            response.items.map { ContentfulSubscription(from: $0) }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchSubscription(id: String, usePreview: Bool = false) -> AnyPublisher<ContentfulSubscription, Error> {
        let url = URL(string: "\(usePreview ? previewURL : baseURL)/spaces/\(spaceId)/entries/\(id)")!
        
        return makeRequest(
            url: url,
            responseType: ContentfulEntry<SubscriptionFields>.self,
            usePreview: usePreview
        )
        .map { ContentfulSubscription(from: $0) }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Food Methods
    func fetchFoods(usePreview: Bool = false) -> AnyPublisher<[ContentfulFood], Error> {
        let url = URL(string: "\(usePreview ? previewURL : baseURL)/spaces/\(spaceId)/entries?content_type=food")!
        
        return makeRequest(
            url: url,
            responseType: ContentfulResponse<ContentfulEntry<FoodFields>>.self,
            usePreview: usePreview
        )
        .map { response in
            response.items.map { ContentfulFood(from: $0) }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchFood(id: String, usePreview: Bool = false) -> AnyPublisher<ContentfulFood, Error> {
        let url = URL(string: "\(usePreview ? previewURL : baseURL)/spaces/\(spaceId)/entries/\(id)")!
        
        return makeRequest(
            url: url,
            responseType: ContentfulEntry<FoodFields>.self,
            usePreview: usePreview
        )
        .map { ContentfulFood(from: $0) }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Search Methods
    func searchSubscriptions(query: String, usePreview: Bool = false) -> AnyPublisher<[ContentfulSubscription], Error> {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: "\(usePreview ? previewURL : baseURL)/spaces/\(spaceId)/entries?content_type=subscription&query=\(encodedQuery)")!
        
        return makeRequest(
            url: url,
            responseType: ContentfulResponse<ContentfulEntry<SubscriptionFields>>.self,
            usePreview: usePreview
        )
        .map { response in
            response.items.map { ContentfulSubscription(from: $0) }
        }
        .eraseToAnyPublisher()
    }
    
    func searchFoods(query: String, usePreview: Bool = false) -> AnyPublisher<[ContentfulFood], Error> {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: "\(usePreview ? previewURL : baseURL)/spaces/\(spaceId)/entries?content_type=food&query=\(encodedQuery)")!
        
        return makeRequest(
            url: url,
            responseType: ContentfulResponse<ContentfulEntry<FoodFields>>.self,
            usePreview: usePreview
        )
        .map { response in
            response.items.map { ContentfulFood(from: $0) }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Filter Methods
    func fetchExpiringFoods(days: Int = 7, usePreview: Bool = false) -> AnyPublisher<[ContentfulFood], Error> {
        let calendar = Calendar.current
        let endDate = calendar.date(byAdding: .day, value: days, to: Date()) ?? Date()
        let formatter = ISO8601DateFormatter()
        let endDateString = formatter.string(from: endDate)
        
        let url = URL(string: "\(usePreview ? previewURL : baseURL)/spaces/\(spaceId)/entries?content_type=food&fields.expiryDate[lte]=\(endDateString)&order=fields.expiryDate")!
        
        return makeRequest(
            url: url,
            responseType: ContentfulResponse<ContentfulEntry<FoodFields>>.self,
            usePreview: usePreview
        )
        .map { response in
            response.items.map { ContentfulFood(from: $0) }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchExpiringSubscriptions(days: Int = 7, usePreview: Bool = false) -> AnyPublisher<[ContentfulSubscription], Error> {
        let calendar = Calendar.current
        let endDate = calendar.date(byAdding: .day, value: days, to: Date()) ?? Date()
        let formatter = ISO8601DateFormatter()
        let endDateString = formatter.string(from: endDate)
        
        let url = URL(string: "\(usePreview ? previewURL : baseURL)/spaces/\(spaceId)/entries?content_type=subscription&fields.nextPaymentDate[lte]=\(endDateString)&order=fields.nextPaymentDate")!
        
        return makeRequest(
            url: url,
            responseType: ContentfulResponse<ContentfulEntry<SubscriptionFields>>.self,
            usePreview: usePreview
        )
        .map { response in
            response.items.map { ContentfulSubscription(from: $0) }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Statistics Methods
    func fetchSubscriptionStats(usePreview: Bool = false) -> AnyPublisher<SubscriptionStats, Error> {
        return fetchSubscriptions(usePreview: usePreview)
            .map { subscriptions in
                let activeSubscriptions = subscriptions.filter { $0.isActive }
                let totalAmount = activeSubscriptions.reduce(0) { $0 + $1.amount }
                
                let calendar = Calendar.current
                let now = Date()
                
                let expiring3Days = activeSubscriptions.filter { subscription in
                    let days = calendar.dateComponents([.day], from: now, to: subscription.nextPaymentDate).day ?? 0
                    return days >= 0 && days <= 3
                }
                
                let expiring7Days = activeSubscriptions.filter { subscription in
                    let days = calendar.dateComponents([.day], from: now, to: subscription.nextPaymentDate).day ?? 0
                    return days >= 0 && days <= 7
                }
                
                let expired = activeSubscriptions.filter { subscription in
                    subscription.nextPaymentDate < now
                }
                
                return SubscriptionStats(
                    totalSubscriptions: subscriptions.count,
                    activeSubscriptions: activeSubscriptions.count,
                    totalMonthlyAmount: totalAmount,
                    expiring3Days: expiring3Days.count,
                    expiring7Days: expiring7Days.count,
                    expired: expired.count
                )
            }
            .eraseToAnyPublisher()
    }
    
    func fetchFoodStats(usePreview: Bool = false) -> AnyPublisher<FoodStats, Error> {
        return fetchFoods(usePreview: usePreview)
            .map { foods in
                let activeFoods = foods.filter { !$0.isConsumed }
                
                let calendar = Calendar.current
                let now = Date()
                
                let expiring7Days = activeFoods.filter { food in
                    let days = calendar.dateComponents([.day], from: now, to: food.expiryDate).day ?? 0
                    return days >= 0 && days <= 7
                }
                
                let expiring30Days = activeFoods.filter { food in
                    let days = calendar.dateComponents([.day], from: now, to: food.expiryDate).day ?? 0
                    return days >= 0 && days <= 30
                }
                
                let expired = activeFoods.filter { food in
                    food.expiryDate < now
                }
                
                let normal = activeFoods.filter { food in
                    let days = calendar.dateComponents([.day], from: now, to: food.expiryDate).day ?? 0
                    return days > 30
                }
                
                return FoodStats(
                    totalFoods: foods.count,
                    activeFoods: activeFoods.count,
                    normalFoods: normal.count,
                    expiring7Days: expiring7Days.count,
                    expiring30Days: expiring30Days.count,
                    expired: expired.count
                )
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Supporting Types
enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

struct SubscriptionStats {
    let totalSubscriptions: Int
    let activeSubscriptions: Int
    let totalMonthlyAmount: Double
    let expiring3Days: Int
    let expiring7Days: Int
    let expired: Int
}

struct FoodStats {
    let totalFoods: Int
    let activeFoods: Int
    let normalFoods: Int
    let expiring7Days: Int
    let expiring30Days: Int
    let expired: Int
}