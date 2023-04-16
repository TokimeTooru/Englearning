import Foundation


final class BaseTimer: Operation {
    let time: Int
    let interval: UInt32
    let completion: (Int) -> ()
    var timesOut: (() -> ())?

    init(time: Int, interval: UInt32 = 1, completion: @escaping (Int) -> ()) {
        self.time = time
        self.completion = completion
        self.interval = interval
    }

    override func main() {
        for i in 0...time {
            if isCancelled {
                return
            } else {
                DispatchQueue.main.async {
                    self.completion(i)
                }
            }
            sleep(interval)
        }
        timesOut?()
        return
    }
}
