//
//  AboutView.swift
//  macosappkiro20251230
//
//  Created by 鋒兄 on 2025/12/30.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 16) {
                    Text("關於我們")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("了解鋒兄Next資訊管理的使命與願景")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                // Company Logo and Name
                VStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [Color.blue, Color.purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                        .overlay(
                            Text("鋒途")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                    
                    Text("鋒兄途哥公開資訊")
                        .font(.title)
                        .fontWeight(.bold)
                }
                
                // Mission Statement
                VStack(alignment: .leading, spacing: 16) {
                    Text("我們是專業的公開團隊，致力於為管理提供優質的公開服務和智慧管理解決方案。")
                        .font(.body)
                        .multilineTextAlignment(.center)
                    
                    Text("透過創新技術和專業服務，幫助企業和個人實現更高效的管理目標。")
                        .font(.body)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 40)
                
                // Service Cards
                HStack(spacing: 20) {
                    ServiceCard(
                        icon: "person.2.fill",
                        title: "鋒兄",
                        subtitle: "技術總監 & 創新領袖",
                        description: "專精於系統架構設計和技術創新，致力於打造用戶友好的管理解決方案。",
                        color: .blue
                    )
                    
                    ServiceCard(
                        icon: "star.fill",
                        title: "途哥",
                        subtitle: "公開營運 & 策略專家",
                        description: "擁有豐富的營運管理經驗，專注於提升企業營運效率和用戶體驗。",
                        color: .purple
                    )
                }
                .padding(.horizontal)
                
                // Features
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 20) {
                        FeatureCard(
                            icon: "cube.transparent",
                            title: "智能管理",
                            description: "運用先進技術智能管理各類資源，提升工作效率。",
                            color: .green
                        )
                        
                        FeatureCard(
                            icon: "chart.bar.fill",
                            title: "數據洞察",
                            description: "可視化分析，提供深度洞察和決策支援。",
                            color: .orange
                        )
                    }
                    
                    HStack(spacing: 20) {
                        FeatureCard(
                            icon: "clock.fill",
                            title: "專業服務",
                            description: "24/7 專業服務支援，確保產品正常運作。",
                            color: .pink
                        )
                        
                        FeatureCard(
                            icon: "shield.fill",
                            title: "安全可靠",
                            description: "採用業界標準安全措施，保護您的數據安全。",
                            color: .indigo
                        )
                    }
                }
                .padding(.horizontal)
                
                // Contact Information
                VStack(spacing: 20) {
                    Text("聯絡我們")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 40) {
                        ContactCard(
                            icon: "phone.fill",
                            title: "客服洽詢",
                            info: "+886-2-1234-5678",
                            color: .blue
                        )
                        
                        ContactCard(
                            icon: "envelope.fill",
                            title: "電子郵件",
                            info: "contact@fengtuge.com",
                            color: .green
                        )
                    }
                    
                    HStack(spacing: 40) {
                        ContactCard(
                            icon: "globe",
                            title: "官方網站",
                            info: "www.fengtuge.com",
                            color: .purple
                        )
                        
                        ContactCard(
                            icon: "building.2.fill",
                            title: "公司地址",
                            info: "台北市忠孝東路五段97號",
                            color: .orange
                        )
                    }
                }
                
                // Footer
                VStack(spacing: 8) {
                    Text("鋒兄Next資訊管理")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text("鋒兄途哥公開資訊有限公司")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("© 2025 ~ 2125 版權所有")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Feng & Tu Public Relations Information Co., Ltd.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("All Rights Reserved")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 8) {
                        Text("鋒兄Next資訊管理 v3.0.0")
                        Text("•")
                        Text("Next.js + TypeScript")
                        Text("•")
                        HStack(spacing: 2) {
                            Text("Made with")
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                                .font(.caption)
                            Text("in Taiwan")
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
    }
}

struct ServiceCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let description: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                    .frame(width: 80, height: 80)
                    .background(
                        Circle()
                            .fill(color)
                    )
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(color)
                        .fontWeight(.medium)
                }
            }
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(4)
        }
        .padding(20)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(16)
        .frame(maxWidth: .infinity)
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .frame(maxWidth: .infinity)
    }
}

struct ContactCard: View {
    let icon: String
    let title: String
    let info: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(color)
                )
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(info)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
    }
}