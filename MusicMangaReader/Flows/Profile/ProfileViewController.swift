import UIKit


protocol ProfileViewControllerProtocol {
    func changeAvatar(image: UIImage)
    func setUserData(model: BaseUserBarView.Model)
    func setUnitsData(models: [StatisticUnitView.UnitsKey: StatisticUnitView.Model])
    func setUnitsAppearens(style: [StatisticUnitView.UnitsKey: StatisticUnitView.AnimationStyle])
}


final class ProfileViewController: UIViewController {
    private let interactor: ProfileInteractorProtocol
    private let router: ProfileRouterProtocol

    private let userBarView = BaseUserBarView(mode: .editMode)
    private let statView: UIView = {
        let statView = UIView()
        statView.layer.cornerRadius = 15
        statView.clipsToBounds = true
        statView.backgroundColor = .mainWhite

        return statView
    }()
    private let wordsAddedView = StatisticUnitView()
    private let wordsLearnedView = StatisticUnitView()
    private let enemyesDefited = StatisticUnitView()
    private let statisticScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .clear
        scroll.layer.cornerRadius = 15
        scroll.clipsToBounds = true

        return scroll
    }()
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.text = "Statistics"
        label.textColor = .darkText.withAlphaComponent(0.8)

        return label
    }()
    private let hMainContentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 20

        return stack
    }()

    init(interactor: ProfileInteractorProtocol, router: ProfileRouterProtocol) {
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
        interactor.reloadUserData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        wordsAddedView.stopAnimation()
        enemyesDefited.stopAnimation()
        wordsLearnedView.stopAnimation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor.getDataForUnits()
    }

    private func setup() {
        view.backgroundColor = .mainGray
        setUserBar()
        setStatisticField()
    }

    private func setUserBar() {
        view.addSubview(userBarView)
        userBarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(95)
        }

        userBarView.userDidEditImage = { [weak self] in
            self?.router.nextFlow(type: .images)
        }

        userBarView.didEndEditing = { [weak self] text in
            self?.interactor.usernameValidation(username: text)
        }
    }

    private func setStatisticField() {
        view.addSubview(statisticScrollView)
        statisticScrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(userBarView.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        statisticScrollView.layoutIfNeeded()
        statisticScrollView.setNeedsLayout()

        statisticScrollView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(15)
        }
        statisticScrollView.addSubview(statView)
        statView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview()
            make.width.equalTo(statisticScrollView.bounds.width)
            make.height.equalTo(230)
        }

        statView.addSubview(hMainContentStackView)
        hMainContentStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        hMainContentStackView.addArrangedSubview(wordsAddedView)
        wordsAddedView.snp.makeConstraints { make in
            make.height.equalTo(170)
        }

        hMainContentStackView.addArrangedSubview(wordsLearnedView)
        hMainContentStackView.addArrangedSubview(enemyesDefited)
    }
}

extension ProfileViewController: ProfileViewControllerProtocol {
    func setUnitsAppearens(style: [StatisticUnitView.UnitsKey: StatisticUnitView.AnimationStyle]) {
        wordsAddedView.setAppearens(style: style[.wordsAdded])
        wordsLearnedView.setAppearens(style: style[.wordsMemorized])
        enemyesDefited.setAppearens(style: style[.enemiesDefited])
    }

    func changeAvatar(image: UIImage) {
        userBarView.setupImage(image: image)
    }

    func setUserData(model: BaseUserBarView.Model) {
        userBarView.configure(model: model)
    }

    func setUnitsData(models: [StatisticUnitView.UnitsKey: StatisticUnitView.Model]) {
        wordsAddedView.configurate(model: models[.wordsAdded])
        wordsLearnedView.configurate(model: models[.wordsMemorized])
        enemyesDefited.configurate(model: models[.enemiesDefited])
    }
}

extension ProfileViewController {
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
