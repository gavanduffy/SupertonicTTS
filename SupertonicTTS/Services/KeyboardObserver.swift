//
//  KeyboardObserver.swift
//  SupertonicTTS
    

import UIKit
import Combine


@Observable
final class KeyboardObserver {
    var height: CGFloat = 0
    private var cancellables = Set<AnyCancellable>()

    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
            .sink { [weak self] note in
                guard
                    let userInfo = note.userInfo,
                    let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                else { return }

                let screen = UIScreen.main.bounds.height
                let keyboardHeight = max(0, screen - frame.origin.y)

                self?.height = keyboardHeight
            }
            .store(in: &cancellables)
    }
}
