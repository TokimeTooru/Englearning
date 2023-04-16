import UIKit

final class BaseButton: UIButton {
    struct Model {
        let text: String
    }

    enum ButtonType {
        case defoultButton
        case textButton
    }

    var didTap: (() -> ())?

    private let label = UILabel()
    private lazy var backButtonImage = UIImageView(image: UIImage(systemName: "pin"))
    private lazy var loaderView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.style = .medium

        return loader
    }()

    var textLabel: String {
        get { return "" }
        set(newValue) {
            label.text = newValue
        }
    }

    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        clipsToBounds = true
        addTarget(self, action: #selector(buttonClicked) , for: .touchUpInside)
        addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalTo(self.snp.center)
        }
    }
    
    func configure(with model: Model) {
        label.text = model.text
    }

    func startLoader() {
        isEnabled = false
        label.isHidden = true
        addSubview(loaderView)
        loaderView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        loaderView.startAnimating()
    }

    func stopLoader() {
        isEnabled = true
        loaderView.stopAnimating()
        guard loaderView.superview != nil else { return }
        loaderView.removeFromSuperview()
        label.isHidden = false

    }

    func labelConfigure(buttonType: BaseButton.ButtonType) {
        label.textAlignment = .center
        switch buttonType {
        case .defoultButton:
            label.textColor = .darkGray
            label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            layer.cornerRadius = 5
            backgroundColor = .minorColor
        case .textButton:
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            backgroundColor = .clear
            guard let text = label.text else { return }
            let textRange = NSRange(location: 0, length: text.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(.underlineStyle,
                                        value: NSUnderlineStyle.single.rawValue,
                                        range: textRange)
            label.attributedText = attributedText
        }
    }

    @objc
    private func buttonClicked() {
        didTap?()
    }
}
