//
//  UIViewControllerExtension.swift
//  PWSimpleEditor
//
//  Created by mfuta1971 on 2016/08/25.
//  Copyright © 2016年 Paveway. All rights reserved.
//

import Foundation

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
        // 何もしない。
    }
}