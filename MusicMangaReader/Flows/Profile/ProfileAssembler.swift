import UIKit


final class ProfileAssembler {
    static func assembly() -> UIViewController {
        let presenter = ProfilePresenter()
        let interactor = ProfileInteractor(presenter: presenter)
        let router = ProfileRouter(dataSource: interactor)
        let vc = ProfileViewController(interactor: interactor, router: router)

        presenter.view = vc
        router.view = vc

        return vc
    }
}
