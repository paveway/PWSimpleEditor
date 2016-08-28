//
//  BaseTableVIewController.swift
//  PWSimpleEditor
//
//  Created by mfuta1971 on 2016/08/24.
//  Copyright © 2016年 Paveway. All rights reserved.
//

import Foundation
import SWTableViewCell

/**
 基底テーブルクラス

 - Version: 1.0 新規作成
 - Authoer: paveway.info@gmail.com
 */
class BaseTableViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate {

    // MARK: - Constants

    /// セル名
    let kCellName = "Cell"

    // MARK: - Variables

    /// テーブルビュー
    @IBOutlet weak var tableView: UITableView!

    // MARK: - UIViewController

    /**
     インスタンスが生成された時に呼び出される。
     */
    override func viewDidLoad() {
        // スーパークラスのメソッドを呼び出す。
        super.viewDidLoad()

        // テーブルビューを設定する。
        setupTableView()
    }

    // MARK: - UITableViewDataSource

    /**
     セクションのセル数を返却する。

     - Parameter tableView: テーブルビュー
     - Parameter section: セクション番号
     - Returns: セル数
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    /**
     セルを返却する。

     - Parameter tableView: テーブルビュー
     - Parameter indexPath: インデックスパス
     - Returns: セル
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = getTableViewCell()
        return cell
    }

    // MARK: - UITableViewDelegate

    /**
     セルが選択された時に呼び出される。

     - Parameter tableView: テーブルビュー
     - Parameter indexPath: インデックスパス
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }

    /**
     テーブルビューを設定する。
     */
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    /**
     テーブルビューセルを返却する。

     - Parameter tableView: テーブルビュー
     - Returns: テーブルビューセル
     */
    func getTableViewCell(style: UITableViewCellStyle = .Default) -> SWTableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(kCellName) as? SWTableViewCell
        if cell == nil {
            cell = SWTableViewCell(style: style, reuseIdentifier: kCellName)
            let leftUtilityButtons = createLeftUtilityButtons()
            if leftUtilityButtons != nil {
                cell!.leftUtilityButtons = leftUtilityButtons! as [AnyObject]
            }
            let rightUtilityButtons = createRightUtilityButtons()
            if rightUtilityButtons != nil {
                cell!.rightUtilityButtons = rightUtilityButtons! as [AnyObject]
            }
            cell!.delegate = self
        }
        return cell!
    }

    /**
     左セルボタン配列を生成する。
     サブクラスで実装する。
 
     - Returns: 左セルボタン配列
     */
    func createLeftUtilityButtons() -> NSMutableArray? {
        return nil
    }

    /**
     右セルボタン配列を生成する。
     サブクラスで実装する。

     - Returns: 右セルボタン配列
     */
    func createRightUtilityButtons() -> NSMutableArray? {
        return nil
    }
}