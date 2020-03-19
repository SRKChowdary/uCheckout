//
//  LogInWireframe.swift
//  ABAuthenticator
//
//  Created by Michelle Louise Bosque on 8/19/19.
//

public class LogInWireframe {
    public class func assembleLogInView(config: LogInConfiguration? = nil, delegate: LogInMainViewBehavior?) -> UINavigationController {
        let viewController = LogInViewController()
        let presenter = LogInPresenter()
        let interactor = LogInInteractor()
        
        presenter.view = viewController
        presenter.interactor = interactor
        viewController.presenter = presenter
        viewController.config = config
        viewController.delegate = delegate
        interactor.output = presenter
        
        return UINavigationController(rootViewController: viewController)
    }
}
