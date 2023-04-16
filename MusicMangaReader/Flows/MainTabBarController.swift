import UIKit


final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setup()
        setTabBarApperance()

    }

    private func setup() {
        let homeViewController = HomeAssembler.assembly()
        let homeTabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(named: "home_icon")?.scalePreservingAspectRatio(targetSize: CGSize(width: 34, height: 34)),
            tag: 0
        )
        homeViewController.tabBarItem = homeTabBarItem

        let profileViewController = ProfileAssembler.assembly()
        let profileTabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(named: "user_icon")?.scalePreservingAspectRatio(targetSize: CGSize(width: 34, height: 34)),
            tag: 1
        )
        profileViewController.tabBarItem = profileTabBarItem

        viewControllers = [homeViewController, profileViewController]
    }

    private func setTabBarApperance() {
        let positionOnX: CGFloat = 10
        let positionOnY: CGFloat = 14
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY * 2

        let roundLayer = CAShapeLayer()

        let bezierPath = UIBezierPath(
            roundedRect: CGRect(
                x: positionOnX,
                y: tabBar.bounds.minY - positionOnY,
                width: width,
                height: height
            ),
            cornerRadius: height / 2
        )
        roundLayer.path = bezierPath.cgPath

        tabBar.layer.insertSublayer(roundLayer, at: 0)
        tabBar.itemWidth = width / 3
        tabBar.itemPositioning = .centered

        roundLayer.fillColor = UIColor.mainWhite.cgColor
        tabBar.tintColor = .majourDarkColor
        tabBar.unselectedItemTintColor = .majourColor
    }
}


extension MainTabBarController: UITabBarControllerDelegate {
}
