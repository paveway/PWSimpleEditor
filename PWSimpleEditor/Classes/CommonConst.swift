//
//  CommonConst.swift
//  PWSimpleEditor
//
//  Created by mfuta1971 on 2016/08/25.
//  Copyright © 2016年 Paveway. All rights reserved.
//

import Foundation

/// コンフィグ
struct Config {
    /// ファイル名
    static let kFilename = "Config"

    /// ファイルタイプ
    static let kType = "txt"

    /// キー
    struct Key {
        /// Admob AD ユニットID
        static let kAdmobAdUnitId = "admobAdUnitId"

        /// Admob AD テストデバイスID
        static let kAdmobAdTestDeviceIds = "admobAdTestDevice"
    }
}

/// ファイル
struct File {
    /// ルートディレクトリ
    static let kRootDir = "PWSimpleEditor"
}