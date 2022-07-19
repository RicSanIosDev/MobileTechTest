import UIKit

extension UISegmentedControl {
    func fontBold(for state: UIControl.State, size: CGFloat = 20, color: UIColor) {
        let boldTextAttributes = [
            NSAttributedString.Key.font: UIFont.avenirNextBold(ofSize: size),
            NSAttributedString.Key.foregroundColor: color
        ]

        setTitleTextAttributes(boldTextAttributes, for: state)
    }

    func fontMedium(for state: UIControl.State, size: CGFloat = 20, color: UIColor) {
        let boldTextAttributes = [
            NSAttributedString.Key.font: UIFont.avenirNextMedium(ofSize: size),
            NSAttributedString.Key.foregroundColor: color
        ]

        setTitleTextAttributes(boldTextAttributes, for: state)
    }

    func fontRegular(for state: UIControl.State, size: CGFloat = 18, color: UIColor) {
        let normalTextAttributes = [
            NSAttributedString.Key.font: UIFont.avenirNextRegular(ofSize: size),
            NSAttributedString.Key.foregroundColor: color
        ]

        setTitleTextAttributes(normalTextAttributes, for: state)
    }
}
