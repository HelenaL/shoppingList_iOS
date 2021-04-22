//
//  Extensions.swift
//  ShoppingList
//
//  Created by Lenochka on 8/25/20.
//  Copyright © 2020 LEA. All rights reserved.
//
import UIKit
import Foundation

extension Date {
    // date string formatter
    func toString( dateFormat format: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension String {
  func stringByRemovingEmoji() -> String {
    return String(self.filter { !$0.isEmoji() })
  }
}

extension Character {
  fileprivate func isEmoji() -> Bool {
    return Character(UnicodeScalar(UInt32(0x1d000))!) <= self && self <= Character(UnicodeScalar(UInt32(0x1f77f))!)
      || Character(UnicodeScalar(UInt32(0x2100))!) <= self && self <= Character(UnicodeScalar(UInt32(0x26ff))!)
  }
}

extension UIViewController {
    func showFailure(title: String = "Action failed", message: String? = "Action failed") {
        let messageToDisplay = message ?? "Action failed"
        let alertVC = UIAlertController(title: title, message: messageToDisplay, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

public extension UIColor {
    class func RGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
         return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
     }

    // custom red color for high priority
    class func redHighPriority() -> UIColor {

        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                        if traitCollection.userInterfaceStyle == .dark {
                            return self.RGB(red: 204, green: 74, blue: 70, alpha: 1)
                        } else {
                            return self.RGB(red: 251, green: 110, blue: 110, alpha: 1)
                        }
                    }
    }

    // custom orange color for middle priority
    class func orangeMiddlePriority() -> UIColor {

        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                        if traitCollection.userInterfaceStyle == .dark {
                            return self.RGB(red: 245, green: 154, blue: 32, alpha: 1)
                        } else {
                            return self.RGB(red: 253, green: 181, blue: 106, alpha: 1)
                        }
                    }
    }

    // custom green color for low priority
    class func greenLowPriority() -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                        if traitCollection.userInterfaceStyle == .dark {
                            return self.RGB(red: 134, green: 178, blue: 114, alpha: 1)
                        } else {
                            return self.RGB(red: 177, green: 235, blue: 149, alpha: 1)
                        }
                    }
    }

    // custom gray color for no priority
    class func grayNoPriority() -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                        if traitCollection.userInterfaceStyle == .dark {
                            return self.RGB(red: 125, green: 125, blue: 126, alpha: 1)
                        } else {
                            return self.RGB(red: 242, green: 242, blue: 242, alpha: 1)
                        }
                    }
    }

    // custom app default green color
    class func greenMainTheme() -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                        if traitCollection.userInterfaceStyle == .dark {
                            return self.RGB(red: 136, green: 179, blue: 0, alpha: 1)
                        } else {
                            return self.RGB(red: 136, green: 179, blue: 0, alpha: 1)
                        }
                    }
    }

}
