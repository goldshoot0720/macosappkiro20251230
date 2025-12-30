# 鋒兄Next資訊管理系統

一個基於 SwiftUI 的 macOS 綜合管理應用程式，整合 Contentful CMS，提供多種實用的管理功能。

## 🚀 功能特色

### 🏠 儀表板
- 系統概覽和統計數據
- 即時 Contentful 數據同步
- 智能提醒和警告系統
- 快速操作面板

### � 訂圖閱管理 (Contentful 整合)
- 訂閱服務追蹤和管理
- 自動到期提醒 (3天、7天)
- 費用統計和分析
- 搜尋和篩選功能

### 🍎 食品管理 (Contentful 整合)
- 食品庫存管理
- 智能過期日期追蹤
- 分類管理和數量控制
- 圖片支援和條碼管理

### 🖼️ 圖片展示
- 圖片庫管理和瀏覽
- 支援多種格式
- 搜尋和分類功能

### 🎬 影片介紹
- 影片播放和管理
- 本地快取功能
- 儲存空間管理

### 🎵 音樂歌詞
- 歌曲庫管理
- 多語言歌詞支援
- 收藏和搜尋功能

### ℹ️ 關於我們
- 公司資訊和團隊介紹
- 聯絡方式和服務特色

## 🔧 技術特色

- **Contentful CMS 整合**: 完整的內容管理系統整合
- **即時數據同步**: 自動從 Contentful 獲取最新資料
- **智能提醒系統**: 食品過期和訂閱到期自動提醒
- **響應式設計**: 適配不同螢幕尺寸
- **MVVM 架構**: 清晰的代碼結構和狀態管理
- **現代化 UI**: 使用 SwiftUI 最新特性

## 📋 系統要求

- macOS 13.0 或更高版本
- Xcode 14.0 或更高版本
- Swift 5.0 或更高版本
- 網路連接 (Contentful API)

## 🛠️ 安裝說明

1. 克隆此專案到本地
```bash
git clone https://github.com/goldshoot0720/macosappkiro20251230.git
cd macosappkiro20251230
```

2. 使用 Xcode 開啟專案
```bash
open macosappkiro20251230.xcodeproj
```

3. 配置 Contentful (參考 `CONTENTFUL_SETUP.md`)

4. 選擇目標設備並運行

## 📁 專案結構

```
macosappkiro20251230/
├── macosappkiro20251230App.swift    # 應用程式入口
├── ContentView.swift                # 主視圖和導航
├── Models/                         # 資料模型
│   └── ContentfulModels.swift      # Contentful 資料結構
├── Services/                       # 服務層
│   └── ContentfulService.swift     # Contentful API 服務
├── ViewModels/                     # 視圖模型 (MVVM)
│   ├── DashboardViewModel.swift    # 儀表板邏輯
│   ├── SubscriptionViewModel.swift # 訂閱管理邏輯
│   └── FoodViewModel.swift         # 食品管理邏輯
├── Views/                          # 視圖層
│   ├── SharedComponents.swift      # 共享 UI 組件
│   ├── DashboardView.swift         # 儀表板
│   ├── SubscriptionView.swift      # 訂閱管理
│   ├── FoodManagementView.swift    # 食品管理
│   ├── GalleryView.swift           # 圖片展示
│   ├── VideoView.swift             # 影片介紹
│   ├── MusicView.swift             # 音樂歌詞
│   └── AboutView.swift             # 關於我們
└── Assets.xcassets/                # 資源文件
```

## 📚 文檔

- `CONTENTFUL_SETUP.md` - Contentful 設定指南
- `USAGE.md` - 使用說明
- `BUILD_TROUBLESHOOTING.md` - 編譯問題排除
- `ERROR_FIXES.md` - 錯誤修復記錄

## 🌟 主要功能

### Contentful 整合
- 完整的 API 整合和錯誤處理
- 即時數據同步和快取
- 搜尋和篩選功能
- 統計分析和報告

### 智能管理
- 自動過期提醒
- 狀態追蹤和分析
- 分類管理
- 圖片和多媒體支援

## 👥 開發團隊

**鋒兄途哥公開資訊有限公司**
- 技術總監：鋒兄
- 營運專家：途哥

## 📊 版本資訊

- 版本：v3.0.0 (Contentful 整合版)
- 技術棧：SwiftUI + Contentful CMS + Combine
- 開發地點：台灣 🇹🇼

## 📄 授權

© 2025 鋒兄途哥公開資訊有限公司 版權所有

---

Made with ❤️ in Taiwan
