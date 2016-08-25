//
//  TopViewController.swift
//  PWSimpleEditor
//
//  Created by mfuta1971 on 2016/08/24.
//  Copyright © 2016年 Paveway. All rights reserved.
//

import UIKit

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
        let cell = getTableViewCell(tableView)

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
        cell.accessoryType = .DetailDisclosureButton

        return cell
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
    }
}
