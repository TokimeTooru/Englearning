import UIKit

enum AuthAssembler {
    static func assembly() -> UIViewController{
        let presenter = AuthPresenter()
        let interactor = AuthInteractor(presenter: presenter)
        let router = AuthRouter(dataSource: interactor)
        let viewController = AuthViewController(router: router, interactor: interactor)
        
        presenter.viewController = viewController
        router.view = viewController

        return viewController
    }
}
