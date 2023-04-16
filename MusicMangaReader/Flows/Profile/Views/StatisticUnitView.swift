import UIKit
import Lottie

final class StatisticUnitView: UIView {
    struct Model {
        let unitName: String
        let unitScore: String
    }
    
    enum AnimationStyle {
        case common(
            animationName: String? = nil,
            viewColor: UIColor = .mainWhite,
            borderColor: UIColor = .darkGray.withAlphaComponent(0.6)
        )
        case rare(
            animationName: String? = "rare_fire",
            viewColor: UIColor = .mainRareColor,
            borderColor: UIColor = .minorRareColor
        )
        case mistycal(
            animationName: String? = "mystical_fire",
            viewColor: UIColor = .mainMysticalColor,
            borderColor: UIColor = .minorMysticalColor
        )
        case legendary(
            animationName: String? = "legendary_fire",
            viewColor: UIColor = .mainLegendaryColor,
            borderColor: UIColor = .minorLegendaryColor
        )
    }
    enum UnitsKey {
        case wordsAdded
        case wordsMemorized
        case enemiesDefited
    }

    private let mainView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        view.backgroundColor = .mainWhite
        view.layer.borderWidth = 1.2
        view.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.2)

        return view
    }()
    private let unitNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .darkGray
        label.text = "Words Added"
        label.textAlignment = .center
        label.numberOfLines = 2

        return label
    }()
    private let unitDisplayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .darkGray
        label.text = "0"

        return label
    }()
    private let vMainContentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 10

        return stack
    }()

    private var animationView: LottieAnimationView?

    init() {
        super.init(frame: .null)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        setGradient()
    }

    private func setup() {
        addSubview(vMainContentStackView)
        vMainContentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mainView.addSubview(unitDisplayLabel)
        unitDisplayLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        vMainContentStackView.addArrangedSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(110)
        }
        vMainContentStackView.addArrangedSubview(unitNameLabel)
        unitNameLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }

    private func setGradient() {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.white.cgColor,
            UIColor.white.withAlphaComponent(0).cgColor,
            UIColor.white.cgColor
        ]
        layer.startPoint = CGPointMake(0.0, 0.5)
        layer.endPoint = CGPointMake(1.0, 0.5)
        guard let view = animationView else { return }
        layer.frame = view.bounds
        view.layer.addSublayer(layer)
    }

    func configurate(model: Model?) {
        unitNameLabel.text = model?.unitName ?? "Score"
        unitDisplayLabel.text = model?.unitScore ?? "0"
    }

    func setAppearens(style: AnimationStyle?) {
        guard let style = style else { return }
        switch style {
        case .common(_, let viewColor, let borderColor):
            mainView.backgroundColor = viewColor
            mainView.layer.borderColor = borderColor.cgColor
        case .rare(let animationName, let viewColor, let borderColor):
            mainView.backgroundColor = viewColor
            mainView.layer.borderColor = borderColor.cgColor
            guard let name = animationName else { return }
            setAnimation(animationName: name)
        case .mistycal(let animationName, let viewColor, let borderColor):
            mainView.backgroundColor = viewColor
            mainView.layer.borderColor = borderColor.cgColor
            unitDisplayLabel.textColor = .black.withAlphaComponent(0.8)
            guard let name = animationName else { return }
            setAnimation(animationName: name, flameSize: 20)
        case .legendary(let animationName, let viewColor, let borderColor):
            mainView.backgroundColor = viewColor
            mainView.layer.borderColor = borderColor.cgColor
            unitDisplayLabel.textColor = .black
            guard let name = animationName else { return }
            setAnimation(animationName: name, flameSize: 15)
        }
    }

    func stopAnimation() {
        guard let animationView = self.animationView else { return }
        animationView.removeFromSuperview()
    }

    private func setAnimation(animationName: String, flameSize: CGFloat = 30) {
        DispatchQueue.main.async {
            self.animationView = .init(name: animationName)
            guard let animationView = self.animationView else { return }
            animationView.layer.cornerRadius = 15
            self.insertSubview(animationView, at: 0)
            animationView.snp.makeConstraints { make in
                make.bottom.equalTo(self.snp.top).inset(flameSize)
                make.leading.trailing.equalToSuperview().inset(5)
                make.height.equalTo(100)
            }
            animationView.contentMode = .scaleToFill
            animationView.loopMode = .loop
            animationView.animationSpeed = 1
            animationView.play()
            self.layoutIfNeeded()
        }
    }
}
