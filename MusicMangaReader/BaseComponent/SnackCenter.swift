import UIKit


final class SnackCenter {
    static var shared = SnackCenter()
    private let snackView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.alpha = 0

        return view
    }()

    private let snackLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)

        return label
    }()

    enum Style {
        case base
        case success
        case error
    }
    private var isAnimated = false
    
    func showSnack(text: String, style: Style) {
        guard
            let rootView = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.first
        else { return }
        if snackLabel.superview == nil {
            snackView.addSubview(snackLabel)
        }
        if !isAnimated {
            snackLabel.text = text
            switch style {
            case .error:
                snackView.backgroundColor = .systemRed.withAlphaComponent(0.8)
                snackLabel.textColor = .white
            case .base:
                snackView.backgroundColor = .white
            case .success:
                snackView.backgroundColor = .systemGreen
            }
            snackLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }

            rootView.addSubview(snackView)
            snackView.snp.makeConstraints { make in
                make.trailing.leading.equalToSuperview().inset(15)
                make.top.equalTo(rootView.safeAreaLayoutGuide.snp.top).inset(15)

                make.height.greaterThanOrEqualTo(35)
            }
            isAnimated = true
            UIView.animate(withDuration: 0.6, delay: 0.2, options: .curveEaseOut, animations: {
                self.snackView.alpha = 1
            }) { finished in
                if finished {
                    UIView.animate(withDuration: 1, delay: 3.3, options: .curveEaseOut, animations: {
                        self.snackView.alpha = 0
                    }) { finished in
                        if finished {
                            self.snackView.removeFromSuperview()
                            self.isAnimated = false
                        }
                    }
                }
            }
        }
    }
}
