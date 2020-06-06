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

let kZSDismissNotification = "kZSDismissNotification"




open class ZSHUDConfig: NSObject {
    ///背景色
    public var bgColor:UIColor!
    /// 加载图标的颜色
    public var loadingColor:UIColor!
    
    /// 标题的颜色
    public var tipColor:UIColor!
    
    /// 副标题的颜色
    public var subColor:UIColor!
    /// 按钮颜色
    public var buttonColor:UIColor!
    
    /// 图片颜色
    public var imageColor:UIColor!
    
    /// 标题字体
    public var tipFont:UIFont!
    /// 副标题字体
    public var subFont:UIFont!
    /// 按钮字体
    public var btFont:UIFont!
    
    /// 透明度
    public var alpha:CGFloat!
    /// 填补
    public var padding:CGFloat!
    
    /// 文字的最大宽度
    public var textMaxWidth:CGFloat!
    
    /// 最大宽度
    public var contentMaxWidth:CGFloat!
    /// 最小宽度
    public var contentMinWidth:CGFloat!
    /// nav 高
    public var navBarHeight:CGFloat!
    
    /// 加载消失时长
    public var loadingDelay:TimeInterval!
    /// 提示消失时长
    public var messageDelay:TimeInterval!
    /// 动画时长
    public var animationTime:TimeInterval!
    /// 动画时长
    public var animationNavTime:TimeInterval!
    /// 默认加载提示
    public var loadingDefaultTips:String?
    
    /// 加载动画
    public var loadingImages:[String]?
    override init() {
//        super.init()
        self.bgColor = ZSHEXCOLOR(0x000000)
        self.loadingColor = ZSHEXCOLOR(0xffffff)
        self.tipColor = ZSHEXCOLOR(0xffffff)
        self.subColor = ZSHEXCOLOR(0xffffff)
        self.buttonColor = ZSHEXCOLOR(0xffffff)
        self.imageColor = ZSHEXCOLOR(0xffffff)
        self.alpha = 1
        self.padding = 10
        self.textMaxWidth = 150.0
        self.contentMinWidth = 80.0
        self.contentMaxWidth = 150.0
        self.tipFont = UIFont.systemFont(ofSize: 15)
        self.subFont = UIFont.systemFont(ofSize: 12)
        self.btFont = UIFont.systemFont(ofSize: 12)
        self.loadingDelay = 6000.0
        self.messageDelay = 1.5
        self.animationTime = 0.15
        self.animationNavTime = 0.5
        self.loadingDefaultTips = "加载中..."
        self.navBarHeight = 40
    }
    
    
}
