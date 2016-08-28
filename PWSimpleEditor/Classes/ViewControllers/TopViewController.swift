//
//  TopViewController.swift
//  PWSimpleEditor
//
//  Created by mfuta1971 on 2016/08/24.
//  Copyright © 2016年 Paveway. All rights reserved.
//

import UIKit
import SWTableViewCell

/**
 トップ画面

 - Version: 1.0 新規作成
 - Authoer: paveway.info@gmail.com
 */
class TopViewController: BaseTableViewController {

    // MARK: - Constants

    /// 画面タイトル
    private let kScreenTitle = "PWSimpleEditor"

    // MARK: - Variables

    /// ファイル情報リスト
    private var fileInfoList = [FileInfo]()

    // MARK: - UIViewController

    /**
     インスタンスが生成された時に呼び出される。
     */
    override func viewDidLoad() {
        // スーパークラスのメソッドを呼び出す。
        super.viewDidLoad()

        // 画面タイトルを設定する。
        navigationItem.title = kScreenTitle

        // 右上バーボタンを作成する。
        createRightBarButton(.Add)

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

        // ルートディレクトリのファイル情報リストを取得する。
        let rootPath = FileUtils.getLocalPath(File.kRootDir)
        fileInfoList = FileUtils.getFileInfoListInDir(rootPath)

        // テーブルビューを更新する。
        tableView.reloadData()
    }

    // MARK: - Bar Button

    /**
     右バーボタンが押下された時に呼び出される。

     - Parameter buttonItem: 右バーボタン
     */
    override func rightBarButtonPressed(buttonItem: UIBarButtonItem) {
        // ファイル作成画面に遷移する。
        let vc = CreateFileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - UITableViewDataSource

    /**
     セクションのセル数を返却する。

     - Parameter tableView: テーブルビュー
     - Parameter section: セクション番号
     - Returns: セル数
     */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // ファイル情報数を返却する。
        let count = fileInfoList.count
        return count
    }

    /**
     セルを返却する。

     - Parameter tableView: テーブルビュー
     - Parameter indexPath: インデックスパス
     - Returns: セル
     */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // セルを取得する。
        let cell = getTableViewCell()

        // セル番号がファイル情報数より大きい場合
        // 処理を中断して終了する。
        let row = indexPath.row
        let count = fileInfoList.count
        if count < row + 1 {
            return cell
        }

        // セルを設定する。
        let fileInfo = fileInfoList[row]
        cell.textLabel?.text = fileInfo.name
        cell.accessoryType = .DisclosureIndicator

        return cell
    }

    /**
     セルの右ボタンを作成する。
 
     - Returns: セルの右ボタンの配列
     */
    override func createRightUtilityButtons() -> NSMutableArray {
        let buttons = NSMutableArray()
        buttons.sw_addUtilityButtonWithColor(UIColor.init(colorLiteralRed: 0.78, green: 0.78, blue: 0.8, alpha: 1.0), title: "名前変更")
        buttons.sw_addUtilityButtonWithColor(UIColor.init(colorLiteralRed: 1.0, green: 0.231, blue: 0.188, alpha: 1.0), title: "削除")
        return buttons
    }

    /**
     セルの右ボタンが押下された時に呼び出される。
 
     - Parameter cell: セル
     - Parameter index: ボタンの位置
 　  */
    func swipeableTableViewCell(cell: SWTableViewCell, didTriggerRightUtilityButtonWithIndex index: NSInteger) {
        // ボタンを隠す。
        cell.hideUtilityButtonsAnimated(true)

        // ボタンの位置により処理を振り分ける。
        switch index {
        case 0:
            // 名前変更ボタンの場合
            let indexPath = self.tableView.indexPathForCell(cell)
            let row = indexPath!.row
            let fileInfo = self.fileInfoList[row]
            let oldFileName = fileInfo.name
            let vc = RenameFileViewController(oldFileName: oldFileName)
            navigationController?.pushViewController(vc, animated: true)
            break

        case 1:
            // 削除ボタンの場合
            // 削除確認アラートを表示する。
            let name = cell.textLabel?.text
            self.showDeleteConfirmAlert(name!) {
                // 削除する場合
                let indexPath = self.tableView.indexPathForCell(cell)
                let row = indexPath!.row
                let fileInfo = self.fileInfoList[row]
                let fileName = fileInfo.name
                let pathName = FileUtils.getLocalPath(File.kRootDir)
                let filePathName = "\(pathName)/\(fileName)"
                print(filePathName)
                let result = FileUtils.remove(filePathName)
                if !result {
                    return
                }
                self.fileInfoList.removeAtIndex(row)
                self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            }
            break

        default:
            break
        }
    }

    // MARK: - UITableViewDelegate

    /**
     セルが選択された時に呼び出される。

     - Parameter tableView: テーブルビュー
     - Parameter indexPath: インデックスパス
     */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 選択状態を解除する。
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        // セル番号がファイル情報数より大きい場合
        // 処理を中断して終了する。
        let row = indexPath.row
        let count = fileInfoList.count
        if count < row + 1 {
            return
        }

        // セル位置のファイル情報を取得する。
        let fileInfo = fileInfoList[row]

        // 編集画面に遷移する。
        let vc = EditViewController()
        vc.fileName = fileInfo.name
        navigationController?.pushViewController(vc, animated: true)
    }
}
