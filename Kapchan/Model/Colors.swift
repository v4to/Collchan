//
//  Colors.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 08.01.2021.
//  Copyright © 2021 Andrii Yehortsev. All rights reserved.
//

import Foundation
import UIKit

let dynamicColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
    if traitCollection.userInterfaceStyle == .dark {
        return UIColor(red: 0.129, green: 0.145, blue: 0.180, alpha: 1.0)
    } else {
        return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
}
