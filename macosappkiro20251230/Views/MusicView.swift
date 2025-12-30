//
//  MusicView.swift
//  macosappkiro20251230
//
//  Created by 鋒兄 on 2025/12/30.
//

import SwiftUI

struct MusicView: View {
    @State private var searchText = ""
    
    let songs = [
        Song(title: "遠到水電王子憶紅", artist: "鋒兄 & 虛哥", album: "鋒兄音樂精選", languages: ["中", "EN", "日", "韓"]),
        Song(title: "史上最酷婚禮理由", artist: "鋒兄 & 虛哥", album: "鋒兄音樂精選", languages: ["中", "EN", "日", "韓"]),
        Song(title: "鋒兄進化Show🔥", artist: "鋒兄 feat. 虛哥", album: "鋒兄音樂精選", languages: ["中", "EN", "日", "韓"])
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Image(systemName: "music.note")
                    .font(.title)
                    .foregroundColor(.purple)
                
                Text("鋒兄音樂歌詞")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button("新增歌曲") {
                    // Action
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            
            Text("收藏和管理您最愛的歌曲歌詞")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            // Search Bar
            VStack(alignment: .leading, spacing: 12) {
                Text("歌曲庫")
                    .font(.headline)
                    .padding(.horizontal)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("搜尋歌曲、歌手或專輯...", text: $searchText)
                        .textFieldStyle(.plain)
                }
                .padding()
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(8)
                .padding(.horizontal)
            }
            .padding(.vertical)
            
            // Song List
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(songs) { song in
                        SongCard(song: song)
                    }
                }
                .padding()
            }
            
            // Empty State (when no song is selected)
            if songs.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "music.note")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                    
                    Text("選擇一首歌曲")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("從左側列表中選擇歌曲來查看歌詞")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(NSColor.textBackgroundColor))
            }
        }
    }
}

struct Song: Identifiable {
    let id = UUID()
    let title: String
    let artist: String
    let album: String
    let languages: [String]
}

struct SongCard: View {
    let song: Song
    @State private var isLiked = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Album Art Placeholder
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        colors: [Color.purple, Color.blue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "music.note")
                        .foregroundColor(.white)
                        .font(.title2)
                )
            
            // Song Info
            VStack(alignment: .leading, spacing: 4) {
                Text(song.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Text(song.artist)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Text(song.album)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                // Language Tags
                HStack(spacing: 4) {
                    ForEach(song.languages, id: \.self) { language in
                        Text(language)
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.2))
                            .foregroundColor(.blue)
                            .cornerRadius(4)
                    }
                }
            }
            
            Spacer()
            
            // Action Buttons
            VStack(spacing: 8) {
                Button(action: {
                    isLiked.toggle()
                }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? .red : .secondary)
                        .font(.title3)
                }
                .buttonStyle(.plain)
                
                Button("查看歌詞") {
                    // Action
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .onTapGesture {
            // Select song action
        }
    }
}