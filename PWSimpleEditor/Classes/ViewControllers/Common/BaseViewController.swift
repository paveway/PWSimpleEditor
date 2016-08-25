//
//  BaseViewController.swift
//  PWSimpleEditor
//
//  Created by mfuta1971 on 2016/08/24.
//  Copyright © 2016年 Paveway. All rights reserved.
//

import UIKit
import GoogleMobileAds

/**
 基底画面

 - Version: 1.0 新規作成
 - Authoer: paveway.info@gmail.com
 */
class BaseViewController: UIViewController, GADBannerViewDelegate {

    /// バナービュー
    @IBOutlet weak var bannerView: GADBannerView!
}