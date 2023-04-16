import UIKit

protocol RegRouterProtocol {
    func goNextFlow(flow: RegRouter.NextFlow)
}


final class RegRouter: RegRouterProtocol {
    enum NextFlow {
        case login
        case main
    }

    weak var view: RegViewController?
    private let dataSource: RegInteractorDataSource

    init(dataSource: RegInteractorDataSource) {
        self.dataSource = dataSource
    }

    func goNextFlow(flow: NextFlow) {
        switch flow {
        case .main:
            guard let view = view else { return }
            let vc = MainTabBarController()
            view.navigationController?.pushViewController(vc, animated: true)

        case .login:
            view?.navigationController?.popViewController(animated: true)
        }
    }
}
