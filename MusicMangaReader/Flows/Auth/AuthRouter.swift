import UIKit

protocol AuthRouterProtocol {
    func nextFlowRouter(type: AuthRouter.Next)
}

final class AuthRouter: AuthRouterProtocol {
    enum Next {
        case registration
        case main
    }
    weak var view: UIViewController?
    
    private let dataSource: AuthInteractorDataSource
    
    init(dataSource: AuthInteractorDataSource) {
        self.dataSource = dataSource
    }

    func nextFlowRouter(type: AuthRouter.Next) {
        print("Im alive")
        switch type {
        case .main:
            guard let view = view else { return }
            let vc = MainTabBarController()
            view.navigationController?.pushViewController(vc, animated: true)
        case .registration:
            guard let view = view else { return }
            let vc = RegAssembler.assembly()
            view.navigationController?.pushViewController(vc, animated: true)

        }
    }
}
