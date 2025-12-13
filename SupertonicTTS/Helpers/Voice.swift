//
//  Voice.swift
//  SupertonicTTS
    

import Foundation
import OnnxRuntimeBindings


enum Voice {
    case engMale
    case engFemale
    case britMale
    case britFemale
    
    var displayName: String {
        switch self {
        case .engMale: return "Tim"
        case .britMale: return "Charlie"
            
        case .engFemale: return "Ellen"
        case .britFemale: return "Tina"
        }
    }
    
    var localizedAccent: String {
        switch self {
        case .engMale, .engFemale: return "American"
        case .britMale, .britFemale: return "British"
        }
    }
    
    var gender: String {
        switch self {
        case .engMale, .britMale: return "Male"
        case .engFemale, .britFemale: return "Female"
        }
    }
    
    var identifier: String {
        switch self {
        case .engMale: return "M1"
        case .britMale: return "M2"
            
        case .engFemale: return "F1"
        case .britFemale: return "F2"
        }
    }
}

enum VoiceAccent: String {
    case american = "American"
    case british = "British"
}

struct VoiceStyle {
    let ttl: ORTValue
    let dp: ORTValue
}

struct VoiceRawData: Codable {
    let style_ttl: StyleComponent
    let style_dp: StyleComponent
    
    struct StyleComponent: Codable {
        let data: [[[Float]]]
        let dims: [Int]
        let type: String
    }
}
