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

    func showAlert(title: String, message: String, okButtonTitle: String = "OK", action: (() -> Void)? = nil) {
        let sweetAlert = SweetAlert()
        sweetAlert.showAlert(title, subTitle: message, style: AlertStyle.None, buttonTitle: okButtonTitle, action: { (isOtherButton: Bool) -> Void in
            if !isOtherButton {
                action?()
            }
        })
    }

    /**
     アラートを表示する。
     キャンセルボタンも表示する。

     - Parameter title: タイトル
     - Parameter message: メッセージ
     - Parameter okButtonTitle: OKボタンタイトル(デフォルト"OK")
     - Parameter cancelButtonTitle: キャンセルボタンタイトル(デフォルト"キャンセル")
     - Parameter handler: OKボタン押下時の処理
     */
    func showAlertWithCancel(title: String, message: String, okButtonTitle: String = "OK", cancelButtonTitle: String = "キャンセル", action: (() -> Void)? = nil) {
        // アラートを表示する。
        let sweetAlert = SweetAlert()
        sweetAlert.showAlert(title, subTitle: message, style: AlertStyle.Warning, buttonTitle: cancelButtonTitle, buttonColor: UIColor.colorFromRGB(0xD0D0D0), otherButtonTitle: okButtonTitle, otherButtonColor: UIColor.peterRiverColor(), action: { (isOtherButton: Bool) -> Void in
            if !isOtherButton {
                action?()
            }
        })
    }

    /**
     削除確認アラートを表示する。

     - Parameter name: 削除対象の名前
     */
    func showDeleteConfirmAlert(name: String, action: () -> Void) {
        let title = "確認"
        let message = "\(name)を削除しますか"
        let deleteButonTitle = "削除"
        showAlertWithCancel(title, message: message, okButtonTitle: deleteButonTitle, action: action)
    }

    /**
     エラーアラートを表示する

     - Parameter message: メッセージ
     - Parameter action: OKボタン押下時の処理(デフォルトなし)
     */
    func showErrorAlert(message: String, action: (() -> Void)? = nil) {
        let title = "エラー"
        let buttonTitle = "閉じる"
        showAlert(title, message: message, okButtonTitle: buttonTitle, action: action)
    }

    /**
     エラーアラートを表示する。
     メインスレッドで処理する。

     - Parameter title: タイトル
     - Parameter message: メッセージ
     - Parameter okButtonTitle: OKボタンタイトル(デフォルト"OK")
     - Parameter action: OKボタン押下時の処理
     */
    func showErrorAlertAsync(message: String, action: (() -> Void)? = nil) {
        let queue = dispatch_get_main_queue()
        dispatch_async(queue) {
            // アラートを表示する。
            self.showErrorAlert(message, action: action)
        }
    }
}