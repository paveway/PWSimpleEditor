//
//  EditViewController.swift
//  PWSimpleEditor
//
//  Created by mfuta1971 on 2016/08/24.
//  Copyright © 2016年 Paveway. All rights reserved.
//

import UIKit

/**
 編集画面
 
 - Version: 1.0 新規作成
 - Authoer: paveway.info@gmail.com
 */
class EditViewController: BaseViewController {

    // MARK: - Constants

    /// 画面タイトル
    private let kScreenTitle = "編集"

    // MARK: - Variables

    /// 編集ビュー
    @IBOutlet weak var editView: UIView!

    /// テキストビュー
    var textView: CYRTextView!

    // MARK: - UIViewController

    /**
     インスタンスが生成された時に呼び出される。
     */
    override func viewDidLoad() {
        // スーパークラスのメソッドを呼び出す。
        super.viewDidLoad()

        // 画面タイトルを設定する。
        navigationItem.title = kScreenTitle
    }

    /**
     メモリ不足になった時に呼び出される。
     */
    override func didReceiveMemoryWarning() {
        // スーパークラスのメソッドを呼び出す。
        super.didReceiveMemoryWarning()

    }
}

