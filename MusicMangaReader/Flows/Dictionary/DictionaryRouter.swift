import Foundation


protocol DictionaryRouterProtocol {
    func nextFlow(flow: DictionaryRouter.Flow)
}


final class DictionaryRouter: DictionaryRouterProtocol {
    enum Flow {
        case back
        case addWord
    }

    weak var view: DictionaryViewController?

    private var dataSource: DictionaryInteractorDataSource?

    init(dataSource: DictionaryInteractorDataSource) {
        self.dataSource = dataSource
    }

    func nextFlow(flow: Flow) {
        switch flow {
        case .back:
            view?.navigationController?.popViewController(animated: true)
        case .addWord:
            let vc = AddWordAssembler.assembly()
            let fpc = AddWordFloatingController()
            fpc.set(contentViewController: vc)
            fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true

            vc.onChangeLayout = { [weak self] state in
                fpc.movePanel(state)
            }
            vc.didAddWord = { [weak self] enWord, ruWord, example, wordId in
                self?.dataSource?.getNewWordData(
                    enWord: enWord,
                    ruWord: ruWord,
                    example: example,
                    wordId: wordId
                )
            }

            guard let view = view else { return }
            view.present(fpc, animated: true)
        }
    }
}
