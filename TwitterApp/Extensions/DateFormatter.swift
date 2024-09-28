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

extension Timestamp {
    func timeAgoDisplay() -> String {
        let date = self.dateValue()
        let secondsAgo = Int(Date().timeIntervalSince(date))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        if secondsAgo < hour {
            let minutes = secondsAgo / minute
            return minutes == 0 ? "Agora" : "\(minutes) m"
        } else if secondsAgo < day {
            let hours = secondsAgo / hour
            return "\(hours) h"
        } else if secondsAgo < 6 * day {
            let days = secondsAgo / day
            return "\(days) d"
        } else {
            // Exibe a data completa se for mais de 6 dias
            return formatter.string(from: date)
        }
    }
    
}
    
