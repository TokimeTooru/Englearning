import UIKit


final class ModalProfileAssembler {
    static func assembly() -> ModalProfilViewController {
        let presenter = ModalProfilePresenter()
        let interactor = ModalProfileInteractor(presenter: presenter)
        let vc = ModalProfilViewController(interactor: interactor)

        presenter.view = vc
        return vc
    }
}
