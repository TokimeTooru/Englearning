import UIKit

protocol HomeRouterProtocol {
    func nextFlow(with type: HomeRouter.NextFlow)
}


final class HomeRouter: HomeRouterProtocol {
    enum NextFlow {
        case profile
        case dictionary
        case room
        case fastStart
    }

    weak var view: UIViewController?

    func nextFlow(with type: NextFlow) {
        switch type {
        case .profile:
            guard
                let tab = view?.tabBarController,
                let profile = tab.viewControllers?[1]
            else { return }
            tab.selectedViewController = profile
        case .dictionary:
            let vc = DictionaryAssembler.assembly()
            view?.navigationController?.pushViewController(vc, animated: true)
        case .room:
            print("Go to Room")
        case .fastStart:
            print("Go to Fast Start")
        }
    }
    
}
