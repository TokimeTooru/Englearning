import FirebaseAuth

protocol AuthInteractorProtocol {
    func loginRequest(email: String, password: String)
    func emailValidation(with email: String)
    func passwordValidation(with password: String)
}

protocol AuthInteractorDataSource {
    var user: User? { get }
}


final class AuthInteractor: AuthInteractorProtocol, AuthInteractorDataSource {
    private let presenter: AuthPresenterProtocol

    private let authValidationManager: AuthValidationManagerProtocol = AuthValidationManager()
    private var networkManager: AuthNetworkManagerProtocol = AuthNetworkManager()

    var user: User?
    
    init(presenter: AuthPresenterProtocol) {
        self.presenter = presenter
    }
    
    func loginRequest(email: String, password: String) {
        let isEmailValid = authValidationManager.validation(type: .email(email))
        let isPasswordValid = authValidationManager.validation(type: .password(password))

        guard isEmailValid, isPasswordValid else {
            presenter.loginResultPresent(isSuccess: false)
            SnackCenter.shared.showSnack(text: "Wrong email or password", style: .error)
            return
        }
        networkManager.authorization(email: email, password: password) { [weak self] user in
            self?.user = user
        }
        networkManager.errorVerification = { [weak self] in
            self?.presenter.loginResultPresent(isSuccess: false)
        }
        networkManager.successVerification = { [weak self] in
            guard let model = LocalUserData.share.get else {
                self?.networkManager.getUserDataBase() { [weak self] model in
                    LocalUserData.share.set = model
                    self?.presenter.loginResultPresent(isSuccess: true)
                }
                return
            }
            self?.networkManager.setNewUserDataBase(model: model) { _ in }
            self?.presenter.loginResultPresent(isSuccess: true)
        }
    }

    func emailValidation(with email: String) {
        presenter.validEmail(isValid: authValidationManager.validation(type: .email(email)))
    }

    func passwordValidation(with password: String) {
        presenter.validPassword(isValid: authValidationManager.validation(type: .password(password)))
    }
}
