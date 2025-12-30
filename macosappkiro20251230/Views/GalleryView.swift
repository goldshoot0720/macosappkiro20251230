//
//  GalleryView.swift
//  macosappkiro20251230
//
//  Created by 鋒兄 on 2025/12/30.
//

import SwiftUI

struct GalleryView: View {
    @State private var searchText = ""
    
    let sampleImages = [
        "photo", "photo.fill", "camera", "camera.fill",
        "video", "video.fill", "play.rectangle", "play.rectangle.fill",
        "music.note", "headphones", "speaker.wave.2", "airpods"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    LinearGradient(
                        colors: [Color.blue, Color.purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .mask(
                        Text("鋒兄虛擬公開資訊")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    )
                    .frame(height: 40)
                    
                    Spacer()
                    
                    Button("新增圖片") {
                        // Action
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                Text("分享鋒兄 Visual Diary 的 - 高品質 Artworks - 自主設計 Goods - 實用好物 Visual Book")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            // Stats
            HStack(spacing: 20) {
                StatBadge(title: "圖片總數", value: "61", color: .blue)
                StatBadge(title: "2D", value: "2D", color: .green)
                StatBadge(title: "41", value: "41", color: .purple)
            }
            .padding()
            
            // Gallery Grid
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 7), spacing: 16) {
                    ForEach(0..<70, id: \.self) { index in
                        GalleryItem(imageName: sampleImages[index % sampleImages.count])
                    }
                }
                .padding()
            }
        }
        .searchable(text: $searchText, prompt: "搜尋圖片...")
    }
}

struct StatBadge: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
        )
    }
}

struct GalleryItem: View {
    let imageName: String
    
    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 80)
                .overlay(
                    Image(systemName: imageName)
                        .font(.title)
                        .foregroundColor(.gray)
                )
            
            VStack(spacing: 2) {
                Text("圖片標題")
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                Text("描述文字")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
        .onTapGesture {
            // Action
        }
    }
}