//
//  HUDWindow.swift
//  ZSHUDManager
//
//  Created by Taylor on 2020/7/28.
//

import UIKit

class HUDWindow: UIWindow {

    weak var showView:UIView?
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        if let showV = showView,showV.frame.contains(point) == true {
//            print("可以")
//            return true
//        }else{
//            print("NO")
//            return true
//        }
        return true
    }
}
