import Foundation

protocol ProfileInteractorProtocol {
    func usernameValidation(username: String)
    func reloadUserData()
    func getDataForUnits()
}

protocol ProfileInteractorDataSource {
    func upDateImage(tag: AvatarImage)
}


final class ProfileInteractor: ProfileInteractorProtocol {
    private let presenter: ProfilePresenterProtocol

    private let validationManager = ProfileValidationManager()
    private let networkManager: ProfileNetworkManagerProtocol = ProfileNetworkManager()

    init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
    }

    func usernameValidation(username: String) {
        guard
            validationManager.validation(with: .username(username))
        else {
            SnackCenter.shared.showSnack(text: "Incorect nickname", style: .error)
            return
        }
        guard var model = LocalUserData.share.get else {
            SnackCenter.shared.showSnack(text: "Bad Model", style: .error)
            return
        }
        model.username = username
        LocalUserData.share.set = model
        networkManager.setNewUserDataBase(model: model, completion: {_ in})
        SnackCenter.shared.showSnack(text: "Username saved successfully", style: .success)
    }

    func reloadUserData() {
        DispatchQueue.global().async {
            guard
                let model = LocalUserData.share.get
            else {
                DispatchQueue.main.async {
                    SnackCenter.shared.showSnack(text: "model", style: .error)
                }
                return
            }
            DispatchQueue.main.async {
                self.presenter.upToDateUserData(
                    imageTag: model.avatarTag,
                    username: model.username,
                    level: model.level,
                    currentExp: model.currentExp
                )
            }
        }
    }

    func getDataForUnits() {
        DispatchQueue.global().async {
            guard
                let model = LocalUserData.share.get
            else {
                DispatchQueue.main.async {
                    SnackCenter.shared.showSnack(text: "model", style: .error)
                }
                return
            }
            DispatchQueue.main.async {
                self.presenter.preperUnitsData(
                    wordsAdded: model.wordsAdded,
                    wordsMemorized: model.wordMemorized,
                    enemiesDefited: model.enemiesDefeated
                )
            }

        }
    }
}

extension ProfileInteractor: ProfileInteractorDataSource {
    func upDateImage(tag: AvatarImage) {
        presenter.upDateImage(tag: tag)
    }
}
