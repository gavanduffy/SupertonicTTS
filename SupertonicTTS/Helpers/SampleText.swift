//
//  SampleTextProvider.swift
//  SupertonicTTS
    

import Foundation

enum SampleText: String, CaseIterable {
    case dateAndTime = "Date and Time"
    case phoneNumbers = "Phone Numbers"
    case financialExpressions = "Financial Expressions"
    case technicalUnits = "Technical Units"
    
    var text: String {
        switch self {
        case .dateAndTime:
            return "The train delay was announced at 4:45 PM on Wed, Apr 3, 2024 due to track maintenance."
        case .phoneNumbers:
            return "You can reach the hotel front desk at (212) 555-0142 ext. 402 anytime."
        case .financialExpressions:
            return "The startup secured $5.2M in venture capital, a huge leap from their initial $450K seed round."
        case .technicalUnits:
            return "Our drone battery lasts 2.3h when flying at 30kph with full camera payload."
        }
    }
}
