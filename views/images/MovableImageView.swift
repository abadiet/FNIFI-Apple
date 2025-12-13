import SwiftUI
import FNIFIModule


struct MovableImageView: View {
    let image: Image
    @State private var scale = 1.0
    @State private var lastScale = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var initImgHalfSz: CGSize = .zero
    @State private var touchLocation: CGPoint = .zero

    var body: some View {
        GeometryReader { geometry in
            let containerHalfSz = CGSize(
                width: geometry.size.width / 2.0,
                height: geometry.size.height / 2.0,
            )
            image
                .resizable()
                .scaleEffect(scale)
                .offset(offset)
                .scaledToFit()
                .background(
                    GeometryReader { imgGeo in
                        Color.clear
                            .onAppear {
                                initImgHalfSz  = CGSize(
                                    width: imgGeo.size.width / 2.0,
                                    height: imgGeo.size.height / 2.0,
                                )
                            }
                    }
                )
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
                .gesture(
                    MagnificationGesture(minimumScaleDelta: 0)
                        .onChanged({ value in
                            withAnimation(.interactiveSpring()) {
                                scale = lastScale + value - 1.0
                            }
                        })
                        .onEnded({ _ in
                            withAnimation(.easeOut) {
                                if (scale < 1.0) {
                                    scale = 1.0
                                }
                            }
                            lastScale = scale
                            updateOffset(containerHalfSz: containerHalfSz)
                        })
                        .simultaneously(
                            with: DragGesture(minimumDistance: 0)
                                .onChanged({ value in
                                    withAnimation(.interactiveSpring()) {
                                        offset.width = lastOffset.width + value.translation.width
                                        offset.height = lastOffset.height + value.translation.height
                                    }
                                })
                                .onEnded({ value in
                                    updateOffset(containerHalfSz: containerHalfSz)
                                    touchLocation = value.location
                                })
                        )
                        .simultaneously(
                            with: TapGesture(count: 2)
                                .onEnded({ location in
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        if (scale >= 2.0) {
                                            scale = 1.0
                                        } else {
                                            scale = 2.0
                                            offset.width = containerHalfSz.width - touchLocation.x
                                            offset.height = containerHalfSz.height - touchLocation.y
                                        }
                                    }
                                    lastScale = scale
                                    updateOffset(containerHalfSz: containerHalfSz)
                                })
                        )
                )
                .onChange(of: geometry.size) {
                    if (initImgHalfSz != .zero) {
                        /* the container size has been changed after the creation of the image: let's update initImgSz */
                        let imgRatio = initImgHalfSz.width / initImgHalfSz.height
                        let containerRatio = containerHalfSz.width / containerHalfSz.height
                        if (imgRatio > containerRatio) {
                            /* image's width = container's width */
                            initImgHalfSz.height = (containerHalfSz.width / initImgHalfSz.width) * initImgHalfSz.height
                            initImgHalfSz.width = containerHalfSz.width
                        } else {
                            /* image's height = container's height */
                            initImgHalfSz.width = (containerHalfSz.height / initImgHalfSz.height) * initImgHalfSz.width
                            initImgHalfSz.height = containerHalfSz.height
                        }
                    }
                    updateOffset(containerHalfSz: containerHalfSz)
                }
        }
    }
    
    private func updateOffset(containerHalfSz: CGSize) {
        var maxOffset = CGSize(
            width: initImgHalfSz.width * scale - containerHalfSz.width,
            height: initImgHalfSz.height * scale - containerHalfSz.height,
        )
        if (maxOffset.width < 0.0) {
            maxOffset.width = 0.0
        }
        if (maxOffset.height < 0.0) {
            maxOffset.height = 0.0
        }
        withAnimation(.easeOut) {
            if (abs(offset.width) > maxOffset.width) {
                offset.width = maxOffset.width * (offset.width > 0 ? 1 : -1)
            }
            if (abs(offset.height) > maxOffset.height) {
                offset.height = maxOffset.height * (offset.height > 0 ? 1 : -1)
            }
        }
        lastOffset = offset
    }
}
