//
//  PrimaryButton.swift
//  NewsApp
//
//  Created by Denis Haritonenko on 14.06.25.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let icon: Image?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Text(title)
                    .font(.system(size: 17, weight: .bold))
                    .multilineTextAlignment(.center)
                
                if let icon = icon {
                    HStack {
                        Spacer()
                        icon
                            .font(.system(size: 20, weight: .light))
                    }
                    .padding(.trailing, 17)
                }
            }
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .background(.accentPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PrimaryButton(title: "Button", icon: Image(systemName: "arrow.up"), action: { print("hi")})
}
