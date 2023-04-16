import Foundation
import UIKit


protocol DictionaryViewControllerProtocol {
    func setDictionaryModel(dictionary: [DictionaryPresenter.DictionaryKey: [DictionaryPresenter.DictionaryModel]])
    func addNewWord(model: DictionaryPresenter.DictionaryModel)
    func removeWord(indexPath: IndexPath)
}


final class DictionaryViewController: UIViewController {
    private let interactor: DictionaryInteractorProtocol
    private let router: DictionaryRouterProtocol

    private var dictionaryModel: [DictionaryPresenter.DictionaryKey: [DictionaryPresenter.DictionaryModel]]?

    private let dictionaryView: UITableView = {
        let tv = UITableView()
        tv.layer.cornerRadius = 15
        tv.clipsToBounds = true
        tv.backgroundColor = UIColor.white
        tv.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        tv.allowsMultipleSelection = false
        tv.allowsSelection = true

        return tv
    }()
    private let flowNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.text = "Dictionary"
        label.textColor = .darkText.withAlphaComponent(0.8)

        return label
    }()
    private let addWordButton = BaseButton()
    private let wordsLoader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.style = .medium

        return loader
    }()

    private var selectedIndex: IndexPath = IndexPath(row: -1, section: -1)
    private var deselectedIndex: IndexPath?

    init(interactor: DictionaryInteractorProtocol, router: DictionaryRouterProtocol) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        view.backgroundColor = .mainGray
        setNavigationBackButton()
        setLoader()
        interactor.getDictionaryModel()
        setup()
    }

    private func setNavigationBackButton() {
        let view = BaseBackButtonView(style: .black)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: view)
        view.snp.makeConstraints { make in
            make.height.equalTo(35)
            make.width.equalTo(75)
        }
        view.didTap = { [weak self] in
            self?.router.nextFlow(flow: .back)
        }
    }

    private func setLoader() {
        view.addSubview(wordsLoader)
        wordsLoader.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(40)
        }
        wordsLoader.startAnimating()
    }

    private func setup() {
        view.addSubview(flowNameLabel)
        flowNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(25)
        }

        dictionaryView.register(WordCell.self, forCellReuseIdentifier: "cellId")
        dictionaryView.delegate = self
        dictionaryView.dataSource = self
        view.addSubview(dictionaryView)
        dictionaryView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(15)
            make.top.equalTo(flowNameLabel.snp.bottom).offset(20)
            make.bottom.equalToSuperview().inset(150)
        }
        addWordButton.configure(with: .init(text: "Add word"))
        addWordButton.labelConfigure(buttonType: .defoultButton)
        view.addSubview(addWordButton)
        addWordButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(dictionaryView.snp.bottom).offset(15)
            make.height.equalTo(50)
        }
        addWordButton.didTap = { [weak self] in
            self?.router.nextFlow(flow: .addWord)
        }
    }
}


extension DictionaryViewController: DictionaryViewControllerProtocol {
    func setDictionaryModel(dictionary: [DictionaryPresenter.DictionaryKey: [DictionaryPresenter.DictionaryModel]]) {
        dictionaryModel = dictionary
        DispatchQueue.main.async {
            self.dictionaryView.reloadData()
            self.wordsLoader.stopAnimating()
            self.wordsLoader.isHidden = true
        }
    }

