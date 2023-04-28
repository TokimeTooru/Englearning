import Foundation


protocol DictionaryPresenterProtocol {
    func prepearDictionaryModel(model: [Word]?)
    func addNewWord(word: DictionaryPresenter.DictionaryModel)
    func removeWord(indexPath: IndexPath)
}


final class DictionaryPresenter: DictionaryPresenterProtocol {
    struct DictionaryModel {
        let enWord: String
        let ruWord: String
        let example: String
        let wordId: Int
    }

    enum DictionaryKey: String {
        case new = "New Words"
        case learned = "Words Learned"
        case poorly = "Words Poorly Learned"
        case process = "Words in process"
    }
    var view: DictionaryViewControllerProtocol?

    func prepearDictionaryModel(model: [Word]?) {
        var dictionary: [DictionaryKey: [DictionaryModel]] = [
            .new: [],
            .learned: [],
            .poorly: [],
            .process: []
        ]
        guard let model else {
            view?.setDictionaryModel(dictionary: dictionary)
            return
        }
        for word in model {
            let dictWord: DictionaryModel = .init(
                enWord: word.enWord,
                ruWord: word.ruWord,
                example: word.examples,
                wordId: word.wordId
            )
            switch word.statusTag {
            case 0:
                dictionary[.new]?.append(dictWord)
            case 1:
                dictionary[.learned]?.append(dictWord)
            case 2:
                dictionary[.poorly]?.append(dictWord)
            case 3:
                dictionary[.process]?.append(dictWord)
            default:
                return
            }
        }
        view?.setDictionaryModel(dictionary: dictionary)
    }

    func addNewWord(word: DictionaryModel) {
        view?.addNewWord(model: word)
    }

    func removeWord(indexPath: IndexPath) {
        guard let view = view else { return }
        view.removeWord(indexPath: indexPath)
    }
}
