import Foundation
import SwiftUI

struct ProgressBarView: View {
    let duration: TimeInterval
    @Binding var isActive: Bool
    let onManualChange: ((Double) -> Void)?
    @State private var elapsedTime: TimeInterval = 0
    private var progress: Double {
        if duration > 0.0 {
            return min(elapsedTime / duration, 1.0)
        } else {
            return 1.0
        }
    }
    private let timerInterval = 0.1
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: .infinity, height: .infinity)
                    .foregroundColor(.gray)
                    .cornerRadius(geometry.size.height / 2)
                Rectangle()
                    .frame(width: geometry.size.width * progress, height: .infinity)
                    .foregroundColor(.white)
                    .cornerRadius(geometry.size.height / 2)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if let onManualChange {
                                    elapsedTime = duration * min(max(value.location.x / geometry.size.width, 0), 1)
                                    onManualChange(progress)
                                }
                            }
                    )
            }
        }
        .onAppear {
            let startTime = Date()
            var pausedTime: TimeInterval = 0
            Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { [self] _ in
                if isActive {
                    elapsedTime = Date().timeIntervalSince(startTime) - timerInterval
                    /*if elapsedTime > duration {
                        timer.invalidate()
                    }*/
                } else {
                    pausedTime += timerInterval
                }
            }
        }
    }
}
