import UIKit
import SnapKit
import FirebaseAuth
import FirebaseDatabase

protocol AuthViewControllerProtocol {
    func successLogin()
    func failLogin()
    func emailValidationDenaid()
    func passwordValidationDenaid()
}

class AuthViewController: UIViewController {
    private let backgroundImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "auth_background_ai"))
        view.contentMode = .scaleToFill
        
        return view
    }()

    private let blurEffectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .light)
        let view = UIVisualEffectView()
        view.effect = blur
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        
        return view
    }()

    private let vStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 15
        view.distribution = .fillProportionally
        return view
    }()

    private let hStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 15
        view.distribution = .fillEqually
        return view
    }()

    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Log in to account"
        label.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        label.textColor = .systemGray5
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()

    private let loginView = BaseTitleTextFieldView()
    private let passwordView = BaseTitleTextFieldView()

    private let loginButton = BaseButton()
    private let registartionButton = BaseButton()
    private let googleButton = BaseImageButton()
    private let appleButton = BaseImageButton()

    private let dividerView = DividerView()

    private let router: AuthRouterProtocol
    private let interactor: AuthInteractorProtocol

    init(router: AuthRouterProtocol, interactor: AuthInteractorProtocol) {
        self.router = router
        self.interactor = interactor
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
        setupBackground()
        setupContent()
    }

    private func setupBackground() {
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        backgroundImageView.addSubview(blurEffectView)
        blurEffectView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(15)
            make.centerY.equalTo(view.snp.centerY)
            make.height.greaterThanOrEqualTo(500)
        }
    }

    private func setupContent() {
        backgroundImageView.addSubview(loginLabel)
        loginLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(blurEffectView).inset(50)
            make.top.equalTo(blurEffectView.snp.top).inset(25)
        }
        

        makeLoginFields()
        makeAuthSocial()
        makeRegistration()
    }

    private func makeLoginFields() {
        loginView.configure(
            with: .init(
                titleText: "Login",
                placeholder: "@gmail.com"
            ),
            keyboardType: .emailAddress,
            tag: 0
        )
        loginView.mokeText(text: "yushkin860@mail.ru")
        loginView.didEndEditing = { [weak self] email in
            self?.interactor.emailValidation(with: email)
        }
        vStackView.addArrangedSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.trailing.leading.equalTo(vStackView).inset(20)
        }

        passwordView.mokeText(text: "yushkin860@mail.ru")
        passwordView.configure(with: .init(titleText: "Password", placeholder: "*******"), tag: 1)
        passwordView.didEndEditing = { [weak self] password in
            self?.interactor.passwordValidation(with: password)
        }
        passwordView.isSecureTextEntry = true
        vStackView.addArrangedSubview(passwordView)
        passwordView.snp.makeConstraints { make in
            make.trailing.leading.equalTo(vStackView).inset(20)
        }

        loginButton.configure(with: .init(text: "Log in"))
        loginButton.labelConfigure(buttonType: .defoultButton)
        loginButton.didTap = { [weak self] in
            guard let self = self else { return }
            self.loginButton.startLoader()
            self.interactor.loginRequest(email: self.loginView.text, password: self.passwordView.text)
        }

        vStackView.addArrangedSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.trailing.leading.equalTo(vStackView).inset(20)
        }

        view.addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.trailing.leading.equalTo(blurEffectView)
            make.top.equalTo(loginLabel.snp.bottom).offset(40)
        }
    }

    @objc func benpress() {
      print("//Your Code Here")
    }

    private func makeAuthSocial() {
        googleButton.configure(with: .init(nameImage: "auth_google_icon"))
        googleButton.didTap = { [weak self] in
            print("google")
        }
        hStackView.addArrangedSubview(googleButton)

        appleButton.configure(with: .init(nameImage: "auth_apple_icon"))
        appleButton.didTap = { [weak self] in
            print("apple")
        }
        hStackView.addArrangedSubview(appleButton)

        view.addSubview(hStackView)
        hStackView.snp.makeConstraints { make in
            make.trailing.leading.equalTo(blurEffectView).inset(50)
            make.top.equalTo(vStackView.snp.bottom).offset(20)
        }
    }

    private func makeRegistration() {
        dividerView.configure(with: .init(text: "or"))
        view.addSubview(dividerView)
        dividerView.snp.makeConstraints { make in
            make.centerX.equalTo(blurEffectView.snp.centerX)
            make.top.equalTo(hStackView.snp.bottom).offset(10)
            make.width.greaterThanOrEqualTo(100)
            make.height.greaterThanOrEqualTo(30)
            make.trailing.leading.equalTo(blurEffectView).inset(25)
        }
        dividerView.layoutIfNeeded()

        registartionButton.configure(with: .init(text: "registartion"))
        registartionButton.labelConfigure(buttonType: .textButton)
        registartionButton.didTap = { [weak self] in
            self?.router.nextFlowRouter(type: .registration)
        }
        view.addSubview(registartionButton)
        registartionButton.snp.makeConstraints { make in
            make.centerX.equalTo(blurEffectView.snp.centerX)
            make.top.equalTo(dividerView).offset(30)
            make.width.greaterThanOrEqualTo(100)
        }
    }
}

// MARK: - AuthViewControllerProtocol

extension AuthViewController: AuthViewControllerProtocol {
    func successLogin() {
        loginButton.stopLoader()
        loginView.changeBorderColor(with: .clear)
        passwordView.changeBorderColor(with: .clear)
        router.nextFlowRouter(type: .main)
    }

    func failLogin() {
        loginButton.stopLoader()
        loginView.changeBorderColor(with: .systemRed)
        passwordView.changeBorderColor(with: .systemRed)
    }

    func emailValidationDenaid() {
        loginView.changeBorderColor(with: .systemRed)
    }

    func passwordValidationDenaid() {
        passwordView.changeBorderColor(with: .systemRed)
    }
}

// MARK: - Keyboard dismiss

extension AuthViewController {
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
