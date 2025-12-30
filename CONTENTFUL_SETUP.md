# Contentful 整合設定指南

## 概述

本應用程式已完全整合 Contentful CMS，用於管理訂閱服務和食品資料。以下是詳細的設定和使用說明。

## Contentful 憑證

- **Space ID**: `navontrqk0l3`
- **Content Delivery API Token**: `83Q5hThGBPCIgXAYX7Fc-gSUN-psxg_j-F-gXSskQBc`
- **Content Preview API Token**: `UF4LUIjrAsM0HeNXjEWwL7jrLgIfaP2ID4Vzk_gH-bY`

## 內容模型設定

### 1. 訂閱服務 (Subscription)

在 Contentful 中創建 `subscription` 內容類型，包含以下欄位：

```json
{
  "name": "subscription",
  "displayField": "serviceName",
  "fields": [
    {
      "id": "serviceName",
      "name": "服務名稱",
      "type": "Symbol",
      "required": true
    },
    {
      "id": "serviceUrl",
      "name": "服務網址",
      "type": "Symbol",
      "required": false
    },
    {
      "id": "monthlyAmount",
      "name": "月費金額",
      "type": "Number",
      "required": true
    },
    {
      "id": "currency",
      "name": "貨幣",
      "type": "Symbol",
      "required": true,
      "defaultValue": "TWD"
    },
    {
      "id": "nextPaymentDate",
      "name": "下次付費日期",
      "type": "Date",
      "required": true
    },
    {
      "id": "status",
      "name": "狀態",
      "type": "Symbol",
      "required": true,
      "validations": [
        {
          "in": ["active", "expiring", "expired"]
        }
      ]
    },
    {
      "id": "category",
      "name": "分類",
      "type": "Symbol",
      "required": false
    },
    {
      "id": "description",
      "name": "描述",
      "type": "Text",
      "required": false
    },
    {
      "id": "isActive",
      "name": "是否啟用",
      "type": "Boolean",
      "required": true,
      "defaultValue": true
    }
  ]
}
```

### 2. 食品管理 (Food)

在 Contentful 中創建 `food` 內容類型，包含以下欄位：

```json
{
  "name": "food",
  "displayField": "foodName",
  "fields": [
    {
      "id": "foodName",
      "name": "食品名稱",
      "type": "Symbol",
      "required": true
    },
    {
      "id": "foodCategory",
      "name": "食品分類",
      "type": "Symbol",
      "required": true,
      "validations": [
        {
          "in": ["蛋類", "水果", "乳製品", "肉類", "堅果", "飲料", "零食", "罐頭", "調味料", "麵包", "蛋糕", "其他"]
        }
      ]
    },
    {
      "id": "quantity",
      "name": "數量",
      "type": "Integer",
      "required": true
    },
    {
      "id": "unit",
      "name": "單位",
      "type": "Symbol",
      "required": false
    },
    {
      "id": "expiryDate",
      "name": "過期日期",
      "type": "Date",
      "required": true
    },
    {
      "id": "purchaseDate",
      "name": "購買日期",
      "type": "Date",
      "required": false
    },
    {
      "id": "imageUrl",
      "name": "圖片網址",
      "type": "Symbol",
      "required": false
    },
    {
      "id": "barcode",
      "name": "條碼",
      "type": "Symbol",
      "required": false
    },
    {
      "id": "brand",
      "name": "品牌",
      "type": "Symbol",
      "required": false
    },
    {
      "id": "notes",
      "name": "備註",
      "type": "Text",
      "required": false
    },
    {
      "id": "isConsumed",
      "name": "是否已消耗",
      "type": "Boolean",
      "required": true,
      "defaultValue": false
    }
  ]
}
```

## 範例資料

### 訂閱服務範例

```json
{
  "serviceName": "Netflix Premium",
  "serviceUrl": "https://netflix.com",
  "monthlyAmount": 390,
  "currency": "TWD",
  "nextPaymentDate": "2026-01-15",
  "status": "active",
  "category": "娛樂",
  "description": "影音串流服務",
  "isActive": true
}
```

### 食品範例

```json
{
  "foodName": "有機蘋果",
  "foodCategory": "水果",
  "quantity": 5,
  "unit": "顆",
  "expiryDate": "2026-01-20",
  "purchaseDate": "2026-01-10",
  "imageUrl": "https://example.com/apple.jpg",
  "brand": "有機農場",
  "notes": "新鮮有機蘋果",
  "isConsumed": false
}
```

## 應用程式功能

### 1. 即時數據同步
- 自動從 Contentful 獲取最新資料
- 支援搜尋和篩選功能
- 即時狀態更新

### 2. 智能提醒系統
- 食品過期提醒（7天、30天）
- 訂閱到期提醒（3天、7天）
- 儀表板統計顯示

### 3. 數據統計
- 總計統計
- 分類統計
- 狀態分析

### 4. 搜尋功能
- 全文搜尋
- 分類篩選
- 狀態篩選

## API 使用說明

### 獲取所有訂閱
```
GET https://cdn.contentful.com/spaces/navontrqk0l3/entries?content_type=subscription
Authorization: Bearer 83Q5hThGBPCIgXAYX7Fc-gSUN-psxg_j-F-gXSskQBc
```

### 獲取所有食品
```
GET https://cdn.contentful.com/spaces/navontrqk0l3/entries?content_type=food
Authorization: Bearer 83Q5hThGBPCIgXAYX7Fc-gSUN-psxg_j-F-gXSskQBc
```

### 搜尋功能
```
GET https://cdn.contentful.com/spaces/navontrqk0l3/entries?content_type=food&query=蘋果
```

### 篩選即將過期的食品
```
GET https://cdn.contentful.com/spaces/navontrqk0l3/entries?content_type=food&fields.expiryDate[lte]=2026-01-20&order=fields.expiryDate
```

## 錯誤處理

應用程式包含完整的錯誤處理機制：

1. **網路連線錯誤**: 顯示連線狀態和重試選項
2. **API 錯誤**: 顯示具體錯誤訊息
3. **資料解析錯誤**: 提供預設值和錯誤提示
4. **載入狀態**: 顯示載入指示器

## 開發注意事項

1. **API 限制**: Contentful 有 API 呼叫限制，建議實作快取機制
2. **資料驗證**: 確保 Contentful 中的資料格式正確
3. **日期格式**: 使用 ISO8601 格式 (YYYY-MM-DDTHH:mm:ssZ)
4. **圖片處理**: 支援 Contentful Assets API 或外部圖片 URL

## 部署檢查清單

- [ ] 確認 Contentful Space 已創建
- [ ] 內容模型已正確設定
- [ ] API Token 權限正確
- [ ] 範例資料已添加
- [ ] 應用程式可正常連接 API
- [ ] 所有功能測試通過

---

**注意**: 請妥善保管 API Token，避免在公開程式碼中暴露。