//
//  DateFormatter.swift
//  TwitterApp
//
//  Created by Jamerson Macedo on 18/09/24.
//

import Foundation
import FirebaseCore
extension Timestamp{
    func formatDate(timestamp: Timestamp) -> String {
           let date = timestamp.dateValue()
           let formatter = DateFormatter()
           formatter.dateStyle = .medium // Define apenas o estilo da data, sem hora
           formatter.timeStyle = .none   // Não mostra a hora
           return formatter.string(from: date)
       }
}
