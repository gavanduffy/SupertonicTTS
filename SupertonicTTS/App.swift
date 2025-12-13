//
//  SupertonicTTSApp.swift
//  SupertonicTTS


import SwiftUI
import KeyboardDismisser


@main
struct SupertonicTTSApp: App {
    @AppStorage("AppAppearance") var appAppearance: String?
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .persistentSystemOverlays(.hidden)
                .preferredColorScheme(stringToColorScheme())
                .dismissKeyboardOnTap()
                .onShake(perform: toggleAppearance)
        }
    }
    
    func stringToColorScheme() -> ColorScheme? {
        guard let appAppearance else { return nil } // fallback to system
        if appAppearance.contains("light") { return .light }
        else { return .dark }
    }
    
    func toggleAppearance() {
        appAppearance = appAppearance == "light" ? "dark" : "light"
    }
}

extension UIColor {
    var color: Color { Color(self) }
}
