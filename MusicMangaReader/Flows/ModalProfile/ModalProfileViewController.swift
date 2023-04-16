import UIKit


protocol ModalProfileViewControllerProtocol {

}

struct AvatarModel {
    let cells: [AvatarImage]
}

final class ModalProfilViewController: UIViewController, ModalProfileViewControllerProtocol {
    let interactor: ModalProfileInteractorProtocol

    var choosenAvatarTag: AvatarImage?
    var didAcceptChanges: ((AvatarImage) -> ())?

    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 15, bottom: 10, right: 15)
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 50) / 3, height: (UIScreen.main.bounds.width - 50) / 3)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        return layout
    }()

    private lazy var acceptButton = BaseButton()

    private lazy var contentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    private let model = AvatarModel(cells: [.cat, .cat2, .mouse, .wolf, .rabbit, .japan, .japan2, .japan3, .japan4])

    init(interactor: ModalProfileInteractorProtocol) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        contentCollectionView.contentMode = .scaleToFill
        contentCollectionView.register(AvatarCell.self, forCellWithReuseIdentifier: "Avatar")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        let label: UILabel = {
            let label = UILabel()
            label.text = "Choose an avatar"
            label.font = UIFont.systemFont(ofSize: 34)
            label.textColor = .darkGray

            return label
        }()
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(20)
        }
        view.addSubview(contentCollectionView)
        contentCollectionView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom)
            make.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview().inset(85)
        }
        view.addSubview(acceptButton)
        acceptButton.configure(with: .init(text: "Accept"))
        acceptButton.labelConfigure(buttonType: .defoultButton)
        acceptButton.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(50)
            make.top.equalTo(contentCollectionView.snp.bottom)
            make.height.equalTo(45)
        }
        acceptButton.didTap = { [weak self] in
            self?.dismiss(animated: true)
            guard let tag = self?.choosenAvatarTag else { return }
            self?.interactor.setNewUserData(tag: tag)
            self?.didAcceptChanges?(tag)
        }
    }
}

extension ModalProfilViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.cells.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Avatar", for: indexPath) as? AvatarCell else { return UICollectionViewCell() }
        cell.configur(image: model.cells[indexPath.row].getImage)
        let mode = model.cells[0]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? AvatarCell else { return }
        choosenAvatarTag = model.cells[indexPath.row]
        cell.pickAvatar()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? AvatarCell else { return }
        cell.dropAvatar()
    }
}
