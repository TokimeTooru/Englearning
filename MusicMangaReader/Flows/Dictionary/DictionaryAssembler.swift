import UIKit


final class DictionaryAssembler {
    static func assembly() -> DictionaryViewController {
        let presenter = DictionaryPresenter()
        let interactor = DictionaryInteractor(presenter: presenter)
        let router = DictionaryRouter(dataSource: interactor)
        let vc = DictionaryViewController(interactor: interactor, router: router)

        presenter.view = vc
        router.view = vc

        return vc
    }
}
