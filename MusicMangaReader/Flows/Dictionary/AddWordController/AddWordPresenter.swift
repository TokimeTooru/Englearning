import UIKit


protocol AddWordPresenterProtocol {
    func setResultEnWordValidation(result: Bool)
    func setResultRuWordValidation(result: Bool)
    func setAddingResult()
}


final class AddWordPresenter: AddWordPresenterProtocol {
    var view: AddWordViewControllerProtocol?

    func setResultEnWordValidation(result: Bool) {
        guard result else {
            view?.enWordDeniedValidation()
            return
        }
    }

    func setResultRuWordValidation(result: Bool) {
        guard result else {
            view?.ruWordDeniedValidation()
            return
        }
    }

    func setAddingResult() {
        view?.wordAddingDenied()
    }
}
