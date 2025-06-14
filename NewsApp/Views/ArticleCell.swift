//
//  ArticleCell.swift
//  NewsApp
//
//  Created by Denis Haritonenko on 14.06.25.
//

import SwiftUI

struct ArticleCell: View {
    var body: some View {
        HStack(alignment: .top) {
            Image("car")
                .resizable()
                .clipped()
                .frame(width: 94, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 4))
            VStack(alignment: .leading) {
                Text("Bike season begins")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.labelPrimary)
                Spacer()
                Text("City bike shares ")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.labelSecondary)
                Spacer()

                Text("City • Apr 17,2025")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.labelSecondary)
            }
            Spacer()
            Button {
                
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.system(size: 24))
                    .foregroundStyle(.labelSecondary)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .frame(height: 96)
        .background(.backgroundSecondary)
        .cornerRadius(16)
    }
}

#Preview {
    ArticleCell()
}
