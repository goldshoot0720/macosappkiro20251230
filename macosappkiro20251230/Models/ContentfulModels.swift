//
//  ContentfulModels.swift
//  macosappkiro20251230
//
//  Created by 鋒兄 on 2025/12/30.
//

import Foundation
import SwiftUI

// MARK: - Contentful Base Models
struct ContentfulResponse<T: Codable>: Codable {
    let sys: ContentfulSys
    let total: Int
    let skip: Int
    let limit: Int
    let items: [T]
}

struct ContentfulSys: Codable {
    let type: String
    let id: String?
    let createdAt: String?
    let updatedAt: String?
    let revision: Int?
}

struct ContentfulEntry<T: Codable>: Codable {
    let sys: ContentfulSys
    let fields: T
}

// MARK: - Subscription Models
struct SubscriptionFields: Codable {
    let name: String
    let url: String?
    let amount: Double
    let currency: String
    let nextPaymentDate: String
    let status: String
    let category: String?
    let description: String?
    let isActive: Bool
    
    enum CodingKeys: String, CodingKey {
        case name = "serviceName"
        case url = "serviceUrl"
        case amount = "monthlyAmount"
        case currency
        case nextPaymentDate
        case status
        case category
        case description
        case isActive
    }
}

enum ContentfulSubscriptionStatus {
    case active
    case expiring
    case expired
    
    var color: Color {
        switch self {
        case .active: return .green
        case .expiring: return .orange
        case .expired: return .red
        }
    }
    
    var text: String {
        switch self {
        case .active: return "正常"
        case .expiring: return "即將到期"
        case .expired: return "已過期"
        }
    }
}

struct ContentfulSubscription: Identifiable {
    let id: String
    let name: String
    let url: String?
    let amount: Double
    let currency: String
    let nextPaymentDate: Date
    let status: ContentfulSubscriptionStatus
    let category: String?
    let description: String?
    let isActive: Bool
    let createdAt: Date
    let updatedAt: Date
    
    init(from entry: ContentfulEntry<SubscriptionFields>) {
        self.id = entry.sys.id ?? UUID().uuidString
        self.name = entry.fields.name
        self.url = entry.fields.url
        self.amount = entry.fields.amount
        self.currency = entry.fields.currency
        self.category = entry.fields.category
        self.description = entry.fields.description
        self.isActive = entry.fields.isActive
        
        // Parse date
        let formatter = ISO8601DateFormatter()
        self.nextPaymentDate = formatter.date(from: entry.fields.nextPaymentDate) ?? Date()
        self.createdAt = formatter.date(from: entry.sys.createdAt ?? "") ?? Date()
        self.updatedAt = formatter.date(from: entry.sys.updatedAt ?? "") ?? Date()
        
        // Parse status
        switch entry.fields.status.lowercased() {
        case "active":
            self.status = .active
        case "expiring":
            self.status = .expiring
        case "expired":
            self.status = .expired
        default:
            self.status = .active
        }
    }
}

// MARK: - Food Models
struct FoodFields: Codable {
    let name: String
    let category: String
    let quantity: Int
    let unit: String?
    let expiryDate: String
    let purchaseDate: String?
    let imageUrl: String?
    let barcode: String?
    let brand: String?
    let notes: String?
    let isConsumed: Bool
    
    enum CodingKeys: String, CodingKey {
        case name = "foodName"
        case category = "foodCategory"
        case quantity
        case unit
        case expiryDate
        case purchaseDate
        case imageUrl
        case barcode
        case brand
        case notes
        case isConsumed
    }
}

struct ContentfulFood: Identifiable {
    let id: String
    let name: String
    let category: String
    let quantity: Int
    let unit: String?
    let expiryDate: Date
    let purchaseDate: Date?
    let imageUrl: String?
    let barcode: String?
    let brand: String?
    let notes: String?
    let isConsumed: Bool
    let createdAt: Date
    let updatedAt: Date
    
    init(from entry: ContentfulEntry<FoodFields>) {
        self.id = entry.sys.id ?? UUID().uuidString
        self.name = entry.fields.name
        self.category = entry.fields.category
        self.quantity = entry.fields.quantity
        self.unit = entry.fields.unit
        self.imageUrl = entry.fields.imageUrl
        self.barcode = entry.fields.barcode
        self.brand = entry.fields.brand
        self.notes = entry.fields.notes
        self.isConsumed = entry.fields.isConsumed
        
        // Parse dates
        let formatter = ISO8601DateFormatter()
        self.expiryDate = formatter.date(from: entry.fields.expiryDate) ?? Date()
        self.purchaseDate = entry.fields.purchaseDate != nil ? formatter.date(from: entry.fields.purchaseDate!) : nil
        self.createdAt = formatter.date(from: entry.sys.createdAt ?? "") ?? Date()
        self.updatedAt = formatter.date(from: entry.sys.updatedAt ?? "") ?? Date()
    }
}

// MARK: - Create/Update Models
struct CreateSubscriptionRequest {
    let fields: SubscriptionFields
}

struct CreateFoodRequest {
    let fields: FoodFields
}

struct UpdateSubscriptionRequest {
    let fields: SubscriptionFields
}

struct UpdateFoodRequest {
    let fields: FoodFields
}