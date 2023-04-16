import UIKit


final class BaseLabelImageButton: UIButton {
    struct Model {
        let text: String
        let imageName: String
    }

    enum Style {
        case little
        case normal
    }

    var didTap: (() -> ())?

    private let mainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.tintColor = .darkText

        return label
    }()
    private let imageButtonImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .white.withAlphaComponent(0.3)
        view.layer.cornerRadius = 28
        view.layer.masksToBounds = false
        view.clipsToBounds = true
        view.contentMode = .center

        return view
    }()

    init(style: Style = .normal) {
        super.init(frame: .null)
        setup(style: style)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(model: Model, style: Style = .normal) {
        mainLabel.text = model.text
        let imageSize: CGSize
        switch style {
        case .normal:
            imageSize = CGSize(width: 36, height: 36)
        case .little:
            imageSize = CGSize(width: 24, height: 24)
        }
        let image = UIImage(named: model.imageName)?.scalePreservingAspectRatio(
            targetSize: imageSize
        )
        imageButtonImageView.image = image

    }

    func startAnimation() {
        let dur = 0.01
        UIView.animateKeyframes(withDuration: 10, delay: 1, options: [.repeat],
                  animations: {
                    UIView.addKeyframe(withRelativeStartTime: 0.0,
                                       relativeDuration: dur) {
                        self.imageButtonImageView.transform = CGAffineTransform(rotationAngle: -.pi/12)
                    }
                    UIView.addKeyframe(withRelativeStartTime: dur,
                                       relativeDuration: dur) {
                        self.imageButtonImageView.transform = CGAffineTransform(rotationAngle: +.pi/12)
                    }
                    UIView.addKeyframe(withRelativeStartTime: dur*2,
                                       relativeDuration: dur) {
                        self.imageButtonImageView.transform = CGAffineTransform(rotationAngle: -.pi/12)
                    }
                    UIView.addKeyframe(withRelativeStartTime: dur*3,
                                       relativeDuration: dur) {
                        self.imageButtonImageView.transform = CGAffineTransform(rotationAngle: +.pi/12)
                    }
                    UIView.addKeyframe(withRelativeStartTime: dur*4,
                                       relativeDuration: dur) {
                        self.imageButtonImageView.transform = CGAffineTransform(rotationAngle: -.pi/12)
                    }
                    UIView.addKeyframe(withRelativeStartTime: dur*5,
                                       relativeDuration: dur) {
                        self.imageButtonImageView.transform = CGAffineTransform(rotationAngle: +.pi/12)
                    }
                    UIView.addKeyframe(withRelativeStartTime: dur*6,
                                       relativeDuration: dur) {
                        self.imageButtonImageView.transform = CGAffineTransform(rotationAngle: -.pi/12)
                    }
                    UIView.addKeyframe(withRelativeStartTime: dur*7,
                                       relativeDuration: dur) {
                        self.imageButtonImageView.transform = CGAffineTransform(rotationAngle: +.pi/12)
                    }
                    UIView.addKeyframe(withRelativeStartTime: dur*8,
                                       relativeDuration: dur) {
                        self.imageButtonImageView.transform = CGAffineTransform(rotationAngle: -.pi/12)
                    }
                    UIView.addKeyframe(withRelativeStartTime: dur*9,
                                       relativeDuration: dur) {
                        self.imageButtonImageView.transform = CGAffineTransform.identity
                    }
                    UIView.addKeyframe(withRelativeStartTime: dur*10,
                                       relativeDuration: 0.9) {
                        self.imageButtonImageView.transform = CGAffineTransform.identity
                    }
                  },
                  completion: nil
                )
    }

    private func setup(style: Style) {
        let imageViewSize: CGFloat
        let leftInset: CGFloat
        switch style {
        case .normal:
            imageViewSize = 56
            leftInset = 15
        case .little:
            leftInset = 5
            imageViewSize = 24
            imageButtonImageView.layer.cornerRadius = 12
            mainLabel.font = UIFont.systemFont(ofSize: 13)
            mainLabel.textColor = .darkText.withAlphaComponent(0.7)
        }
        backgroundColor = .minorColor
        layer.cornerRadius = 15
        clipsToBounds = true

        addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)

        addSubview(imageButtonImageView)
        imageButtonImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leftInset)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(imageViewSize)
        }

        addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageButtonImageView.snp.trailing).offset(leftInset)
            make.centerY.equalToSuperview()
        }
    }

    @objc
    func buttonClicked() {
        didTap?()
    }
}
