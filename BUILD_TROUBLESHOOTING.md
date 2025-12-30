# 編譯問題排除指南

## 已修復的問題

### 1. 降低 macOS 部署目標
- 從 `15.7` 降低到 `13.0` 以提高兼容性

### 2. 移除重複的組件定義
- 創建了 `SharedComponents.swift` 文件
- 移除了 `DashboardView.swift` 中重複的 `StatCard`、`StatRow`、`QuickActionCard` 定義

### 3. 添加必要的框架導入
- 在 `SubscriptionView.swift` 中添加了 `import AppKit` 以支援 `NSWorkspace`

### 4. 修復 Combine 語法問題
- 所有 `Publishers.CombineLatest` 已修復為正確的實例方法語法

## 可能的編譯問題和解決方案

### 問題 1: Xcode 版本兼容性
**症狀**: 編譯失敗，提示不支援某些 Swift 功能
**解決方案**: 
- 確保使用 Xcode 14.0 或更高版本
- 檢查 Swift 版本設定

### 問題 2: 文件系統同步問題
**症狀**: 新文件未被 Xcode 識別
**解決方案**:
1. 在 Xcode 中右鍵點擊項目
2. 選擇 "Add Files to [ProjectName]"
3. 手動添加以下文件：
   - `Models/ContentfulModels.swift`
   - `Services/ContentfulService.swift`
   - `ViewModels/DashboardViewModel.swift`
   - `ViewModels/SubscriptionViewModel.swift`
   - `ViewModels/FoodViewModel.swift`
   - `Views/SharedComponents.swift`

### 問題 3: 網路權限問題
**症狀**: Contentful API 呼叫失敗
**解決方案**:
1. 檢查 App Sandbox 設定
2. 確保啟用 "Outgoing Connections (Client)"
3. 在項目設定中添加網路權限

### 問題 4: @MainActor 相關問題
**症狀**: 編譯器警告或錯誤關於 MainActor
**解決方案**:
- 確保所有 UI 更新都在主線程執行
- 檢查 ViewModel 中的 `@MainActor` 標註

## 編譯步驟

### 1. 清理項目
```bash
# 在 Xcode 中
Product -> Clean Build Folder (Cmd+Shift+K)
```

### 2. 重新編譯
```bash
# 在 Xcode 中
Product -> Build (Cmd+B)
```

### 3. 如果仍有問題，嘗試重置
```bash
# 刪除 DerivedData
rm -rf ~/Library/Developer/Xcode/DerivedData
```

## 檢查清單

- [ ] 所有 Swift 文件都在 Xcode 項目中
- [ ] 部署目標設為 macOS 13.0 或更高
- [ ] 所有必要的框架已導入 (SwiftUI, Combine, AppKit)
- [ ] 沒有重複的類型定義
- [ ] Contentful 憑證正確設定
- [ ] 網路權限已啟用

## 常見錯誤訊息

### "Cannot find type 'StatCard' in scope"
**解決方案**: 確保 `SharedComponents.swift` 已添加到項目中

### "Cannot find 'NSWorkspace' in scope"
**解決方案**: 在相關文件中添加 `import AppKit`

### "Publishers.CombineLatest3 is not available"
**解決方案**: 已修復，使用 `.combineLatest()` 實例方法

### "Minimum deployment target is 15.0"
**解決方案**: 已修復，降低到 macOS 13.0

## 如果問題持續存在

1. 檢查 Xcode 控制台的具體錯誤訊息
2. 確保所有依賴都正確安裝
3. 嘗試創建新的 Xcode 項目並逐步添加文件
4. 檢查系統 Swift 版本: `swift --version`

## 聯絡支援

如果問題仍然存在，請提供：
- 具體的錯誤訊息
- Xcode 版本
- macOS 版本
- 編譯日誌