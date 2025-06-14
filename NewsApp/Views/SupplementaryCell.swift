//
//  SupplementaryCell.swift
//  NewsApp
//
//  Created by Denis Haritonenko on 14.06.25.
//

import SwiftUI

struct SupplementaryCell: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("All News in One Place")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.labelPrimary)
            Spacer()
            Text("Stay informed quickly and conveniently")
                .multilineTextAlignment(.center)
                .frame(maxWidth: 170)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.labelSecondary)
            Spacer()
            PrimaryButton(title: "Go", icon: Image(systemName: "arrow.right"), action: {})
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
    SupplementaryCell()
}
