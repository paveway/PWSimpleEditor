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
     ドキュメントパスを取得する。

     - Returns: ドキュメントパス
     */
    class func getDocumentsPath() -> String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        return documentsPath
    }

    /**
     ディレクトリ/ファイルのローカルパスを取得する。

     - Parameter pathName: パス名付きディレクトリ名、またはパス名付きファイル名
     - Returns: ローカルパス
     */
    class func getLocalPath(pathName: String) -> String {
        let documentsPath = getDocumentsPath()
        let localPath = "\(documentsPath)/\(pathName)"
        return localPath
    }

    /**
     ディレクトリ/ファイルのローカルパスを取得する。

     - Parameter pathName: パス名
     - Parameter name: ディレクトリ名、またはファイル名
     - Returns: ローカルパス
     */
    class func getLocalPath(pathName: String, name: String) -> String {
        let documentsPath = getDocumentsPath()
        let localPath: String
        if pathName.isEmpty {
            localPath = "\(documentsPath)/\(name)"

        } else {
            localPath = "\(documentsPath)/\(pathName)/\(name)"
        }
        return localPath
    }

    /**
     ディレクトリ/ファイルが存在するかチェックする。

     - Parameter localPathName: Documentsディレクトリを含むパス名
     - Parameter name: ディレクトリ名、またはファイル名
     - Returns: チェック結果 true:存在する。 / false:存在しない。
     */
    class func isExist(localPathName: String, name: String) -> Bool {
        let localPath = "\(localPathName)/\(name)"
        let fileManager = NSFileManager.defaultManager()
        var isDir: ObjCBool = false
        let isFile = fileManager.fileExistsAtPath(localPath, isDirectory: &isDir)
        print(isFile)
        if isDir {
            return true
        }
        return isFile
    }

    /**
     ディレクトリ/ファイルが存在するかチェックする。

     - Parameter localPathName: ディレクトリパス名、またはファイルパス名
     - Returns: チェック結果 true:存在する。 / false:存在しない。
     */
    class func isExist(localPathName: String) -> Bool {
        let fileManager = NSFileManager.defaultManager()
        var isDir: ObjCBool = false
        let isFile = fileManager.fileExistsAtPath(localPathName, isDirectory: &isDir)
        if isDir {
            return true
        }
        return isFile
    }

    /**
     ディレクトリかチェックする。

     - Parameter dirPathName: ディレクトリパス名
     - Returns: チェック結果 true:ディレクトリ / false:ディレクトリではない
     */
    class func isDirectory(dirPathName: String) -> Bool {
        let fileManager = NSFileManager.defaultManager()
        var isDir: ObjCBool = false
        if fileManager.fileExistsAtPath(dirPathName, isDirectory: &isDir) {
            if isDir {
                return true
            }
        }
        return false
    }

    /**
     ディレクトリを作成する。

     - Parameter driPathName: ディレクトリパス名
     - Returns: 処理結果
     */
    class func createDir(dirPathName: String) -> Bool {
        let fileManager = NSFileManager.defaultManager()
        var isDir : ObjCBool = false
        fileManager.fileExistsAtPath(dirPathName, isDirectory: &isDir)
        if !isDir {
            do {
                try fileManager.createDirectoryAtPath(dirPathName ,withIntermediateDirectories: true, attributes: nil)
            } catch {
                return false
            }
        }
        return true
    }

    /**
     ディレクトリ内のファイル情報リストを取得する。

     - Parameter dirName: ディレクトリ名
     - Returns: ファイル情報リスト
     */
    class func getFileInfoListInDir(dirName: String) -> [FileInfo] {
        var fileInfoList: [FileInfo] = []
        let fileManager = NSFileManager.defaultManager()

        let files: [String]
        do {
            files = try fileManager.contentsOfDirectoryAtPath(dirName)
        } catch {
            return fileInfoList
        }

        var sortDirNameList = [String]()
        var sortFileNameList = [String]()
        for file in files {
            let name = file as String
            let fileInfo = FileInfo()
            fileInfo.name = name

            let fullPath = "\(dirName)/\(name)"
            let isDir = isDirectory(fullPath)
            fileInfo.isDir = isDir

            if isDir {
                sortDirNameList.append(name)
            } else {
                sortFileNameList.append(name)
            }
        }
        sortDirNameList.sortInPlace(<)
        sortFileNameList.sortInPlace(<)
        for name in sortDirNameList {
            let fileInfo = FileInfo()
            fileInfo.name = name
            fileInfo.isDir = true
            fileInfoList.append(fileInfo)
        }
        for name in sortFileNameList {
            let fileInfo = FileInfo()
            fileInfo.name = name
            fileInfo.isDir = false
            fileInfoList.append(fileInfo)
        }
        return fileInfoList
    }

    /**
     リソースファイルデータを取得する。
     取得できない場合、空文字列を返却する。

     - Parameter fileName: ファイル名(拡張子抜き)
     - Parameter type: 拡張子
     - Parameter encoding: エンコーディング(デフォルトNSUTF8StringEncoding)
     - Returns: 処理結果, ファイルデータ
     */
    class func readResourceFile(fileName: String, type: String, encoding: UInt = NSUTF8StringEncoding) -> (result: Bool, fileData: String) {
        if fileName.isEmpty {
            return (false, "")
        }

        if let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: type) {
            let fileData: String
            do {
                fileData = try String(contentsOfFile: filePath, encoding: encoding)
            } catch {
                return (false, "")
            }

            if fileData.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) <= 0 {
                return (false, "")
            }

            return (true, fileData)
        }
        return (false, "")
    }

    /**
     ファイルからデータを読み込む。
 
     - Parameter pathName: パス名
     - Parameter fileName: ファイル名
     - Parameter encoding: エンコーディング(デフォルトNSUTF8StringEncoding)
     - Returns: 処理結果, ファイルデータ
     */
    class func read(pathName: String, fileName: String, encoding: UInt = NSUTF8StringEncoding) -> (result: Bool, fileData: String) {
        if pathName.isEmpty || fileName.isEmpty {
            return (false, "")
        }

        let fileData: String
        do {
            let filePathName = "\(pathName)/\(fileName)"
            fileData = try String(contentsOfFile: filePathName, encoding: encoding)
        } catch {
            return (false, "")
        }

        return (true, fileData)
    }

    /**
     ファイルにデータを書き出す。

     - Parameter pathName: パス名
     - Parameter fileName: ファイル名
     - Parameter fileData: ファイルデータ
     - Parameter encoding: エンコーディング(デフォルトNSUTF8StringEncoding)
     - Returns: 処理結果
     */
    class func write(pathName: String, fileName: String, fileData: String, encoding: UInt = NSUTF8StringEncoding) -> Bool {
        if pathName.isEmpty || fileName.isEmpty {
            return false
        }

        let filePathName = "\(pathName)/\(fileName)"
        do {
            try fileData.writeToFile(filePathName, atomically: true, encoding: encoding)
        } catch {
            return false
        }
        return true
    }

    /**
     ディレクトリ/ファイルを削除する。
     nameにディレクトリ名を指定した場合、サブディレクトリを含め削除する。

     - Parameter pathName: ディレクトリパス名、またはファイルパス名
     - Returns: 処理結果 true:削除成功、または引数nameが存在しない。 / false:削除失敗
     */
    class func remove(pathName: String, check: Bool = true) -> Bool {
        if pathName.isEmpty {
            return false
        }

        if check {
            if !isExist(pathName) {
                return true
            }
        }

        let fileManager = NSFileManager.defaultManager()
        do {
            try fileManager.removeItemAtPath(pathName)
        } catch {
            return false
        }

        return true
    }

    /**
     名前変更を行う。

     - Parameter pathName: パス名
     - Parameter oldName: 元の名前
     - Parameter newName: 新しい名前
     - Returns: 処理結果
     */
    class func rename(pathName: String, oldName: String, newName: String) -> Bool {
        if pathName.isEmpty || oldName.isEmpty || newName.isEmpty {
            return false
        }

        let oldPath = getLocalPath(pathName, name: oldName)
        let newPath = getLocalPath(pathName, name: newName)

        let fileManager = NSFileManager.defaultManager()
        do {
            try fileManager.moveItemAtPath(oldPath, toPath: newPath)
        } catch {
            return false
        }
        return true
    }
}