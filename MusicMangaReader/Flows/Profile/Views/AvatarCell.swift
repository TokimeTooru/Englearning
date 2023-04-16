import UIKit

final class AvatarCell: UICollectionViewCell {
    private var avatarImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true

        return view
    }()

    private let checkImageView: UIImageView = {
        let view = UIImageView(
            image: UIImage(named: "check_icon")?.scalePreservingAspectRatio(targetSize: CGSize(width: 24, height: 24))
        )
        view.alpha = 0

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        layer.cornerRadius = 15
        clipsToBounds = true
        addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        addSubview(checkImageView)
        checkImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(7)
        }
    }

    func configur(image: UIImage) {
        avatarImageView.image = image
    }

    func pickAvatar() {
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: [.calculationModePaced]) {
            UIView.addKeyframe(withRelativeStartTime: 0.0,
                               relativeDuration: 2/3 * 0.3) {
                self.avatarImageView.transform = CGAffineTransform(scaleX: 0.87, y: 0.87)
                self.checkImageView.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 2/3 * 0.3,
                               relativeDuration: 1/3 * 0.3) {
                self.avatarImageView.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
            }
        }
    }

    func dropAvatar() {
        UIView.animate(withDuration: 0.1, delay: 0) {
            self.avatarImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.checkImageView.alpha = 0
        }
    }
}
