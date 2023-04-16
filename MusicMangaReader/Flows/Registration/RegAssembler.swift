import UIKit


final class RegAssembler {
    static func assembly() -> UIViewController {
        let presnter = RegPresenter()
        let interactor = RegInteraction(presenter: presnter)
        let router = RegRouter(dataSource: interactor)
        let viewController = RegViewController(interactor: interactor, router: router)

        presnter.viewController = viewController
        router.view = viewController

        return viewController
    }
}
