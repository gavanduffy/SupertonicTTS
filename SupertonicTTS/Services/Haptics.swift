//
//  Hapticcs.swift
//  SupertonicTTS
    

import SwiftUI
import AudioToolbox


class Haptics {
    static func notificationFeedback(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard Preferences.hapticsEnabled else { return }
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
    
    static func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard Preferences.hapticsEnabled else { return }
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    
    static func selection() {
        guard Preferences.hapticsEnabled else { return }
        UISelectionFeedbackGenerator().selectionChanged()
    }
    
    /// Vibrates the device using a system sound
    static func vibrateDevice() {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
}
