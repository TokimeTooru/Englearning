import Foundation

protocol ModalProfileInteractorProtocol {
    func setNewUserData(tag: AvatarImage)
}

final class ModalProfileInteractor: ModalProfileInteractorProtocol {
    private let presenter: ModalProfilePresenterProtocol
    private let networkManager: ModalProfileNetworkManagerProtocol = ModalProfileNetworkManager()

    init(presenter: ModalProfilePresenterProtocol) {
        self.presenter = presenter
    }

    func setNewUserData(tag: AvatarImage) {
        guard var model = LocalUserData.share.get else {
            SnackCenter.shared.showSnack(text: "Bad Model", style: .error)
            return
        }
        model.avatarTag = tag.rawValue
        LocalUserData.share.set = model
        networkManager.setNewUserDataBase(model: model) { result in
            if !result {
                SnackCenter.shared.showSnack(text: "Your setting hasn't saved in web", style: .base)
            }
        }
    }
}
