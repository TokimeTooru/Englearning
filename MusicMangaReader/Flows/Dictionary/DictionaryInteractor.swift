import Foundation


protocol DictionaryInteractorProtocol {
    func getDictionaryModel()
    func removeWord(wordId: Int, indexPath: IndexPath)
}

protocol DictionaryInteractorDataSource {
    func getNewWordData(enWord: String, ruWord: String, example: String, wordId: Int)
}


final class DictionaryInteractor: DictionaryInteractorProtocol, DictionaryInteractorDataSource {
    private let presenter: DictionaryPresenterProtocol

    private let networkManager = DictionaryNetworkManager()

    init(presenter: DictionaryPresenterProtocol) {
        self.presenter = presenter
    }

    func getDictionaryModel() {
        DispatchQueue.global().async {
            guard let userData = LocalUserData.share.get else { return }
            let model = userData.adddedWords
            DispatchQueue.main.async {
                self.presenter.prepearDictionaryModel(model: model)
            }
        }
    }

    func getNewWordData(enWord: String, ruWord: String, example: String, wordId: Int) {
        let wordModel = DictionaryPresenter.DictionaryModel(
            enWord: enWord,
            ruWord: ruWord,
            example: example,
            wordId: wordId
        )
        presenter.addNewWord(word: wordModel)
    }

    func removeWord(wordId: Int, indexPath: IndexPath) {
        DispatchQueue.global().async {
            guard var model = LocalUserData.share.get else { return }
            model.adddedWords = model.adddedWords.filter { $0.wordId != wordId}
            LocalUserData.share.set = model
            self.networkManager.setNewUserData(model: model) {_ in}
            DispatchQueue.main.async {
                self.presenter.removeWord(indexPath: indexPath)
            }
        }
    }
}
