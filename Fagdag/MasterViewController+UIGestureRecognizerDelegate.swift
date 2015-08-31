//
//  Masv.swift
//  Fagdag
//
//  Created by Hans-Chr Fjeldberg on 18/08/15.
//  Copyright (c) 2015 BEKK. All rights reserved.
//

import UIKit

extension MasterViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count > 1;
    }
}
