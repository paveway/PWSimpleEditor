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
class EditViewController: BaseViewController, UITextViewDelegate {

    // MARK: - Constants

    /// 画面タイトル
    private let kScreenTitle = "編集"

    // MARK: - Variables

    /// 編集ビュー
    @IBOutlet weak var editView: UIView!

    /// テキストビュー
    private var textView: CYRTextView!

    /// プレオフセット
    private var preOffset: CGPoint?

    /// ファイル名
    var fileName: String!

    // MARK: - UIViewController

    /**
     インスタンスが生成された時に呼び出される。
     */
    override func viewDidLoad() {
        // スーパークラスのメソッドを呼び出す。
        super.viewDidLoad()

        // 画面タイトルを設定する。
        navigationItem.title = kScreenTitle

        // 右上バーボタンを生成する。
        createRightBarButton(.Save)

        let frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height - bannerView.frame.height)
        textView = CYRTextView(frame: frame)
        textView.delegate = self
        textView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        editView.addSubview(textView)

        // ファイルデータを取得する。
        let rootPath = FileUtils.getLocalPath(File.kRootDir)
        let results = FileUtils.read(rootPath, fileName: fileName)
        if !results.result {
            let message = "ファイルデータを読み込めませんでした。"
            showErrorAlert(message) {
                // 遷移元画面に戻る。
                self.navigationController?.popViewControllerAnimated(true)
            }
            return
        }
        textView.text = results.fileData

        // 拡張キーボードを生成する。
        listNumber = 0
        targetView = textView
        let extendKeyboard = createExtendKeyboard()
        let extendKeyboardItems = createExtendKeyboardItems(listNumber)
        extendKeyboard.setItems(extendKeyboardItems, animated: false)
        textView.inputAccessoryView = extendKeyboard

        // バナービューを設定する。
        setupBannerView(bannerView, delegate: self)
    }

    /**
     メモリ不足になった時に呼び出される。
     */
    override func didReceiveMemoryWarning() {
        // スーパークラスのメソッドを呼び出す。
        super.didReceiveMemoryWarning()

    }

    /**
     画面が表示される前に呼び出される。
 
     - Parameter animated: アニメーション指定
     */
    override func viewWillAppear(animated: Bool) {
        // スーパークラスのメソッドを呼び出す。
        super.viewWillAppear(animated)

        // プレオフセットを保存する。
        preOffset = textView.contentOffset

        // 通知を設定する。
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIKeyboardDidShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
    }

    /**
     画面が消された後に呼び出される。
 
     - Parameter animated: アニメーション指定
     */
    override func viewDidDisappear(animated: Bool) {
        // スーパークラスのメソッドを呼び出す。
        super.viewDidDisappear(animated)

        // 通知を解除する。
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        center.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        center.removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
    }

    // MARK: - Notification handler

    /**
     キーボードが表示される時に呼び出される。

     - Parameter notification: 通知
     */
    func keyboardDidShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let size = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().size

        var contentInsets = UIEdgeInsetsMake(0.0, 0.0, size.height, 0.0)
        contentInsets = textView.contentInset
        contentInsets.bottom = size.height + 44.0

        textView.contentInset = contentInsets
        textView.scrollIndicatorInsets = contentInsets
    }

    /**
     キーボードが閉じる時に呼び出される。

     - Parameter notification: 通知
     */
    func keyboardWillHide(notification: NSNotification) {
        var contentsInsets = textView.contentInset
        contentsInsets.bottom = 0
        textView.contentInset = contentsInsets
        textView.contentInset.bottom = 0
        preOffset = textView.contentOffset
    }

    /**
     キーボードが閉じた後に呼び出される。

     - Parameter notification: 通知
     */
    func keyboardDidHide(notification: NSNotification) {
        textView.setContentOffset(preOffset!, animated: true)
    }

    // MARK: - Bar Button

    /**
     右バーボタンが押下された時に呼び出される。

     - Parameter buttonItem: 右バーボタン
     */
    override func rightBarButtonPressed(buttonItem: UIBarButtonItem) {
        let fileData = textView.text
        let rootPath = FileUtils.getLocalPath(File.kRootDir)
        if !FileUtils.write(rootPath, fileName: fileName, fileData: fileData) {
            let message = "ファイルデータを書き出せませんでした。"
            showErrorAlert(message)
        }
    }
}

