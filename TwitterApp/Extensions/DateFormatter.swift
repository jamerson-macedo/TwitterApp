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
extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        if secondsAgo < minute {
            return "Agora"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute) minutos atrás"
        } else if secondsAgo < day {
            return "\(secondsAgo / hour) horas atrás"
        } else if secondsAgo < week {
            return "\(secondsAgo / day) dias atrás"
        }
        return "\(secondsAgo / week) semanas atrás"
    }
}

extension Timestamp {
    func timeAgoDisplay() -> String {
        return self.dateValue().timeAgoDisplay()
    }
}
