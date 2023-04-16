import Foundation


protocol AddWordInteractorProtocol {
    func enWordValidation(text: String)
    func ruWordValidation(text: String)
    func setNewWord(enWord: String, ruWord: String, example: String, completion: @escaping (Int) -> ())
}


final class AddWordInteractor: AddWordInteractorProtocol {
    private let presenter: AddWordPresenterProtocol

    private let validationManager: AddWordValidationManagerProtocol = AddWordValidationManger()
    private let networkManager: AddWordNetworkManagerProtocol = AddWordNetworkManager()


    init(presenter: AddWordPresenter) {
        self.presenter = presenter
    }

    func enWordValidation(text: String) {
        let result = validationManager.isValid(text: text, type: .def)
        presenter.setResultEnWordValidation(result: result)
        
    }

    func ruWordValidation(text: String) {
        let result = validationManager.isValid(text: text, type: .def)
        presenter.setResultRuWordValidation(result: result)
    }

    func setNewWord(enWord: String, ruWord: String, example: String, completion: @escaping (Int) -> ()) {
        guard
            validationManager.isValid(text: enWord, type: .def),
            validationManager.isValid(text: ruWord, type: .def)
        else {
            SnackCenter.shared.showSnack(text: "Incorect word", style: .error)
            presenter.setAddingResult()
            return
        }
        DispatchQueue.global(qos: .default).async {
            var model = LocalUserData.share.get
            model?.wordsAdded += 1
            let numberOfWords: Int = model?.adddedWords.count ?? 0
            model?.adddedWords.append(.init(
                enWord: enWord,
                ruWord: ruWord,
                examples: example,
                statusTag:WordStatusTag.new.rawValue,
                streak: 0,
                lastRightAnswer: Date(),
                rightAnswers: 0,
                wrongAnswers: 0,
                wordId: numberOfWords - 1
            ))
            LocalUserData.share.set = model
            guard var model = model else { return }
//            model.adddedWords = []
//            LocalUserData.share.set = model
            self.networkManager.setNewUserData(model: model) {_ in}
            DispatchQueue.main.async {
                completion(numberOfWords - 1)
            }
        }
    }
}
