import UIKit


protocol ProfileRouterProtocol {
    func nextFlow(type: ProfileRouter.NextFlow)
}


final class ProfileRouter: ProfileRouterProtocol {
    enum NextFlow {
        case home
        case images
    }
    weak var view: UIViewController?
    private let dataSource: ProfileInteractorDataSource

    init(dataSource: ProfileInteractorDataSource) {
        self.dataSource = dataSource
    }

    func nextFlow(type: NextFlow) {
        switch type {
        case .home:
            print("Go back to Home")
        case .images:
            let vc = ModalProfileAssembler.assembly()
            vc.didAcceptChanges = { [weak self] tag in
                self?.dataSource.upDateImage(tag: tag)
            }
            let fpc = ProfileFloatingController()
            fpc.set(contentViewController: vc)
            fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true

            guard let view = view else { return }
            view.present(fpc, animated: true)
        }
    }
}
