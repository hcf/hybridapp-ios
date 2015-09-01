import UIKit

extension IndexPageViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count > 1;
    }
}
