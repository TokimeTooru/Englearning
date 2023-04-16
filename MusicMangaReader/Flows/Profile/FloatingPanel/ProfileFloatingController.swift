import FloatingPanel
import UIKit


final class ProfileFloatingController: FloatingPanelController, FloatingPanelControllerDelegate {
     private let portraitLayout = ProfileFloatingPanelLayout()

    init(
        delegate: FloatingPanelControllerDelegate? = nil,
        contentMode: ContentMode = .fitToBounds
    ) {
        super.init(delegate: delegate)
        configurePanel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configurePanel() {
        layout = portraitLayout
        isRemovalInteractionEnabled = true
        delegate = self
        invalidateLayout()

        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 24
        surfaceView.appearance = appearance
        surfaceView.grabberHandle.isHidden = false
        surfaceView.grabberHandleSize = CGSize(width: 40, height: 4)
        surfaceView.grabberHandle.barColor = .majourColor
        surfaceView.grabberHandlePadding = 10
        surfaceView.appearance.backgroundColor = .mainWhite
    }

    /// Blocks the floatingPanel from moving above the norm of the current state
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        guard fpc.isAttracting == false else { return }
        let location = fpc.surfaceLocation
        let minY = fpc.surfaceLocation(for: fpc.state).y
        let maxY = fpc.surfaceLocation(for: .tip).y
        fpc.surfaceLocation = CGPoint(x: location.x, y: min(max(location.y, minY), maxY))
    }

    func movePanel(_ state: FloatingPanelState) {
        move(to: state, animated: true)
        invalidateLayout()
    }
}



final class ProfileFloatingPanelLayout: FloatingPanelLayout {
    var position: FloatingPanelPosition = .bottom
    var initialState: FloatingPanelState = .half

    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .half: FloatingPanelLayoutAnchor(
                fractionalInset: UIScreen.main.bounds.height <= 820 ? 0.85 : 0.7,
                edge: .bottom,
                referenceGuide: .safeArea
            )
        ]
    }

    func prepareLayout(surfaceView: UIView, in view: UIView) -> [NSLayoutConstraint] {
        return [
            surfaceView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            surfaceView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ]
    }

    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.5
    }
}
