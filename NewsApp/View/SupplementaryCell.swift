//
//  SupplementaryCell.swift
//  NewsApp
//
//  Created by Denis Haritonenko on 16.06.25.
//

import SwiftUI

struct SupplementaryCell: View {
    let item: SupplementaryItem
    var action: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .center) {
            if let subtitle = item.subtitle {
                Text(item.title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.labelPrimary)
                Spacer()
                Text(subtitle)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 170)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.labelSecondary)
            } else if let symbol = item.title_symbol {
                Image(systemName: symbol)
                    .font(.system(size: 20, weight: .light))
                    .foregroundStyle(.accentPrimary)
                Spacer()
                Text(item.title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.labelPrimary)
            }
            
            Spacer()
            
            PrimaryButton(title: item.button_title, symbolName: item.button_symbol, action: {})
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .frame(height: 144)
        .background(.backgroundSecondary)
        .cornerRadius(16)
    }
}

#Preview {
    SupplementaryCell(item: SupplementaryItem(
        id: 1,
        title: "All News in One Place",
        subtitle: nil,
        title_symbol: "arrow.right",
        button_title: "Go",
        button_symbol: "arrow.right"
    ))
}
