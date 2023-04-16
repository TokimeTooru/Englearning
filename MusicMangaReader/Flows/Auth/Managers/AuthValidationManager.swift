import Foundation

enum AuthValidationType {
    case email(String)
    case password(String)
}

protocol AuthValidationManagerProtocol {
    func validation(type: AuthValidationType) -> Bool
}

final class AuthValidationManager: AuthValidationManagerProtocol {
    func validation(type: AuthValidationType) -> Bool {
        switch type {
        case .email(let email):
            return isValidEmail(with: email)
        case .password(let password):
            return isValidPassword(with: password)
        }
    }

    private func isValidEmail(with email: String) -> Bool {
        let emailRegEx = "([A-z0-9!#$%&'*+-/=?^_`{|}~]){1,64}@([a-z0-9!#$%&'*+-/=?^_`{|}~]){1,64}\\.([A-z0-9]){2,64}" 
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    private func isValidPassword(with password: String) -> Bool {
        guard password.isEmpty else { return true }
        return false
    }
}
