import Foundation
import SwiftUI

struct ProgressBarView: View {
    let duration: TimeInterval
    @Binding var isActive: Bool
    let activate: (() -> Void)?
    let deActivate: (() -> Void)?
    let onManualChange: ((Double) -> Void)?
    let onFinished: (() -> Void)?
    @State private var wasActive: Bool = false
    @State private var elapsedTime: TimeInterval = 0
    @State private var touchLocation: CGPoint?
    private var progress: Double {
        if duration > 0.0 {
            return min(elapsedTime / duration, 1.0)
        } else {
            return 1.0
        }
    }
    private let timerInterval = 0.1
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: width, height: height)
                    .foregroundColor(.gray)
                    .cornerRadius(height / 2)
                Rectangle()
                    .frame(width: width * progress, height: height)
                    .foregroundColor(.white)
                    .cornerRadius(height / 2)
                    .animation(.linear(duration: timerInterval), value: progress)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if let onManualChange {
                            if !wasActive && isActive {
                                wasActive = true
                                isActive = false
                                if let deActivate {
                                    deActivate()
                                }
                            }
                            elapsedTime = duration * min(max(value.location.x / width, 0), 1)
                            onManualChange(progress)
                        }
                    }
                    .onEnded { value in
                        if let onManualChange {
                            elapsedTime = duration * min(max(value.location.x / width, 0), 1)
                            onManualChange(progress)
                            if wasActive {
                                wasActive = false
                                isActive = true
                                if let activate {
                                    activate()
                                }
                            }
                        }
                        touchLocation = value.location
                    }
                    .simultaneously(
                        with: TapGesture(count: 1)
                            .onEnded({ _ in
                                if let onManualChange {
                                    if let touchLocation {
                                        elapsedTime = duration * min(max(touchLocation.x / width, 0), 1)
                                        onManualChange(progress)
                                    }
                                }
                            })
                    )
            )
        }
        .onAppear {
            /*
             * Not accurate but it's okay for the use
             */
            let emptyDate = Date(timeIntervalSince1970: 0)
            var lastTickDate = emptyDate
            Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { [self] _ in
                if isActive {
                    if lastTickDate != emptyDate {
                        let newTickDate = Date()
                        elapsedTime += newTickDate.timeIntervalSince(lastTickDate)
                        lastTickDate = newTickDate
                        if elapsedTime >= duration {
                            /* loop back to start */
                            elapsedTime = 0
                            lastTickDate = emptyDate
                            isActive = false
                            if let onFinished {
                                onFinished()
                            }
                        }
                    } else {
                        lastTickDate = Date()
                    }
                } else {
                    if lastTickDate != emptyDate {
                        lastTickDate = emptyDate
                    }
                }
            }
        }
    }
}
