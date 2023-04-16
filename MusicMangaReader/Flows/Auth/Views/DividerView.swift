import UIKit

final class DividerView: UIView {
    struct Model {
        let text: String
    }

    private enum GradientDiraction {
        case leftToRight
        case rightToLeft
    }

    private let dividerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = .white
        label.textAlignment = .center

        return label
    }()

    let dividerLineLeft = UIView()
    let dividerLineRight = UIView()

    private let hStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 15
        view.distribution = .fill

        return view
    }()

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        guard
            let gradientLayerLeft = dividerLineLeft.layer.sublayers?.first as? CAGradientLayer,
            let gradientLayerRight = dividerLineRight.layer.sublayers?.first as? CAGradientLayer
        else { return }
        gradientLayerLeft.frame = dividerLineLeft.bounds
        gradientLayerRight.frame = dividerLineRight.bounds
    }

    func configure(with model: Model) {
        dividerLabel.text = model.text
    }

    private func setup() {
        addSubview(hStackView)
        hStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        setupGradient(view: dividerLineLeft, diraction: GradientDiraction.leftToRight)
        setupGradient(view: dividerLineRight, diraction: GradientDiraction.rightToLeft)


        hStackView.addArrangedSubview(dividerLineLeft)
        dividerLineLeft.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(200)
            make.height.greaterThanOrEqualTo(1)
        }
        hStackView.addArrangedSubview(dividerLabel)
        dividerLabel.snp.makeConstraints { make in
            make.centerX.equalTo(hStackView.snp.centerX)
        }
        hStackView.addArrangedSubview(dividerLineRight)
        dividerLineRight.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(200)
            make.height.greaterThanOrEqualTo(1)
        }
    }

    private func setupGradient(view: UIView, diraction: GradientDiraction) {
        var gradientLayer: CAGradientLayer?
        switch diraction {
        case .rightToLeft:
        gradientLayer = {
            let layer = CAGradientLayer()
            layer.colors = [
                UIColor.white.cgColor,
                UIColor.clear.cgColor
            ]
            layer.startPoint = CGPointMake(0.0, 0.5)
            layer.endPoint = CGPointMake(1.0, 0.5)
            return layer
        }()
        case .leftToRight:
        gradientLayer = {
            let layer = CAGradientLayer()
            layer.colors = [
                UIColor.clear.cgColor,
                UIColor.white.cgColor
            ]
            layer.startPoint = CGPointMake(0.0, 0.5)
            layer.endPoint = CGPointMake(1.0, 0.5)
            return layer
        }()
        }

        guard let gradientLayer = gradientLayer else { return }
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
    }


}
