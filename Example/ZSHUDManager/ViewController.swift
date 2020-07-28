//
//  ViewController.swift
//  ZSHUDManager
//
//  Created by zhangs1992@126.com on 06/03/2020.
//  Copyright (c) 2020 zhangs1992@126.com. All rights reserved.
//

import UIKit
import ZSHUDManager
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        ZSHUD.config.alpha = 0.6
    }
    @IBAction func show(_ sender: UIButton) {
        print("点击")
        ZSHUDManager.shared().showLoading(main: "测试", sub: "详细") {
            print("取消了")
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//          ZSHUDManager.shared().show("kksd")
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
//          ZSHUDManager.shared().showLoading("wo")
//        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 9) {
//            ZSHUDManager.shared().dismiss()
//        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            ZSHUDManager.shared().dismiss()
        }
        
//        ZSHUD.nav_showSuccess("哈哈哈哈哈哈哈")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            ZSHUDManager.destroy()
//        }
////        ZSHUDManager.destroy()
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
//        ZSHUD.loadingAnimationImages = ["234.png"]
//         ZSHUD.showLoading(tip: "接济接济")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

