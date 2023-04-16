protocol RegPresenterProtocol {
    func emailValidation(email: Bool)
    func passwardValidation(passward: Bool)
    func registartionRequest(isValid: Bool)
    func makeVerification()
}


final class RegPresenter: RegPresenterProtocol {
    var viewController: RegViewControllerProtocol?

    func emailValidation(email: Bool) {
        guard !email else { return }
        viewController?.emailValidationDenaid()
    }

    func passwardValidation(passward: Bool) {
        guard !passward else { return }
        viewController?.passwordValidationDenaid()
    }

    func registartionRequest(isValid: Bool) {
        viewController?.registrationResult(isReg: isValid)
    }

    func makeVerification() {
        viewController?.makeVerification()
    }
}
