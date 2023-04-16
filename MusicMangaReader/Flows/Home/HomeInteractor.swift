import Foundation

protocol HomeInteractorProtocol {
    func reloadUserData()
}


final class HomeInteractor: HomeInteractorProtocol {
    private var presenter: HomePresenterProtocol

    init(presenter: HomePresenterProtocol) {
        self.presenter = presenter
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
}
