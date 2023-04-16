import UIKit

protocol RegViewControllerProtocol {
    func registrationResult(isReg: Bool)
    func emailValidationDenaid()
    func passwordValidationDenaid()
    func makeVerification()
}

final class RegViewController: UIViewController {
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "auth_background_ai"))
        imageView.contentMode = .scaleToFill

        return imageView
    }()
    private let backgroundBlureView: UIVisualEffectView = {
        let blure = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blure)
        view.layer.cornerRadius = 30
        view.clipsToBounds = true

        return view
    }()

    private let  flowNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        label.textAlignment = .center
        label.textColor = .systemGray5
        label.numberOfLines = 0
        label.text = "Registartion"

        return label
    }()
    private let vContentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 15
        stack.distribution = .fillProportionally

        return stack
    }()

    private lazy var loaderView = BaseLoaderView()

    private let loginTextField = BaseTitleTextFieldView()
    private let passwordTextField = BaseTitleTextFieldView()
    private let regButton = BaseButton()

    private let interactor: RegInteractorProtocol
    private let router: RegRouterProtocol
    var workItem: DispatchWorkItem?

    init(interactor: RegInteractorProtocol, router: RegRouterProtocol) {
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

    private func setup() {
        makeBackgroundContent()
        makeFrontContent()
        setupNavigationContent()
    }

    private func setupNavigationContent() {
        let view = BaseBackButtonView()
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: view)
        view.snp.makeConstraints { make in
            make.height.equalTo(35)
            make.width.equalTo(75)
        }
        view.didTap = { [weak self] in
            self?.router.goNextFlow(flow: .login)
        }
    }

    private func makeBackgroundContent() {
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }

        backgroundImageView.addSubview(backgroundBlureView)
        backgroundBlureView.snp.makeConstraints{ make in
            make.leading.trailing.equalTo(backgroundImageView).inset(15)
            make.centerY.equalTo(backgroundImageView.snp.centerY)
            make.height.greaterThanOrEqualTo(325)
        }
    }

    private func makeFrontContent() {
        makeFlowNameLabel()
        makeRegistartionContent()
    }

    private func makeFlowNameLabel() {
        view.addSubview(flowNameLabel)
        flowNameLabel.snp.makeConstraints{ make in
            make.trailing.leading.equalTo(backgroundBlureView).inset(20)
            make.top.equalTo(backgroundBlureView.snp.top).inset(20)
        }
    }

    private func makeRegistartionContent() {
        loginTextField.configure(
            with: .init(
                titleText: "Login",
                placeholder: "@gmail.com"
            ),
            keyboardType: .emailAddress,
            tag: 0
        )
        loginTextField.didEndEditing = { [weak self] email in
            self?.interactor.emailValidation(email: email)
        }
        vContentStack.addArrangedSubview(loginTextField)
        loginTextField.snp.makeConstraints{ make in
            make.trailing.leading.equalTo(vContentStack)
        }

        passwordTextField.configure(with: .init(titleText: "Password", placeholder: "******"), tag: 1)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.didEndEditing = { [weak self] passward in
            self?.interactor.passwordValidation(passward: passward)
        }
        vContentStack.addArrangedSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.trailing.leading.equalTo(vContentStack)
        }

        regButton.configure(with: .init(text: "Confirm"))
        regButton.labelConfigure(buttonType: .defoultButton)
        regButton.didTap = { [weak self] in
            self?.regButton.startLoader()
            self?.interactor.registrationRequest(
                email: self?.loginTextField.text ?? "",
                passward: self?.passwordTextField.text ?? ""
            )
        }
        vContentStack.addArrangedSubview(regButton)
        regButton.snp.makeConstraints { make in
            make.trailing.leading.equalTo(vContentStack)
        }

        view.addSubview(vContentStack)
        vContentStack.snp.makeConstraints{ make in
            make.trailing.leading.equalTo(backgroundBlureView).inset(20)
            make.top.equalTo(flowNameLabel.snp.bottom).offset(30)
        }
    }

}

// MARK: - RegViewControllerProtocol

extension RegViewController: RegViewControllerProtocol {
    func registrationResult(isReg: Bool) {
        guard isReg else {
            regButton.stopLoader()
            loginTextField.changeBorderColor(with: .systemRed)
            passwordTextField.changeBorderColor(with: .systemRed)

            return
        }
        
        router.goNextFlow(flow: .main)
    }

    func emailValidationDenaid() {
        loginTextField.changeBorderColor(with: .systemRed)
    }

    func passwordValidationDenaid() {
        passwordTextField.changeBorderColor(with: .systemRed)
    }

    func makeVerification() {
        navigationItem.leftBarButtonItem?.isHidden = true
        loaderView.configure(model: .init(text: "Resend after 60"))
        view.addSubview(loaderView)
        loaderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loaderView.runTimer(activeType: .active)

        loaderView.didTapMainButtom = { [weak self] in
            self?.loaderView.runTimer(activeType: .active)
            self?.interactor.resendVerification()
        }

        loaderView.didClose = { [weak self] in
            self?.regButton.stopLoader()
            self?.interactor.deleteNotVerifideUser()
            self?.loaderView.removeFromSuperview()
            self?.navigationItem.leftBarButtonItem?.isHidden = false
        }
    }
}

// MARK: - Keyboard dismiss

extension RegViewController {
    private func dismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(dismissKeyboardTouchOutside))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc
    private func dismissKeyboardTouchOutside() {
        view.endEditing(true)
    }
}
