//
//  VideoView.swift
//  macosappkiro20251230
//
//  Created by 鋒兄 on 2025/12/30.
//

import SwiftUI

struct VideoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("影片介紹")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("感受鋒兄影片內容，支援本地快速讀取少流量使用")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Featured Videos
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2), spacing: 20) {
                    VideoCard(
                        title: "鋒兄的傳奇人生",
                        description: "一個關於愛結婚學習的影片內容故事，展現了鋒兄平凡卻不凡的人生歷程。",
                        duration: "15:32",
                        thumbnail: "play.rectangle.fill"
                    )
                    
                    VideoCard(
                        title: "鋒兄進化Show🔥",
                        description: "展現鋒兄的成長歷程與學習，綻放的進化成長軌跡，與眾不同。",
                        duration: "12:45",
                        thumbnail: "play.rectangle.fill"
                    )
                }
                .padding(.horizontal)
                
                // Storage Management
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("快取管理")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button("清空快取") {
                            // Action
                        }
                        .buttonStyle(.borderless)
                        .foregroundColor(.red)
                    }
                    .padding(.horizontal)
                    
                    // Storage Stats
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 4), spacing: 16) {
                        StorageCard(title: "已快取影片", value: "0", color: .blue)
                        StorageCard(title: "下載中", value: "0", color: .green)
                        StorageCard(title: "總影片數", value: "2", color: .purple)
                        StorageCard(title: "合快取大小", value: "0 B", color: .orange)
                    }
                    .padding(.horizontal)
                    
                    // Storage Usage Bar
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("快取使用量")
                                .font(.subheadline)
                            Spacer()
                            Text("0 B / 500 MB")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        ProgressView(value: 0.0, total: 1.0)
                            .progressViewStyle(LinearProgressViewStyle())
                        
                        Text("0% 已使用")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    
                    // Notice
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.blue)
                            .font(.caption)
                        
                        Text("提示：快取影片可離線觀看以減少網路流量使用，但會佔用儲存空間。系統會自動清理過期的影片。")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct VideoCard: View {
    let title: String
    let description: String
    let duration: String
    let thumbnail: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Video Thumbnail
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [Color.blue, Color.purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .aspectRatio(16/9, contentMode: .fit)
                .overlay(
                    VStack {
                        Image(systemName: "play.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            Text(duration)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.black.opacity(0.6))
                                .cornerRadius(4)
                                .padding(8)
                        }
                    }
                )
            
            // Video Info
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            // Action Buttons
            HStack(spacing: 8) {
                Button("播放影片") {
                    // Play action
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.regular)
                
                Button("快取") {
                    // Cache action
                }
                .buttonStyle(.bordered)
                .controlSize(.regular)
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .frame(maxWidth: .infinity)
    }
}

struct StorageCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
        .frame(maxWidth: .infinity)
    }
}