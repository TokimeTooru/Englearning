import Foundation
import UIKit
import FloatingPanel

protocol AddWordViewControllerProtocol {
    func enWordDeniedValidation()
    func ruWordDeniedValidation()
    func wordAddingDenied()
}


final class AddWordViewController: UIViewController, AddWordViewControllerProtocol {
    typealias ChangeLayoutHandler = (FloatingPanelState) -> ()

    var onChangeLayout: ChangeLayoutHandler?
    var didAddWord: ((String, String, String, Int) -> ())?

    private let interactor: AddWordInteractorProtocol
    private let router: AddWordRouterProtocol

    private let flowNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.text = "Add new word"
        label.textColor = .darkText.withAlphaComponent(0.8)

        return label
    }()
    private let enWordField = BaseTitleTextFieldView()
    private let ruWordField = BaseTitleTextFieldView()
    private let exampleField = BaseTitleTextFieldView()
    private let addWordButton: BaseButton = {
        let button = BaseButton()
        button.configure(with: .init(text: "Add word"))
        button.labelConfigure(buttonType: .defoultButton)

        return button
    }()

    init(interactor: AddWordInteractorProtocol, router: AddWordRouterProtocol) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboard()
        setup()
    }

    func enWordDeniedValidation() {
        enWordField.changeBorderColor(with: .systemRed)
    }

    func ruWordDeniedValidation() {
        ruWordField.changeBorderColor(with: .systemRed)
    }

    func wordAddingDenied() {
        enWordField.changeBorderColor(with: .systemRed)
        ruWordField.changeBorderColor(with: .systemRed)
    }

    private func setup() {
        setupNotification()
        view.backgroundColor = .mainGray
        view.addSubview(flowNameLabel)
        flowNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(25)
        }
        view.addSubview(enWordField)
        enWordField.snp.makeConstraints { make in
            make.top.equalTo(flowNameLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        enWordField.configure(with: .init(titleText: "English word: ", placeholder: "Dog"), tag: 0)
        enWordField.didEndEditing = { [weak self] text in
            self?.interactor.enWordValidation(text: text)
        }
        view.addSubview(ruWordField)
        ruWordField.snp.makeConstraints { make in
            make.top.equalTo(enWordField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        ruWordField.configure(with: .init(titleText: "Перевод: ", placeholder: "Собака"), tag: 1)
        ruWordField.didEndEditing = { [weak self] text in
            self?.interactor.ruWordValidation(text: text)
        }
        view.addSubview(exampleField)
        exampleField.snp.makeConstraints { make in
            make.top.equalTo(ruWordField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        exampleField.configure(
            with: .init(
                titleText: "Use case: ",
                placeholder: "A DOG is a man's friend"),
            tag: 2
        )
        view.addSubview(addWordButton)
        addWordButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(45)
            make.top.equalTo(exampleField.snp.bottom).offset(40)
            make.height.equalTo(50)
        }
        addWordButton.didTap = { [weak self] in
            self?.interactor.setNewWord(
                enWord: self?.enWordField.text ?? "",
                ruWord: self?.ruWordField.text ?? "",
                example: self?.exampleField.text ?? " "
            ) { wordId in
                self?.didAddWord?(
                    self?.enWordField.text ?? "",
                    self?.ruWordField.text ?? "",
                    self?.exampleField.text ?? " ",
                    wordId
                )
            }

            self?.dismiss(animated: true)
        }
    }

    private func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}

// MARK: - Keyboard dismiss
extension AddWordViewController {
    private func dismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(dismissKeyboardTouchOutside))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc
    private func dismissKeyboardTouchOutside() {
        view.endEditing(true)
    }

    @objc
    func keyboardWillShow(_ notification: Notification) {
        onChangeLayout?(.full)
    }

    @objc
    func keyboardWillHide(_ notification: Notification) {
        onChangeLayout?(.half)
    }
}
