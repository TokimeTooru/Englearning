import UIKit
import FirebaseAuth

protocol HomeViewControllerProtocol {
    func setUserData(model: BaseUserBarView.Model)
}

final class HomeViewController: UIViewController {
    private var interactor: HomeInteractorProtocol
    private var router: HomeRouterProtocol

    private let userBarView = BaseUserBarView(mode: .showMode)
    private let contentTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .white

        return table
    }()
    private let vMainContentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.backgroundColor = .white
        stack.spacing = 10
        stack.layer.cornerRadius = 15
        stack.clipsToBounds = true

        return stack
    }()

    private let dictionaryButton: BaseLabelImageButton = {
        let button = BaseLabelImageButton()
        button.configure(model: .init(text: "Dictionary", imageName: "dictionary_icon"))
        return button
    }()
    private let roomButton: BaseLabelImageButton = {
        let button = BaseLabelImageButton()
        button.configure(model: .init(text: "Rooms", imageName: "room_icon"))
        return button
    }()
    private let fastStartButton: BaseLabelImageButton = {
        let button = BaseLabelImageButton()
        button.configure(model: .init(text: "Fast start", imageName: "fastStart_icon"))
        return button
    }()

    init(interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.interactor = interactor
        self.router = router

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainGray
        setup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fastStartButton.startAnimation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.reloadUserData()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func setup() {
        makeUserBar()
        makeMainContent()
    }

    private func makeUserBar() {
        view.addSubview(userBarView)
        userBarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(95)
        }

        userBarView.userImageDidTap = { [weak self] in
            self?.router.nextFlow(with: .profile)
        }
    }

    private func makeMainContent() {
        let backView = UIView()
        backView.backgroundColor = .white
        backView.layer.cornerRadius = 15
        backView.clipsToBounds = true

        view.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(10)
            make.top.equalTo(userBarView.snp.bottom).offset(30)
        }

        view.addSubview(vMainContentStackView)
        vMainContentStackView.snp.makeConstraints { make in
            make.edges.equalTo(backView).inset(15)
        }

        vMainContentStackView.addArrangedSubview(dictionaryButton)
        dictionaryButton.snp.makeConstraints { make in
            make.height.equalTo(70)
        }

        dictionaryButton.didTap = { [weak self] in
            self?.router.nextFlow(with: .dictionary)
        }
        vMainContentStackView.addArrangedSubview(roomButton)
        roomButton.didTap = { [weak self] in
            self?.router.nextFlow(with: .room)
        }

        fastStartButton.backgroundColor = .majourColor
        view.addSubview(fastStartButton)
        fastStartButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25)
            make.bottom.equalToSuperview().inset(120)
            make.height.equalTo(70)
        }
        fastStartButton.didTap = { [weak self] in
            self?.router.nextFlow(with: .fastStart)
        }
    }
}


extension HomeViewController: HomeViewControllerProtocol {
    func setUserData(model: BaseUserBarView.Model) {
        userBarView.configure(model: model)
    }
}

