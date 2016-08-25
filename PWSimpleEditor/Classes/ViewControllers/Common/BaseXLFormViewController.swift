//
//  File.swift
//  PWSimpleEditor
//
//  Created by mfuta1971 on 2016/08/25.
//  Copyright © 2016年 Paveway. All rights reserved.
//

import Foundation
import GoogleMobileAds
import XLForm

/**
 基底XLForm画面クラス

 - Version: 1.0 新規作成
 - Authoer: paveway.info@gmail.com
 */
class BaseXLFormViewController: XLFormViewController, GADBannerViewDelegate {

    /// バナービュー
    @IBOutlet weak var bannerView: GADBannerView!

    // MARK: - Initializer

    /**
     イニシャライザー
 
     - Parameter aDecoder: デコーダー
     */
    required init(coder aDecoder: NSCoder) {
        // スーパークラスのイニシャライザを呼び出す。
        super.init(coder: aDecoder)

        // フォームの初期化を行う。
        self.initializeForm()
    }

    /**
     イニシャライザー

     - Parameter aDecoder: デコーダー
     */
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initializeForm()
    }

    /**
     フォームの初期化を行う。
     処理はサブクラスで実装する。
     */
    func initializeForm() {
        // サブクラスで実装しない場合、エラーとする。
        abort()
    }
}