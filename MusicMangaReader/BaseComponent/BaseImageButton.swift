import UIKit


final class BaseImageButton: UIButton {
    struct Model {
        let nameImage: String
    }

    var didTap: (() -> ())?

    private let nameImage = "auth_defoult_icon"

    init() {
        super.init(frame: .zero)
        
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        setImage(UIImage(named: nameImage), for: .normal)
        layer.cornerRadius = 5
        clipsToBounds = true
        backgroundColor = .systemGray6
        addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)


    }

    func configure(with model: Model) {
        let imageView = UIImageView(image: UIImage(named: model.nameImage))
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self).inset(9)
            make.centerX.equalTo(self.snp.centerX)
            make.size.equalTo(24)
        }
    }

    @objc
    private func buttonClicked() {
        didTap?()
    }
}
