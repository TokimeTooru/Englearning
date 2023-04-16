protocol AddWordValidationManagerProtocol {
    func isValid(text: String, type: AddWordValidationManger.ValidType) -> Bool
}


final class AddWordValidationManger: AddWordValidationManagerProtocol {
    enum ValidType {
        case def
    }

    func isValid(text: String, type: ValidType) -> Bool {
        switch type {
        case .def:
            guard text == "" else { return true }
            return false
        }
    }
}
