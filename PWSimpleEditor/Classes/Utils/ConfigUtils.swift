//
//  ConfigUtils.swift
//  PWSimpleEditor
//
//  Created by mfuta1971 on 2016/08/25.
//  Copyright © 2016年 Paveway. All rights reserved.
//

import Foundation

/**
 コンフィグユーティリティクラス

 - Version: 1.0 新規作成
 - Author: paveway.info@gmail.com
 */
class ConfigUtils: NSObject {

    /**
     設定値を取得する。
     取得できない場合、空文字列を返却する。
 
     - Parameter key: キー名
     - Returns: 処理結果, 設定値
     */
    class func getConfigValue(key: String) -> (result: Bool, value: String) {
        if key.isEmpty {
            return (false, "")
        }

        let results = FileUtils.readResourceFile(Config.kFilename, type: Config.kType)
        if !results.result {
            return (false, "")
        }
        let lines = results.fileData.componentsSeparatedByString("\n")
        for line in lines {
            let items = line.componentsSeparatedByString("=")
            if key == items[0] {
                return (true, items[1])
            }
        }
        return (false, "")
    }

    /**
     カンマ区切りで設定された設定値を複数の設定値として返却する。
     取得できない場合、空の配列を返却する。
 
     - Parameter key: キー名
     - Returns: 処理結果, 設定値の配列
     */
    class func getConfigValues(key: String) -> (result: Bool, values: [String]) {
        if key.isEmpty {
            return (false, [] as [String])
        }

        let results = getConfigValue(key)
        if !results.result {
            return (false, [] as [String])
        }

        let value = results.value
        if value.isEmpty {
            return (false, [] as [String])

        } else {
            return (true, value.componentsSeparatedByString(","))
        }
    }
}