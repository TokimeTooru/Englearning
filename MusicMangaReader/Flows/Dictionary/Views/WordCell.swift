import UIKit


final class WordCell: UITableViewCell {
    enum Style {
        case info
        case none
    }

    private let enWordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .darkGray

        return label
    }()
    private let ruWordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .darkGray

        return label
    }()
    private lazy var exampleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .darkGray
        label.numberOfLines = 0

        return label
    }()
    private lazy var deleteButton: BaseLabelImageButton = {
        let button = BaseLabelImageButton(style: .little)
        button.configure(
            model: .init(text: "Delete", imageName: "cancel_icon"),
            style: .little
        )
        button.backgroundColor = .mainPoorColor
        
        return button
    }()

    var enText: String? {
        set {
            enWordLabel.text = newValue
        }
        get {
            return enWordLabel.text
        }
    }
    var ruText: String? {
        didSet {
            ruWordLabel.text = ruText
        }
    }

    var didDelete: (() -> ())?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setAppearence(style: Style, example: String) {
        switch style {
        case .none:
            backgroundColor = .mainWhite
            exampleLabel.removeFromSuperview()
            deleteButton.removeFromSuperview()
        case .info:
            backgroundColor = .mainGray
            addSubview(exampleLabel)
            exampleLabel.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(15)
                make.top.equalTo(enWordLabel.snp.bottom).offset(15)
            }
            exampleLabel.text = "Example: \(example)"
            enWordLabel.text = "\(enWordLabel.text ?? ""):"
            addSubview(deleteButton)
            deleteButton.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(15)
                make.bottom.equalToSuperview().inset(5)
                make.width.equalTo(85)
            }
            deleteButton.didTap = { [weak self] in
                self?.didDelete?()
            }
        }
    }

    private func setup() {
        addSubview(enWordLabel)
        enWordLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(15)
        }

        addSubview(ruWordLabel)
        ruWordLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(15)
        }
    }
}
