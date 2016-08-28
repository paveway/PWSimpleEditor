//
//  RenameFileViewController.swift
//  PWSimpleEditor
//
//  Created by mfuta1971 on 2016/08/29.
//  Copyright © 2016年 Paveway. All rights reserved.
//

import UIKit
import XLForm

/**
 ファイル名変更画面

 - Version: 1.0 新規作成
 - Authoer: paveway.info@gmail.com
 */
class RenameFileViewController: BaseXLFormViewController {

    // MARK: - Constants

    /// 画面タイトル
    private let kScreenTitle = "ファイル名変更"

    /// タグ
    struct Tags {
        /// 旧ファイル名行
        static let kOldFileNameRow = "oldFileNameRow"

        /// 新ファイル名行
        static let kNewFileNameRow = "newFileNameRow"
    }

    // MARK: - Variables

    /// 旧ファイル名
    var oldFileName: String

    // MARK: - Initializer

    /**
     イニシャライザ
 
     - Parameter aDecoder: デコーダー
     */
    required init(coder aDecoder: NSCoder) {
        fatalError()
    }

    /**
     イニシャライザ

     - Parameter oldFileName: 旧ファイル名
     */
    init(oldFileName: String) {
        // 引数を保存する。
        self.oldFileName = oldFileName

        // スーパークラスのイニシャライザを呼び出す。
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - XLForm

    /**
     フォームを初期化する。
     */
    override func initializeForm() {
        // フォームを生成する。
        let form = XLFormDescriptor(title: kScreenTitle)

        // セクションを作成する。
        let section = XLFormSectionDescriptor()
        form.addFormSection(section)

        // 旧ファイル名前(表示のみ)
        let oldFileNameRowTitle = "旧ファイル名"
        let oldFileNameRow = XLFormRowDescriptor(tag: Tags.kOldFileNameRow, rowType: XLFormRowDescriptorTypeText, title: oldFileNameRowTitle)
        oldFileNameRow.value = oldFileName
        oldFileNameRow.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Right.rawValue
        oldFileNameRow.required = false
        oldFileNameRow.disabled = true
        section.addFormRow(oldFileNameRow)

        // 新ファイル名前
        let newFileNameRowTitle = "新ファイル名"
        let newFileNameRow = XLFormRowDescriptor(tag: Tags.kNewFileNameRow, rowType: XLFormRowDescriptorTypeText, title: newFileNameRowTitle)
        let requiredText = "必須"
        newFileNameRow.cellConfigAtConfigure["textField.placeholder"] = requiredText
        newFileNameRow.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Right.rawValue
        newFileNameRow.required = true
        section.addFormRow(newFileNameRow)

        self.form = form
    }

    // MARK: - UIViewController

    /**
     インスタンスが生成された時に呼び出される。
     */
    override func viewDidLoad() {
        // スーパークラスのメソッドを呼び出す。
        super.viewDidLoad()

        // 右上バーボタンを生成する。
        createRightBarButton()
    }

    // MARK: - Bar button

    /**
     右上バーボタンが押下された時に呼び出される。

     　  - Parameter buttonItem: 右上バーボタン
     */
    override func rightBarButtonPressed(buttonItem: UIBarButtonItem) {
        // キーボードを閉じる。
        view.endEditing(true)

        // エラーがあるかチェックする。
        let array = formValidationErrors()
        let errorCount = array.count
        if 0 < errorCount {
            //  エラーがある場合
            for errorItem in array {
                let error = errorItem as! NSError
                let validationStatus = error.userInfo[XLValidationStatusErrorKey] as! XLFormValidationStatus
                if validationStatus.rowDescriptor!.tag == Tags.kNewFileNameRow {
                    // ファイル名セルの場合
                    // オレンジ色でフラッシュ表示する。
                    if let rowDescriptor = validationStatus.rowDescriptor, let indexPath = form.indexPathOfFormRow(rowDescriptor), let cell = tableView.cellForRowAtIndexPath(indexPath) {
                        cell.backgroundColor = .orangeColor()
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            cell.backgroundColor = .whiteColor()
                        })
                    }
                }
            }
            return
        }

        // 新ファイル名を取得する。
        let values = form.formValues() as NSDictionary
        let newFileName = values.objectForKey(Tags.kNewFileNameRow) as! String
        let pathName = FileUtils.getLocalPath(File.kRootDir)
        print(pathName)
        if FileUtils.isExist(pathName, name: newFileName) {
            // 同名ファイルが存在する場合
            // エラーアラートを表示して終了する。
            let message = "同名のファイルが存在します。"
            showErrorAlert(message)
            return
        }

        if !FileUtils.rename(pathName, oldName: oldFileName, newName: newFileName) {
            // ファイル名変更でエラーの場合
            let message = "ファイル名変更ができませんでした。"
            showErrorAlert(message)
            return
        }

        // 遷移元画面に戻る。
        navigationController?.popViewControllerAnimated(true)
    }
}
