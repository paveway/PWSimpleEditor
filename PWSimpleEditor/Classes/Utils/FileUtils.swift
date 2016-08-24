//
//  FileUtils.swift
//  PWSimpleEditor
//
//  Created by mfuta1971 on 2016/08/25.
//  Copyright © 2016年 Paveway. All rights reserved.
//

import Foundation

/**
 ファイルユーティリティクラス
 
 - Version: 1.0 新規作成
 - Author: paveway.info@gmail.com
 */
class FileUtils: NSObject {

    /**
     ファイルデータを取得する。
     取得できない場合、空文字列を返却する。

     - parameter fileName: ファイル名(拡張子抜き)
     - parameter type: 拡張子
     - Returns: ファイルデータ
     */
    class func getFileData(fileName: String, type: String) -> String {
        var fileData = ""
        if let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: type) {
            fileData = try! String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
            if fileData.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) <= 0 {
                fileData = ""
            }
        }
        return fileData
    }
}