import Foundation


protocol ProfileValidationManagerProtocol {
    func validation(with type: ProfileValidationManager.ValidType) -> Bool
}


final class ProfileValidationManager: ProfileValidationManagerProtocol {
    enum ValidType {
        case username(String)
    }

    func validation(with type: ProfileValidationManager.ValidType) -> Bool {
        switch type {
        case .username (let username):
            return isUserValid(with: username)
        }
    }

    private func isUserValid(with username: String) -> Bool {
        guard !username.isEmpty else { return false }
        let userRegEx = "([A-z0-9_]){3,16}"
        let userPred = NSPredicate(format:"SELF MATCHES %@", userRegEx)
        return userPred.evaluate(with: username)
    }
}
