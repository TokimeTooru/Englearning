import UIKit

enum AvatarImage: Int {
    case mouse = 0
    case cat = 1
    case cat2 = 2
    case wolf = 3
    case rabbit = 4
    case japan = 5
    case japan2 = 6
    case japan3 = 7
    case japan4 = 8

    var getImage: UIImage {
        switch self {
        case .cat: return UIImage(named: "cat_avatar") ?? UIImage()
        case .cat2: return UIImage(named: "cat_avatar_2") ?? UIImage()
        case .mouse: return UIImage(named: "mouse_avatar") ?? UIImage()
        case .wolf: return UIImage(named: "wolf_avatar") ?? UIImage()
        case .rabbit: return UIImage(named: "rabbit_avatar") ?? UIImage()
        case .japan: return UIImage(named: "japan_avatar") ?? UIImage()
        case .japan2: return UIImage(named: "japan_avatar_2") ?? UIImage()
        case .japan3: return UIImage(named: "japan_avatar_3") ?? UIImage()
        case .japan4: return UIImage(named: "japan_avatar_4") ?? UIImage()
        }
    }
}
