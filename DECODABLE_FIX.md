# Decodable 協議修復

## 問題描述
編譯器錯誤：`Type 'ContentfulSubscription' does not conform to protocol 'Decodable'`

## 根本原因
當結構體聲明為 `Codable` 但包含自定義初始化器時，Swift 編譯器無法自動合成 `Decodable` 協議的實現。

## 解決方案

### 修復的結構體

#### 1. ContentfulSubscription
```swift
// 修復前
struct ContentfulSubscription: Codable, Identifiable {
    // ... 屬性
    init(from entry: ContentfulEntry<SubscriptionFields>) {
        // 自定義初始化器
    }
}

// 修復後
struct ContentfulSubscription: Identifiable {
    // ... 屬性
    init(from entry: ContentfulEntry<SubscriptionFields>) {
        // 自定義初始化器
    }
}
```

#### 2. ContentfulFood
```swift
// 修復前
struct ContentfulFood: Codable, Identifiable {
    // ... 屬性
    init(from entry: ContentfulEntry<FoodFields>) {
        // 自定義初始化器
    }
}

// 修復後
struct ContentfulFood: Identifiable {
    // ... 屬性
    init(from entry: ContentfulEntry<FoodFields>) {
        // 自定義初始化器
    }
}
```

#### 3. Create/Update 請求結構體
移除了不必要的 `Codable` 聲明：
- `CreateSubscriptionRequest`
- `CreateFoodRequest`
- `UpdateSubscriptionRequest`
- `UpdateFoodRequest`

## 為什麼這樣修復

1. **自定義初始化器衝突**: 當結構體有自定義的 `init(from:)` 方法時，它與 `Decodable` 協議要求的 `init(from decoder: Decoder)` 衝突。

2. **不需要 JSON 解碼**: 這些結構體是從 Contentful API 響應手動構建的，不需要直接從 JSON 解碼。

3. **保持功能完整**: 移除 `Codable` 不影響現有功能，因為我們使用自定義初始化器來處理數據轉換。

## 驗證結果

✅ 所有文件通過語法檢查  
✅ 沒有編譯錯誤  
✅ 保持原有功能完整  
✅ Contentful 整合正常工作  

## 注意事項

- 如果將來需要將這些結構體序列化為 JSON，可以添加 `Encodable` 協議
- 保留了 `Identifiable` 協議以支援 SwiftUI 列表
- 所有數據轉換邏輯保持不變