import UIKit


final class BaseLoaderView: UIView {
    enum TimerActivate {
        case active
        case reactive
    }

    private let backgroundBlureView: UIVisualEffectView = {
        let blure = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blure)
        view.layer.cornerRadius = 30
        view.clipsToBounds = true

        return view
    }()

    private let loaderView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.style = .large

        return loader
    }()

    private let crossButton = UIButton(type: .close)

    private let mainButton: BaseButton = {
        let button = BaseButton()

        return button
    }()

    private var endTime: Date?
    private var workItem: DispatchWorkItem?

    private var interval: Int?

    var didClose: (() -> ())?
    var didTapMainButtom: (() -> ())?

    init() {
        super.init(frame: .null)
        backgroundColor = .black.withAlphaComponent(0.5)
        setupNotification()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func removeFromSuperview() {
        super.removeFromSuperview()
        guard let item = workItem else { return }
        item.cancel()
    }

    func configure(model: BaseButton.Model) {
        mainButton.configure(with: model)
        mainButton.labelConfigure(buttonType: .defoultButton)
    }

    func runTimer(interval: Int = 60, activeType: TimerActivate) {
        let nowTime = Date()
        self.interval = interval
        mainButton.isEnabled = false

        switch activeType {
        case .active:
            endTime = nowTime + 60
        case .reactive:
            break
        }

        guard
            let endTime = endTime
        else { return }

        if nowTime >= endTime {
            mainButton.textLabel = "Resend"
            mainButton.isEnabled = true
        } else {
            let diffTime = interval - Int(endTime.timeIntervalSince(nowTime))
            print(diffTime)
            workItem = DispatchWorkItem {
                for second in diffTime...interval {
                    guard let item = self.workItem, !item.isCancelled else {
                        break
                    }
                    DispatchQueue.main.async {
                        self.mainButton.textLabel = "Resend after \(interval - second)"
                    }
                    sleep(1)
                }
                DispatchQueue.main.async {
                    self.mainButton.textLabel = "Resend"
                    self.mainButton.isEnabled = true
                }
            }

            guard let item = workItem else { return }
            DispatchQueue.global(qos: .userInitiated).async(execute: item)
        }
    }


    private func setupNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(appMovedToBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(appMovedForegraund),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }

    private func setup() {
        clipsToBounds = true
        layer.cornerRadius = 30
        addSubview(backgroundBlureView)
        backgroundBlureView.snp.makeConstraints { make in
            make.width.height.equalTo(250)
            make.center.equalToSuperview()
        }

        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(iconCloseClicked)
        )
        crossButton.isUserInteractionEnabled = true
        crossButton.addGestureRecognizer(tapGestureRecognizer)
        addSubview(crossButton)
        crossButton.snp.makeConstraints { make in
            make.trailing.equalTo(backgroundBlureView.snp.trailing).inset(15)
            make.top.equalTo(backgroundBlureView.snp.top).inset(15)
            make.height.width.equalTo(30)
        }

        addSubview(mainButton)
        mainButton.snp.makeConstraints { make in
            make.trailing.leading.equalTo(backgroundBlureView).inset(20)
            make.bottom.equalTo(backgroundBlureView.snp.bottom).inset(20)
            make.height.equalTo(40)
        }
        mainButton.didTap = { [weak self] in
            self?.didTapMainButtom?()
        }

        loaderView.startAnimating()
        addSubview(loaderView)
        loaderView.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(crossButton.snp.bottom)
            make.bottom.equalTo(mainButton.snp.top)
        }
    }

    @objc
    private func iconCloseClicked() {
        didClose?()
    }

    @objc
    func appMovedToBackground() {
        guard let workItem = workItem else { return }
        mainButton.textLabel = ""
        workItem.cancel()
    }

    @objc
    func appMovedForegraund() {
        guard let interval = interval else { return }
        runTimer(interval: interval, activeType: .reactive)
    }
}
