//
//  ContentView.swift
//  macosappkiro20251230
//
//  Created by 鋒兄 on 2025/12/30.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: SidebarItem = .dashboard
    
    var body: some View {
        NavigationSplitView {
            SidebarView(selectedTab: $selectedTab)
                .frame(minWidth: 250, maxWidth: 300)
        } detail: {
            MainContentView(selectedTab: selectedTab)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationSplitViewStyle(.balanced)
    }
}

enum SidebarItem: String, CaseIterable {
    case dashboard = "儀表板"
    case gallery = "圖片展示"
    case subscription = "訂閱管理"
    case food = "食品管理"
    case videos = "影片介紹"
    case music = "鋒兄音樂歌詞"
    case about = "關於我們"
    
    var icon: String {
        switch self {
        case .dashboard: return "chart.bar.fill"
        case .gallery: return "photo.fill"
        case .subscription: return "calendar"
        case .food: return "fork.knife"
        case .videos: return "play.rectangle.fill"
        case .music: return "music.note"
        case .about: return "info.circle.fill"
        }
    }
}

struct SidebarView: View {
    @Binding var selectedTab: SidebarItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "cube.fill")
                        .foregroundColor(.white)
                        .font(.title2)
                    Text("鋒兄Next資訊管理")
                        .font(.headline)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
                Text("鋒兄Next資訊管理系統")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [Color.blue, Color.purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            // Navigation Items
            List(SidebarItem.allCases, id: \.self, selection: $selectedTab) { item in
                HStack {
                    Image(systemName: item.icon)
                        .foregroundColor(selectedTab == item ? .white : .primary)
                        .frame(width: 20)
                    Text(item.rawValue)
                        .foregroundColor(selectedTab == item ? .white : .primary)
                        .lineLimit(1)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(
                    selectedTab == item ? 
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.blue) : nil
                )
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .listStyle(SidebarListStyle())
            .scrollContentBackground(.hidden)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.controlBackgroundColor))
    }
}

struct MainContentView: View {
    let selectedTab: SidebarItem
    
    var body: some View {
        Group {
            switch selectedTab {
            case .dashboard:
                DashboardView()
            case .gallery:
                GalleryView()
            case .subscription:
                SubscriptionView()
            case .food:
                FoodManagementView()
            case .videos:
                VideoView()
            case .music:
                MusicView()
            case .about:
                AboutView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.textBackgroundColor))
    }
}

#Preview {
    ContentView()
}
