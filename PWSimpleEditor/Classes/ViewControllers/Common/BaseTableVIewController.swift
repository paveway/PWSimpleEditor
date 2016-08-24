//
//  BaseTableVIewController.swift
//  PWSimpleEditor
//
//  Created by mfuta1971 on 2016/08/24.
//  Copyright © 2016年 Paveway. All rights reserved.
//

import Foundation

/**
 基底テーブルクラス

 - Version: 1.0 新規作成
 - Authoer: paveway.info@gmail.com
 */
class BaseTableViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

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
        let cell = getTableViewCell(tableView)
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
    func getTableViewCell(tableView: UITableView) -> UITableViewCell {
        // セルを取得する。
        var cell = tableView.dequeueReusableCellWithIdentifier(kCellName) as UITableViewCell?
        if (cell == nil) {
            // セルが取得できない場合
            // セルを生成する。
            cell = UITableViewCell()
        }

        cell!.textLabel?.text = ""
        cell!.accessoryType = .None
        
        return cell!
    }
}