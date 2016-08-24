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
     - Returns: 設定値
     */
    class func getConfigValue(key: String) -> String! {
        let fileData = FileUtils.getFileData("Config", type: "txt")
        let fileDatas = fileData.componentsSeparatedByString("\n")
        for line in fileDatas {
            let lines = line.componentsSeparatedByString("=")
            if key == lines[0] {
                return lines[1]
            }
        }
        return ""
    }

    /**
     カンマ区切りで設定された設定値を複数の設定値として返却する。
     取得できない場合、空の配列を返却する。
 
     - Parameter key: キー名
     - Returns: 設定値の配列
     */
    class func getConfigValues(key: String) -> [String]! {
        let value = getConfigValue(key)
        if value.isEmpty {
            return [] as [String]

        } else {
            return value.componentsSeparatedByString(",")
        }
    }
}