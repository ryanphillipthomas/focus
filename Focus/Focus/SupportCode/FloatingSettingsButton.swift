//
//  FloatingSettingsButton.swift
//  Focus
//
//  Created by Ryan Thomas on 4/11/25.
//

import SwiftUI

struct FloatingSettingsButton: View {
    @Binding var showSettings: Bool
    @AppStorage("selectedAccentColor") private var selectedAccentColor: String = AccentColorOption.orange.rawValue
    @AppStorage("floatingButtonX") private var savedX: Double = 150
    @AppStorage("floatingButtonY") private var savedY: Double = 300

    @State private var position: CGPoint = .zero
    @GestureState private var dragOffset: CGSize = .zero
    @State private var hasAppeared = false
    @State private var isPressed = false

    private let buttonSize: CGFloat = 60
    private let paddingFromEdges: CGFloat = 24

    private var accentColor: Color {
        AccentColorOption(rawValue: selectedAccentColor)?.color ?? AccentColorOption.orange.color
    }

    var body: some View {
        GeometryReader { geo in
            let safeInsets = geo.safeAreaInsets
            let maxX = geo.size.width - paddingFromEdges - buttonSize / 2
            let minX = paddingFromEdges + buttonSize / 2
            let maxY = geo.size.height - paddingFromEdges - buttonSize / 2 - safeInsets.bottom
            let minY = paddingFromEdges + buttonSize / 2 + safeInsets.top

            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [accentColor, accentColor.opacity(0.6)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: buttonSize, height: buttonSize)
                .shadow(color: accentColor.opacity(isPressed ? 0.5 : 0.2), radius: isPressed ? 16 : 10)
                .scaleEffect(isPressed ? 0.88 : (hasAppeared ? 1 : 0.7))
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
                .opacity(hasAppeared ? 1 : 0)
                .animation(.easeInOut(duration: 0.3), value: hasAppeared)
                .overlay(
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .bold))
                )
                .withoutAnimation()
                .position(
                    x: clamped(position.x + dragOffset.width, minX, maxX),
                    y: clamped(position.y + dragOffset.height, minY, maxY)
                )
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .updating($dragOffset) { value, state, _ in
                            if !isPressed {
                                isPressed = true
                                triggerHaptic()
                            }
                            state = value.translation
                        }
                        .onEnded { value in
                            let rawX = position.x + value.translation.width
                            let rawY = position.y + value.translation.height
                            let clampedX = clamped(rawX, minX, maxX)
                            let clampedY = clamped(rawY, minY, maxY)
                            let final = CGPoint(x: clampedX, y: clampedY)
                            position = final
                            savePosition(final)
                            isPressed = false
                        }
                )
                .simultaneousGesture(
                    TapGesture()
                        .onEnded {
                            showSettings = true
                        }
                )
                .onAppear {
                    position = CGPoint(x: savedX, y: savedY)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        hasAppeared = true
                    }
                }
        }
        .ignoresSafeArea()
    }

    private func savePosition(_ pos: CGPoint) {
        savedX = pos.x
        savedY = pos.y
    }

    private func clamped(_ value: CGFloat, _ min: CGFloat, _ max: CGFloat) -> CGFloat {
        Swift.min(Swift.max(value, min), max)
    }

    private func triggerHaptic() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        #endif
    }
}

private extension View {
    func withoutAnimation() -> some View {
        transaction { $0.animation = nil }
    }
}
