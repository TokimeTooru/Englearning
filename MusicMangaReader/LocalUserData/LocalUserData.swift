import Foundation

struct UserModel: Codable {
    var username: String
    var avatarTag: Int
    var enemiesDefeated: Int
    var wordsAdded: Int
    var wordMemorized: Int
    var level: Int
    var currentExp: Float
    var adddedWords: [Word]?
}

struct Word: Codable {
    var enWord: String
    var ruWord: String
    var examples: String
    var statusTag: Int
    var streak: Int
    var lastRightAnswer: Date
    var rightAnswers: Int
    var wrongAnswers: Int
    var wordId: Int
}

enum WordStatusTag: Int {
    case new = 0
    case learned = 1
    case poorly = 2
    case process = 3
}

final class LocalUserData {
    static let share = LocalUserData()

    init() { }

    var get: UserModel? {
        UserDefaults.standard.codableObject(dataType: UserModel.self, key: Constant.key)
    }

    var set: UserModel? {
        get { return nil }
        set {
            UserDefaults.standard.setCodableObject(newValue, forKey: Constant.key)
        }
    }

    func remove() {
        UserDefaults.standard.removeObject(forKey: Constant.key)
    }
}

extension UserDefaults {
    func setCodableObject<T: Codable>(_ data: T?, forKey defaultName: String) {
        let encoded = try? JSONEncoder().encode(data)
        set(encoded, forKey: defaultName)
    }

    func codableObject<T : Codable>(dataType: T.Type, key: String) -> T? {
        guard let userDefaultData = data(forKey: key) else {
            return nil
        }
            return try? JSONDecoder().decode(T.self, from: userDefaultData)
    }
}

extension LocalUserData {
    enum Constant {
        static let key = "allObjects"
    }
}

//final class LocalUserData {
//    static let cache = LocalUserData()
//    private init() { }
//
//    var modelCache: NSCache<NSString, UserLocalModel> = {
//        let cache = NSCache<NSString, UserLocalModel>()
//        //cache.countLimit = 1
//
//        return cache
//    }()
//
//    func add(key: String, model: UserLocalModel) {
//        modelCache.setObject(model, forKey: key as NSString)
//    }
//
//    func remove(key: String) {
//        modelCache.removeObject(forKey: key as NSString)
//    }
//
//    func getModel(key: String) -> UserLocalModel? {
//        modelCache.object(forKey: key as NSString)
//    }
//
//    func deleteAll() {
//        modelCache.removeAllObjects()
//    }
//}
//
//
//class UserLocalModel {
//    var userUID: String
//    var username: String
//    var avatarTag: Int
//    var enemiesDefeated: Int
//    var wordsAdded: Int
//    var wordMemorized: Int
//    var level: Int
//    var currentExp: Float
//
//    init(
//        userUID: String,
//        username: String,
//        avatarTag: Int,
//        enemiesDefeated: Int,
//        wordsAdded: Int,
//        wordMemorized: Int,
//        level: Int,
//        currentExp: Float
//    ) {
//        self.username = username
//        self.avatarTag = avatarTag
//        self.enemiesDefeated = enemiesDefeated
//        self.wordsAdded = wordsAdded
//        self.wordMemorized = wordMemorized
//        self.userUID = userUID
//        self.level = level
//        self.currentExp = currentExp
//    }
//}


