import UIKit

protocol ProfilePresenterProtocol {
    func upDateImage(tag: AvatarImage)
    func upToDateUserData(imageTag: Int, username: String, level: Int, currentExp: Float)
    func preperUnitsData(wordsAdded: Int, wordsMemorized: Int, enemiesDefited: Int)
}


final class ProfilePresenter: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?

    func upDateImage(tag: AvatarImage) {
        guard let view = view else { return }
        view.changeAvatar(image: tag.getImage)
    }

    func upToDateUserData(imageTag: Int, username: String, level: Int, currentExp: Float) {
        let avatarImage = AvatarImage(rawValue: imageTag) ?? .rabbit

        view?.setUserData(model: .init(
            imageTag: avatarImage,
            nickname: username,
            level: String(level) + " lvl",
            currentExp: currentExp
        ))
    }

    //MARK: - Mock DATA!!!!
    func preperUnitsData(wordsAdded: Int, wordsMemorized: Int, enemiesDefited: Int) {
        guard let view = view else { return }
        view.setUnitsData(models: [
            .wordsAdded: .init(unitName: "Words Added", unitScore: String(wordsAdded)),
            .wordsMemorized: .init(unitName: "Words Memorized", unitScore: String(wordsMemorized)),
            .enemiesDefited: .init(unitName: "Enemies Defited", unitScore: String(enemiesDefited))
        ])
        view.setUnitsAppearens(style: [
            .wordsAdded: prepareUnitAppearence(score: wordsAdded),
            .wordsMemorized: prepareUnitAppearence(score: wordsMemorized),
            .enemiesDefited: prepareUnitAppearence(score: enemiesDefited)
        ])
    }

    private func prepareUnitAppearence(score: Int) -> StatisticUnitView.AnimationStyle {
        switch score {
        case 0...10:
            return .common()
        case 11...50:
            return .rare()
        case 51...100:
            return .mistycal()
        case 101...100000:
            return .legendary()
        default:
            return .legendary()
        }
    }
}
