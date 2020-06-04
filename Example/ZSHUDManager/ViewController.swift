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
//        ZSHUD.show("这是测试\n嗯")
        ZSHUD.showLoading(tip: "接济接济")
      
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

