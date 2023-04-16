import FirebaseAuth


protocol RegInteractorProtocol {
    func emailValidation(email: String)
    func passwordValidation(passward: String)
    func registrationRequest(email: String, passward: String)
    func resendVerification()
    func deleteNotVerifideUser()
}

protocol RegInteractorDataSource {
    var user: User? { get }
}

final class RegInteraction: RegInteractorProtocol, RegInteractorDataSource {
    private let presenter: RegPresenterProtocol
    private let validationManager: AuthValidationManagerProtocol = AuthValidationManager()
    private var networkManager: AuthNetworkManagerProtocol = AuthNetworkManager()

    private var dispatchWorkItem: DispatchWorkItem?

    var user: User?

    init(presenter: RegPresenterProtocol) {
        self.presenter = presenter
    }

    func emailValidation(email: String) {
        presenter.emailValidation(email: validationManager.validation(type: .email(email)))
    }

    func passwordValidation(passward: String) {
        presenter.passwardValidation(passward: validationManager.validation(type: .password(passward)))
    }

    func registrationRequest(email: String, passward: String) {
        let isEmailValid = validationManager.validation(type: .email(email))
        let isPasswordValid = validationManager.validation(type: .password(passward))

        guard
            isEmailValid,
            isPasswordValid
        else {
            presenter.registartionRequest(isValid: false)
            return
        }
        
        networkManager.registration(email: email, password: passward) { [weak self] user in
            self?.user = user
        }
        networkManager.errorRegistration = { [weak self] errorString in
            SnackCenter.shared.showSnack(text: errorString, style: .error)
            self?.presenter.registartionRequest(isValid: false)
        }
        networkManager.successRegistration = { [weak self] in
            SnackCenter.shared.showSnack(text: "Verification messege have just sended to your email", style: .success)
            self?.presenter.makeVerification()

            self?.dispatchWorkItem = DispatchWorkItem {
                for _ in 0...60 {
                    guard let workItem = self?.dispatchWorkItem, !workItem.isCancelled else { break }
                    Auth.auth().currentUser?.reload() { [weak self] error in
                        guard error == nil else {
                            self?.presenter.registartionRequest(isValid: false)
                            DispatchQueue.main.async {
                                SnackCenter.shared.showSnack(text: "Error try again later", style: .error)
                            }
                            workItem.cancel()
                            return
                        }
                        guard
                            let currentUser = Auth.auth().currentUser,
                            currentUser.isEmailVerified
                        else {
                            SnackCenter.shared.showSnack(text: "Something wrong with Hosting", style: .error)
                            return
                        }
                        let model = UserModel(
                            username: currentUser.email ?? "Username",
                            avatarTag: 8,
                            enemiesDefeated: 0,
                            wordsAdded: 0,
                            wordMemorized: 0,
                            level: 1,
                            currentExp: 0.7,
                            adddedWords: []
                        )
                        self?.networkManager.setNewUserDataBase(model: model) { result in
                            if result {
                                LocalUserData.share.set = model
                            } else {
                                SnackCenter.shared.showSnack(text: "Something went wrong try later", style: .error)
                            }
                        }

                        self?.presenter.registartionRequest(isValid: true)
                        workItem.cancel()
                    }
                    sleep(5)
                }
            }

            guard let workItem = self?.dispatchWorkItem else { return }
            DispatchQueue.global(qos: .userInitiated).async(execute: workItem)
        }
    }

    func resendVerification() {
        guard let user = user else { return }
        user.sendEmailVerification() { [weak self] error in
            guard error == nil else {
                SnackCenter.shared.showSnack(text: error.debugDescription, style: .error)

                return
            }
        }
    }

    func deleteNotVerifideUser() {
        guard let user = user else { return }
        guard !user.isEmailVerified else {
            presenter.registartionRequest(isValid: true)
            return
        }
        DispatchQueue.global(qos: .utility).async {
            user.delete()
        }
        guard let workItem = dispatchWorkItem else { return }
        workItem.cancel()

    }
}
