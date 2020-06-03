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
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        ZSHUD.showDone("斤斤计较军")
        ZSHUD.loadingAnimationImages = ["234.png"]
         ZSHUD.showLoading(tip: "接济接济")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

