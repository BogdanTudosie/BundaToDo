//
//  CheckmarkToggleStyle.swift
//  BundaToDo
//
//  Created by Bogdan Tudosie on 12.12.2024.
//

import SwiftUI

struct CheckmarkToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .foregroundColor(configuration.isOn ? .green : .gray)
                .font(.system(size: 24))
        }
    }
}
