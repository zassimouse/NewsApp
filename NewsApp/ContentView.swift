//
//  ContentView.swift
//  NewsApp
//
//  Created by Denis Haritonenko on 13.06.25.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.labelPrimary]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.labelPrimary]
    }
    
    @State private var selectedOption = 0
    private let options = ["All", "Favorites", "Blocked"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                VStack {
                    Picker("Options", selection: $selectedOption) {
                        ForEach(0..<options.count, id: \.self) { index in
                            Text(options[index])
                                .tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                               
                SupplementaryCell()
                
                ForEach(1...10, id: \.self) { index in
                    ArticleCell()
                }

                
            }
            .padding(.horizontal)
        }
        .background(.backgroundPrimary)
        .navigationBarTitle("News", displayMode: .large)
    }
}

#Preview {
    NavigationView {
        ContentView()
    }
}
