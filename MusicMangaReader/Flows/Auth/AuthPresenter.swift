protocol AuthPresenterProtocol {
    func loginResultPresent(isSuccess: Bool)
    func validEmail(isValid: Bool)
    func validPassword(isValid: Bool)
}

final class AuthPresenter: AuthPresenterProtocol {
    var viewController: AuthViewControllerProtocol?

    func loginResultPresent(isSuccess: Bool) {
        isSuccess ? viewController?.successLogin() : viewController?.failLogin()
    }

    func validEmail(isValid: Bool) {
        guard !isValid else { return }
        viewController?.emailValidationDenaid()
    }

    func validPassword(isValid: Bool) {
        guard !isValid else { return }
        viewController?.passwordValidationDenaid()
    }
}
