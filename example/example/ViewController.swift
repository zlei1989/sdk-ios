//
//  ViewController.swift
//  example
//
//  Created by 张磊 on 2017/7/28.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

import UIKit
import sdk

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let logger = Logger();
        logger.debug(msg:"hello world");

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

