import UIKit

final class Line: UIView {
    init(rect: CGRect) {
        super.init(frame: .zero)
        draw(rect)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let aPath = UIBezierPath()

        aPath.move(to: CGPoint(x: frame.minX, y: .zero))

        aPath.addLine(to: CGPoint(x:frame.maxX, y:.zero))

        //Keep using the method addLineToPoint until you get to the one where about to close the path

        aPath.close()

        //If you want to stroke it with a red color
        UIColor.red.set()
        aPath.stroke()
        //If you want to fill it as well
        aPath.fill()
    }
}
