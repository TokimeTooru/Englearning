import UIKit


final class HomeAssembler {
    static func assembly() -> HomeViewController {
        let presenter = HomePresenter()
        let router = HomeRouter()
        let interactor = HomeInteractor(presenter: presenter)
        let viewController = HomeViewController(interactor: interactor, router: router)

        router.view = viewController
        presenter.view = viewController

        return viewController
    }
}
