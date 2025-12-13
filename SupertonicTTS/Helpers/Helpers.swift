//
//  Helpers.swift
//  SupertonicTTS

import SwiftUI
import BlurUIKit


struct ShakeEffect: GeometryEffect {
    private let amount: CGFloat = 10
    private let shakesPerUnit = 3
    var animatableData: CGFloat

    var affineTransform: CGAffineTransform {
        CGAffineTransform(
            translationX: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0
        )
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(affineTransform)
    }
}



struct ProgressiveBlurView: UIViewRepresentable {
    var maxBlurRadius: CGFloat = 25
    var dimmingTintColor: UIColor? = nil
    var overshoot: CGFloat = 0.25
    var dimmingAlpha: VariableBlurView.DimmingAlpha = .interfaceStyle(lightModeAlpha: 0.18,
                                                                      darkModeAlpha: 0.25)
    
    func makeUIView(context: Context) -> VariableBlurView {
        let blurView = VariableBlurView()
        blurView.dimmingTintColor = dimmingTintColor
        blurView.maximumBlurRadius = maxBlurRadius
        blurView.dimmingAlpha = dimmingAlpha
        blurView.dimmingOvershoot = .relative(fraction: overshoot)
        return blurView
    }
    
    func updateUIView(_ uiView: VariableBlurView, context: Context) { }
}



struct VoiceOptionLabelStyle: LabelStyle {
    let isSelected: Bool
    @Environment(\.colorScheme) private var scheme
    
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: "checkmark")
                .symbolEffect(.bounce, value: isSelected)
                .foregroundStyle(isSelected ? AnyShapeStyle(Color.blue.gradient) : AnyShapeStyle(Color.gray.opacity(0.7)))
            
            configuration.title
                .foregroundStyle(isSelected ? Color.primary : Color.gray.opacity(0.7))
        }
        .font(.subheadline.weight(isSelected ? .semibold : .medium))
        .frame(maxWidth: .infinity)
        .frame(height: 42)
        .background(
            Capsule()
                .fill(Color.secondary.opacity(scheme == .light ? 0.1 : 0.2))
        )
        .overlay(
            Capsule()
                .stroke(Color.secondary.opacity(0.25))
        )
    }
}

// to be able to bind on string items
// Like: 'alert(item: $vm.errorMessage)'
extension String: @retroactive Identifiable {
    public var id: String { self }
}
