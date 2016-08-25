//
//  FileInfo.swift
//  PWSimpleEditor
//
//  Created by mfuta1971 on 2016/08/24.
//  Copyright © 2016年 Paveway. All rights reserved.
//

import Foundation

/**
 ファイル情報
 
 - Version: 1.0 新規作成
 - Author: paveway.info@gmail.com
 */
class FileInfo: NSObject {
    /// 名前
    var name = ""

    /// パス名
    var pathName = ""

    /// ディレクトリか否か
    var isDir = false
}