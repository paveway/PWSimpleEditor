//
//  UIViewControllerExtension.swift
//  PWSimpleEditor
//
//  Created by mfuta1971 on 2016/08/25.
//  Copyright © 2016年 Paveway. All rights reserved.
//

import UIKit
import GoogleMobileAds

/**
 UIViewController拡張
 
 - Version: 1.0 新規作成
 - Author: paveway.info@gmail.com
 */
extension UIViewController {

    // MARK: - Bar Button

    /**
     右バーボタンを作成する。

     - Parameter style: スタイル(デフォルト:Done)
     - Parameter action: アクション(デフォルト:rigthBarButtonPressed:)
     */
    func createRightBarButton(style: UIBarButtonSystemItem = .Done, action: Selector = #selector(rightBarButtonPressed(_:))) {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: style, target: self, action: action)
        navigationItem.rightBarButtonItem = barButtonItem
    }

    /**
     右バーボタンが押下された時に呼び出される。
     サブクラスで実装する。

     - Parameter buttonItem: 右バーボタン
     */
    func rightBarButtonPressed(buttonItem: UIBarButtonItem) {
        // サブクラスで実装しない場合、エラーとする。
        abort()
    }

    /**
     バナービューを設定する。

     - Parameter bannerView: バナービュー
     */
    func setupBannerView(bannerView: GADBannerView, delegate: GADBannerViewDelegate) {
        let adUnitId = ConfigUtils.getConfigValue(Config.Key.kAdmobAdUnitId)
        bannerView.adUnitID = adUnitId.value

        var deviceIds = ConfigUtils.getConfigValues(Config.Key.kAdmobAdTestDeviceIds)
        deviceIds.values.append(kGADSimulatorID as! String)

        bannerView.delegate = delegate
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = deviceIds.values

        bannerView.loadRequest(request)
    }
}