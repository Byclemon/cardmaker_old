//
//  ContentView.swift
//  CardMaker
//
//  Created by 袁强 on 2024/11/6.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationStack {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("主页")
                    }
                
                CustomThemesView()
                    .tabItem {
                        Image(systemName: "paintpalette.fill")
                        Text("主题")
                    }
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .accentColor(isDarkMode ? .white : .black)
    }
}

#Preview {
    ContentView()
}