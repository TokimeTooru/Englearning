import UIKit


final class BaseUserBarView: UIView {
    typealias VoidHandler = () -> ()
    struct Model {
        let imageTag: AvatarImage
        let nickname: String
        let level: String
        let currentExp: Float
    }

    enum Mode {
        case showMode
        case editMode
    }

    var userImageDidTap: VoidHandler?
    var userDidEditImage: VoidHandler?

    var didEndEditing: ((String) -> ())?

    private let userImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .mainGray
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 70 / 2
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill

        return view
    }()

    private let vStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillProportionally

        return stack
    }()

    private let hStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .bottom
        stack.axis = .horizontal
        stack.distribution = .fillProportionally

        return stack
    }()

    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "-----------"
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = .darkGray
        label.textAlignment = .left

        return label
    }()

    private let progressBar: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .bar)
        progress.trackTintColor = .lightGray.withAlphaComponent(0.5)
        progress.tintColor = .systemGreen
        progress.layer.cornerRadius = 1.5
        progress.clipsToBounds = true

        return progress
    }()

    private let levelLabel: UILabel = {
        let label = UILabel()
        label.text = "1 lvl"
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = .darkGray
        label.textAlignment = .right

        return label
    }()

    private lazy var plusImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "add_icon"))
        return view
    }()

    private lazy var editingImageView: UIImageView = {
        let view = UIImageView(
            image: UIImage(named: "editing_icon")?.scalePreservingAspectRatio(
                targetSize: CGSize(width: 18, height: 18)
            )
        )
        return view
    }()

    private lazy var usernameTextField: UITextField = {
        let field = UITextField()
        field.text = "Nickname"
        field.font = UIFont.systemFont(ofSize: 15, weight: .light)
        field.textColor = .darkGray

        return field
    }()

    private let mode: Mode

    init(mode: Mode) {
        self.mode = mode
        super.init(frame: .null)
        setup(mode: mode)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(model: Model) {
        userImageView.image = model.imageTag.getImage
        levelLabel.text = model.level
        progressBar.setProgress(model.currentExp, animated: true)
        switch mode {
        case .editMode:
            usernameTextField.text = model.nickname
        case .showMode:
            nicknameLabel.text = model.nickname
        }
    }

    func setupImage(image: UIImage) {
        userImageView.image = image
    }

    private func setup(mode: Mode) {
        layer.cornerRadius = 15
        clipsToBounds = true
        backgroundColor = .white

        addSubview(userImageView)
        userImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.height.equalTo(70)
            make.width.equalTo(70)
        }

        addSubview(vStackView)
        vStackView.addArrangedSubview(hStackView)
        vStackView.snp.makeConstraints { make in
            make.leading.equalTo(userImageView.snp.trailing).offset(15)
            make.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(30)
            make.height.equalTo(30)
        }

        switch mode {
        case .showMode:
            let tapGestureRecognizer = UITapGestureRecognizer(
                        target: self,
                        action: #selector(goToProfile)
                    )
            userImageView.isUserInteractionEnabled = true
            userImageView.addGestureRecognizer(tapGestureRecognizer)
            hStackView.addArrangedSubview(nicknameLabel)
            hStackView.addArrangedSubview(levelLabel)
            levelLabel.snp.makeConstraints { make in
                make.trailing.equalTo(vStackView.snp.trailing).inset(5)
            }
            vStackView.addArrangedSubview(progressBar)
            progressBar.snp.makeConstraints { make in
                make.height.equalTo(4)
                make.trailing.leading.equalToSuperview().inset(5)
            }
        case .editMode:
            let tapGestureRecognizer = UITapGestureRecognizer(
                        target: self,
                        action: #selector(editUserImage)
                    )
            userImageView.isUserInteractionEnabled = true
            userImageView.addGestureRecognizer(tapGestureRecognizer)

            addSubview(plusImageView)
            plusImageView.snp.makeConstraints { make in
                make.trailing.bottom.equalTo(userImageView)
            }

            usernameTextField.delegate = self
            hStackView.addArrangedSubview(textFieldWithImage())
            levelLabel.snp.makeConstraints { make in
                make.trailing.equalTo(vStackView.snp.trailing).inset(5)
            }

            vStackView.addArrangedSubview(progressBar)
            progressBar.snp.makeConstraints { make in
                make.height.equalTo(4)
                make.trailing.leading.equalToSuperview().inset(5)
            }
        }
    }

    private func textFieldWithImage() -> UIView {
        let container = UIView()
        container.backgroundColor = .clear
        container.addSubview(usernameTextField)
        usernameTextField.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        container.addSubview(editingImageView)
        editingImageView.snp.makeConstraints { make in
            make.leading.equalTo(usernameTextField.snp.trailing).offset(5)
            make.top.bottom.equalToSuperview()
        }

        container.addSubview(levelLabel)
        levelLabel.snp.makeConstraints { make in
            make.bottom.trailing.top.equalToSuperview()
        }

        return container
    }

    @objc
    private func goToProfile() {
        userImageDidTap?()
    }

    @objc
    private func editUserImage() {
        userDidEditImage?()
    }
}


extension BaseUserBarView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editingImageView.isHidden = true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.layer.borderColor = UIColor.clear.cgColor
        return true
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if range.location > 20 {
            return false
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        editingImageView.isHidden = false
        didEndEditing?(textField.text ?? "")
    }

}
