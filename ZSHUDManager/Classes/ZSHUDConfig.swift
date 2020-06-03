//
//  ZSHUDConfig.swift
//  ZSHUDManager
//
//  Created by Taylor on 2020/6/3.
//

import UIKit


public enum ZSMsgType : Int {
    case `default` = 0
    case done
    case fail
    case warning
}

public enum ZSContentViewType : Int {
    case loading
    case message
}
func ZSHEXCOLOR(_ rgbValue: Int) -> UIColor {
    
    UIColor(red: CGFloat(Float(((rgbValue & 0xff0000) >> 16)) / 255.0), green: CGFloat((Float((rgbValue & 0xff00) >> 8)) / 255.0), blue: CGFloat((Float(rgbValue & 0xff)) / 255.0), alpha: 1.0)
}
let kZSDminantColor = 0x000000
let kZSLoadingColor = 0xffffff
let kZSTextColor = 0xffffff
let kZSImageColor = 0xffffff


let kZSDefaultAlpha: CGFloat = 1.0
let kZSPadding: CGFloat = 10.0
let kZSMaxTextWidth: CGFloat = 150.0
let kZSDefaultTipFontSize: CGFloat = 15.0
let kZSDefaultSubFontSize: CGFloat = 12.0
let kZSLoadingDelayTime: CGFloat = 6000.0
let kZSContentMinWidth: CGFloat = 80.0
let kZSContentMaxWidth: CGFloat = 150.0
let kZSMessageDelayTime: CGFloat = 1.5
let kZSDefaultAnimationTime: CGFloat = 0.15


let isShowkZSDefaultLoadingTip = false

let kZSDefaultLoadingTip = "Loading..."
let kZSDismissNotification = "kZSDismissNotification"


class ZSHUDConfig: NSObject {
   
}
