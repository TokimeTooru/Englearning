import FirebaseAuth
import FirebaseDatabase

protocol DictionaryNetworkManagerProtocol {
    func setNewUserData(model: UserModel, completion: @escaping (Bool) -> ())
}

final class DictionaryNetworkManager: DictionaryNetworkManagerProtocol {
    private lazy var databasePath: DatabaseReference? = {
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }
        let dataBase = Database.database()
        let ref = dataBase.reference().child("Users/\(uid)")

        return ref
    }()

    func setNewUserData(model: UserModel, completion: @escaping (Bool) -> ()) {
        DispatchQueue.global().async {
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
}
