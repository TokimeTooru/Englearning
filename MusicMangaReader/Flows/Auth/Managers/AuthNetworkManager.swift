import FirebaseAuth
import FirebaseDatabase

protocol AuthNetworkManagerProtocol {
    var errorRegistration: ((String) -> ())? { get set }
    var successRegistration: (() -> ())? { get set }
    var errorVerification: (() -> ())? { get set }
    var successVerification: (() -> ())? { get set }
    func registration(email: String, password: String, completion: @escaping (User) -> ())
    func authorization(email: String, password: String, completion: @escaping (User) -> ())
    func setNewUserDataBase(model: UserModel, completion: @escaping (Bool) -> ())
    func getUserDataBase(completion: @escaping (UserModel) -> ())
}

final class AuthNetworkManager: AuthNetworkManagerProtocol {
    var errorRegistration: ((String) -> ())?
    var successRegistration: (() -> ())?
    var errorVerification: (() -> ())?
    var successVerification: (() -> ())?

    private lazy var databasePath: DatabaseReference? = {
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }
        let dataBase = Database.database()
        dataBase.isPersistenceEnabled = true
        let ref = dataBase.reference().child("Users/\(uid)")

        return ref
    }()

    func registration(email: String, password: String, completion: @escaping (User) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            guard error == nil else {
                var registartionErrorString: String
                switch  AuthErrorCode.Code(rawValue: error!._code) {
                    case .emailAlreadyInUse:
                        registartionErrorString = "User with this email have alredy existed"
                    case .invalidEmail:
                        registartionErrorString = "Invalid name of email"
                    case .weakPassword:
                        registartionErrorString = "Password is weak"
                    default:
                        registartionErrorString = "Unknown error"
                    }
                self.errorRegistration?(registartionErrorString)
                return
            }
            authResult?.user.sendEmailVerification() { [weak self] error in
                guard error == nil else {
                    SnackCenter.shared.showSnack(text: error.debugDescription, style: .error)
                    return
                }
                self?.successRegistration?()
            }
            guard let user = authResult?.user else { return }
            completion(user)
        }
    }

    func authorization(email: String, password: String, completion: @escaping (User) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard error == nil else {
                switch AuthErrorCode.Code(rawValue: error!._code) {
                case .invalidEmail:
                    SnackCenter.shared.showSnack(text: "Wrong email", style: .error)
                default:
                    SnackCenter.shared.showSnack(text: "Something went wrong", style: .error)
                }
                self?.errorVerification?()
                return
            }
            guard let user = authResult?.user, user.isEmailVerified else {
                SnackCenter.shared.showSnack(text: "Please veritify your email", style: .error)
                authResult?.user.sendEmailVerification()
                self?.errorVerification?()
                return
            }
            completion(user)
            self?.successVerification?()
        }
    }

    func setNewUserDataBase(model: UserModel, completion: @escaping (Bool) -> ()) {
        DispatchQueue.global().async {
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            guard
                let databasePath = self.databasePath
            else {
                completion(false)
                return
            }
            let encoder = JSONEncoder()

            do {
                let data = try encoder.encode(model)
                let json = try JSONSerialization.jsonObject(with: data)
                databasePath.child("data").setValue(json)
                completion(true)
            } catch {
                completion(false)
                return
            }
        }
    }

    func getUserDataBase(completion: @escaping (UserModel) -> ()) {
        let decoder = JSONDecoder()
        var userModel: UserModel? = nil
        guard
            let databasePath = databasePath
        else {
          return
        }

        databasePath
            .observe(.childAdded) { [weak self] snapshot, val  in
            guard
                let self = self,
                var json = snapshot.value as? [String: Any]
            else {
                return
                }
                json["id"] = snapshot.key
                print("--------------")
                print(json)
                print("--------------")

            do {
                let thoughtData = try JSONSerialization.data(withJSONObject: json)
                let thought = try decoder.decode(UserModel.self, from: thoughtData)
                //print(thought)
                completion(thought)
            } catch {
                print("an error occurred")
            }
          }
    }
}
