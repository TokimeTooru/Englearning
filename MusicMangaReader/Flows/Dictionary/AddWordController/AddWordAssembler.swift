import UIKit


final class AddWordAssembler {
    static func assembly() -> AddWordViewController {
        let presenter = AddWordPresenter()
        let router = AddWordRouter()
        let interactor = AddWordInteractor(presenter: presenter)
        let vc = AddWordViewController(interactor: interactor, router: router)

        presenter.view = vc
        router.view = vc

        return vc
    }
}
