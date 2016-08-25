//
//  CreateFileViewController.swift
//  PWSimpleEditor
//
//  Created by mfuta1971 on 2016/08/25.
//  Copyright © 2016年 Paveway. All rights reserved.
//

import UIKit
import XLForm

/**
 ファイル作成画面

 - Version: 1.0 新規作成
 - Authoer: paveway.info@gmail.com
 */
class CreateFileViewController: BaseXLFormViewController {

    // MARK: - Constants

    /// 画面タイトル
    private let kScreenTitle = "ファイル作成"

    /// タグ
    struct Tags {
        static let kFileNameRow = "fileNameRow"
    }

    /**
     フォームを初期化する。
     */
    override func initializeForm() {
        // フォームを生成する。
        let form = XLFormDescriptor(title: kScreenTitle)

        // セクションを作成する。
        let section = XLFormSectionDescriptor()
        form.addFormSection(section)

        // ファイル名入力行を作成する。
        let fileNameRowTitle = "ファイル名"
        let fileNameRow = XLFormRowDescriptor(tag: Tags.kFileNameRow, rowType: XLFormRowDescriptorTypeName, title: fileNameRowTitle)
        let requiredText = "必須"
        fileNameRow.cellConfigAtConfigure["textField.placeholder"] = requiredText
        fileNameRow.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Right.rawValue
        fileNameRow.required = true
        section.addFormRow(fileNameRow)

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
        createRightBarButton(.Save)
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
                if validationStatus.rowDescriptor!.tag == Tags.kFileNameRow {
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

        // ファイル名を取得する。
        let values = form.formValues() as NSDictionary
        let fileName = values.objectForKey(Tags.kFileNameRow) as! String
        let pathName = FileUtils.getLocalPath(File.kRootDir)
        if FileUtils.isExist(pathName, name: fileName) {
            // 同名ファイルが存在する場合
            // エラーアラートを表示して終了する。
            return
        }

        if !FileUtils.write(pathName, fileName: fileName, fileData: "") {
            // ファイル作成できない場合
            // エラーアラートを表示して終了する。
            return
        }

        // 遷移元画面に戻る。
        navigationController?.popViewControllerAnimated(true)
    }
}
