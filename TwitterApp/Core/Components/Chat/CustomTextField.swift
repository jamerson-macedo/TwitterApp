//
//  CustomTextField.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 14/10/24.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    var onSend: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            // Campo de entrada de texto
            TextField("Send a message...", text: $text, axis: .vertical)
                .padding(10)
                .background(Color(.systemGray5))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .lineLimit(1...5) // Limita a altura conforme necessário

            // Botão de enviar
            Button(action: {
                if !text.isEmpty {
                    onSend()
                    text = "" // Limpa o campo após enviar
                }
            }) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 22))
                    .foregroundColor(text.isEmpty ? .gray : .blue)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(30)
    }
}

#Preview {
    CustomTextField(text: .constant(""), onSend: {})
}
