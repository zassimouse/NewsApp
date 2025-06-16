//
//  PrimaryButton.swift
//  NewsApp
//
//  Created by Denis Haritonenko on 16.06.25.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let symbolName: String?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Text(title)
                    .font(.system(size: 17, weight: .bold))
                    .multilineTextAlignment(.center)
                
                if let symbolName = symbolName {
                    HStack {
                        Spacer()
                        Image(systemName: symbolName)
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
    PrimaryButton(title: "Button", symbolName: "arrow.up", action: { print("hi")})
}
