//
//  AppIconTile.swift
//  Focus
//
//  Created by Ryan Thomas on 4/12/25.
//


import SwiftUI

struct AppIconTile: View {
    let icon: AppIcon
    let isSelected: Bool
    let selectedColor: Color
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: 6) {
            Image(uiImage: UIImage(named: icon.previewName) ?? UIImage())
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 60, height: 60)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(selectedColor, lineWidth: isSelected ? 3 : 0)
                )
                .onTapGesture {
                    onTap()
                }

            Text(icon.displayName)
                .font(.caption2)
        }
    }
}
