import UIKit

final class BaseTitleTextFieldView: UIView {
    struct Model {
        let titleText: String
        let placeholder: String
    }

    private let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = .darkGray
        label.textAlignment = .left
        
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 0.6
        textField.layer.borderColor = UIColor.clear.cgColor

        return textField
    }()

    var isSecureTextEntry: Bool {
        get { return false }
        set(newValue) {
            textField.isSecureTextEntry = newValue
        }
    }

    var text: String {
        return textField.text ?? ""
    }

    var didEndEditing: ((String) -> ())?
    var didKeyboardDissmis: (() -> ())?
    
    init() {
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(title)
        title.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self)
        }
        
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self)
            make.top.equalTo(title.snp.bottom).offset(5)
            make.height.equalTo(40)
        }
        textField.delegate = self
    }

    func mokeText(text: String) {
        textField.text = text
    }

    func changeBorderColor(with color: UIColor) {
        textField.layer.borderColor = color.cgColor
    }
    
    func configure(with model: Model, keyboardType: UIKeyboardType = .default, tag: Int? = nil) {
        title.text = model.titleText
        textField.placeholder = model.placeholder
        textField.keyboardType = keyboardType
        guard let tag = tag else { return }
        self.tag = tag
        textField.tag = tag
    }
}

extension BaseTitleTextFieldView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.layer.borderColor = UIColor.clear.cgColor
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.superview?.viewWithTag(textField.tag + 1) as? BaseTitleTextFieldView {
            nextField.textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return false
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if range.location > 35 {
            return false
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        didEndEditing?(textField.text ?? "")
    }

}
