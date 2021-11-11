//
//  TimeOutShieldConfiguration.swift
//  TimeOutShieldConfiguration
//
//  Created by Jimmy Ti on 5/8/21.
//

import UIKit
import ManagedSettings
import ManagedSettingsUI

class TimeOutShieldConfiguration: ShieldConfigurationDataSource {

    override func configuration(shielding application: Application) -> ShieldConfiguration {
        let themeColor = UIColor(rgbColorCodeRed: 20,
                                 green: 166,
                                 blue: 139,
                                 alpha: 1)
        return ShieldConfiguration(backgroundBlurStyle: .systemMaterial,
                                   backgroundColor: themeColor,
                                   icon: UIImage(named: "shield-icon"),
                                   title: ShieldConfiguration.Label(text: "It's practice time",
                                                                    color: .black),
                                   subtitle: ShieldConfiguration.Label(text: "Answer one question to use this app again.",
                                                                       color: .black),
                                   primaryButtonLabel: ShieldConfiguration.Label(text: "Answer Question",
                                                                                 color: .black),
                                   primaryButtonBackgroundColor: .clear,
                                   secondaryButtonLabel: ShieldConfiguration.Label(text: "Pause 1Question",
                                                                                   color: .black))
    }
}

extension UIColor {
   convenience init(rgbColorCodeRed red: Int, green: Int, blue: Int, alpha: CGFloat) {

     let redPart: CGFloat = CGFloat(red) / 255
     let greenPart: CGFloat = CGFloat(green) / 255
     let bluePart: CGFloat = CGFloat(blue) / 255

     self.init(red: redPart, green: greenPart, blue: bluePart, alpha: alpha)
   }
}