    func addNewWord(model: DictionaryPresenter.DictionaryModel) {
        guard dictionaryModel != nil else { return }
        dictionaryModel?[.new]?.insert(model, at: 0)
        dictionaryView.beginUpdates()
        if dictionaryModel?[.new]?.count == 1 {
            dictionaryView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
        dictionaryView.insertRows(
            at: [IndexPath(row: 0, section: 0)],
            with: .automatic
        )
        dictionaryView.endUpdates()
    }

    func removeWord(indexPath: IndexPath) {
        dictionaryView.beginUpdates()
        switch indexPath.section {
        case 0:
            dictionaryModel?[.new]?.remove(at: indexPath.row)
            if dictionaryModel?[.new]?.count == 0 {
                dictionaryView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
        case 1:
            dictionaryModel?[.learned]?.remove(at: indexPath.row)
            if dictionaryModel?[.new]?.count == 0 {
                dictionaryView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            }
        case 2:
            dictionaryModel?[.poorly]?.remove(at: indexPath.row)
            if dictionaryModel?[.new]?.count == 0 {
                dictionaryView.insertRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
            }
        case 3:
            dictionaryModel?[.process]?.remove(at: indexPath.row)
            if dictionaryModel?[.new]?.count == 0 {
                dictionaryView.insertRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
            }
        default:
            break
        }
        dictionaryView.deleteRows(at: [indexPath], with: .automatic)
        selectedIndex = IndexPath(row: -1, section: -1)
        dictionaryView.endUpdates()
    }
}

extension DictionaryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dictionaryModel = dictionaryModel else { return 1 }
        switch section {
        case 0:
            return dictionaryModel[.new]?.count == 0 ? 1 : dictionaryModel[.new]?.count ?? 1
        case 1:
            return dictionaryModel[.learned]?.count == 0 ? 1 : dictionaryModel[.learned]?.count ?? 1
        case 2:
            return dictionaryModel[.poorly]?.count == 0 ? 1 : dictionaryModel[.poorly]?.count ?? 1
        case 3:
            return dictionaryModel[.process]?.count == 0 ? 1 : dictionaryModel[.process]?.count ?? 1
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? WordCell
        else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        guard let dictionaryModel = dictionaryModel else {
            cell.ruText = ""
            cell.enText = "There is nothing here yet"
            cell.setAppearence(style: .none, example: "")
            return cell
        }
        var data: DictionaryPresenter.DictionaryModel?
        switch indexPath.section {
        case 0:
            guard dictionaryModel[.new]?.count != 0 else {
                cell.ruText = ""
                cell.enText = "There is nothing here yet"
                cell.setAppearence(style: .none, example: "")
                return cell
            }
            data = dictionaryModel[.new]?[indexPath.row]
        case 1:
            guard dictionaryModel[.learned]?.count != 0 else {
                cell.ruText = ""
                cell.enText = "There is nothing here yet"
                cell.setAppearence(style: .none, example: "")
                return cell
            }
            data = dictionaryModel[.learned]?[indexPath.row]
        case 2:
            guard dictionaryModel[.poorly]?.count != 0 else {
                cell.ruText = ""
                cell.enText = "There is nothing here yet"
                cell.setAppearence(style: .none, example: "")
                return cell
            }
            data = dictionaryModel[.poorly]?[indexPath.row]
        case 3:
            guard dictionaryModel[.process]?.count != 0 else {
                cell.ruText = ""
                cell.enText = "There is nothing here yet"
                cell.setAppearence(style: .none, example: "")
                return cell
            }
            data = dictionaryModel[.process]?[indexPath.row]

        default:
            cell.ruText = "There is nothing here yet"
            cell.ruText = ""
            cell.setAppearence(style: .none, example: "")
            return cell
        }
        cell.enText = data?.enWord
        cell.ruText = data?.ruWord

        if selectedIndex == indexPath {
            cell.setAppearence(style: .info, example: data?.example ?? "Error")
        } else {
            cell.setAppearence(style: .none, example: data?.example ?? "Error")
        }
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView?.backgroundColor = .clear
        cell.didDelete = { [weak self] in
            guard let data = data else { return }
            self?.interactor.removeWord(wordId: data.wordId, indexPath: indexPath)
        }

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "New words"
        case 1:
            return "Words learned"
        case 2:
            return "Words poorly learned"
        case 3:
            return "Words in process"
        default:
            return "Unknown"
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        switch section {
        case 0:
            header.textLabel?.textColor = .mainRareColor
        case 1:
            header.textLabel?.textColor = .mainLegendaryColor
        case 2:
            header.textLabel?.textColor = .mainPoorColor
        case 3:
            header.textLabel?.textColor = .mainMysticalColor
        default:
            return
        }
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard
            let cell = tableView.cellForRow(at: indexPath) as? WordCell,
            cell.enText != "There is nothing here yet"
        else { return nil }
        return indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == selectedIndex{
            selectedIndex = IndexPath(row: -1, section: -1)
        } else {
            selectedIndex = indexPath
        }
        guard
            let deselectedIndex = deselectedIndex
        else {
            tableView.reloadRows(at: [indexPath], with: .automatic)
            self.deselectedIndex = indexPath
            return
        }
        tableView.reloadRows(at: [indexPath, deselectedIndex], with: .automatic)
        self.deselectedIndex = indexPath
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndex
        {
            return 175
        } else {
            return 45
        }
    }

}
