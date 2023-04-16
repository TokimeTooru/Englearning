import UIKit


protocol HomePresenterProtocol {
    func upToDateUserData(imageTag: Int, username: String, level: Int, currentExp: Float)
}


final class HomePresenter: HomePresenterProtocol {
    var view: HomeViewControllerProtocol?

    func upToDateUserData(imageTag: Int, username: String, level: Int, currentExp: Float) {
        let avatarImage = AvatarImage(rawValue: imageTag) ?? .rabbit

        view?.setUserData(model: .init(
            imageTag: avatarImage,
            nickname: username,
            level: String(level) + " lvl",
            currentExp: currentExp
        ))
    }
}
