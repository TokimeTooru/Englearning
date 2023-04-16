import UIKit


final class BaseBackButtonView: UIView {
    enum Style {
        case black
        case white
    }
    var didTap: (() -> ())?

    private let backIconView: UIImageView = {
        var image = UIImage(named: "backLight.left")
        image = image?.scalePreservingAspectRatio(targetSize: CGSize(width: 24, height: 24))
        let view = UIImageView(image: image)
        return view
    }()
    private let backBlureView: UIVisualEffectView = {
        let blure = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blure)

        return view
    }()

    private let backLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Back"

        return label
    }()

    init(style: Style = .white) {
        super.init(frame: .zero)
        setAppearence(style: style)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setAppearence(style: Style) {
        switch style {
        case .white:
            backBlureView.effect = UIBlurEffect(style: .light)
        case .black:
            backBlureView.effect = UIBlurEffect(style: .systemThinMaterialDark)

        }
    }

    private func setup() {
        layer.cornerRadius = 15
        clipsToBounds = true

        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(testTarget))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)

        addSubview(backBlureView)
        backBlureView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        addSubview(backIconView)
        backIconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        addSubview(backLabel)
        backLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(backIconView.snp.trailing)
        }
    }

    @objc
    func testTarget() {
        didTap?()
    }
}
