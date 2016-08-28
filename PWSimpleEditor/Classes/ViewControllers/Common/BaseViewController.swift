//
//  BaseViewController.swift
//  PWSimpleEditor
//
//  Created by mfuta1971 on 2016/08/24.
//  Copyright © 2016年 Paveway. All rights reserved.
//

import UIKit
import GoogleMobileAds

/**
 基底画面

 - Version: 1.0 新規作成
 - Authoer: paveway.info@gmail.com
 */
class BaseViewController: UIViewController, GADBannerViewDelegate {

    // MARK: - Constants

    /// 行番号最大値
    let kListNumberMax = 4

    /// 拡張キーリスト1
    let kExtendKeyList1 = [";", ":", ".", ",", "_", "\"", "'", "@"]

    /// 拡張キーリスト2
    let kExtendKeyList2 = ["(", ")", "{", "}", "[", "]", "<", ">"]

    /// 拡張キーリスト3
    let kExtendKeyList3 = ["=", "+", "-", "*", "/", "%"]

    /// 拡張キーリスト4
    let kExtendKeyList4 = ["&", "|", "!", "?", "#", "$", "~", "^"]

    /// Undoボタンタイトル
    let kUndoButtonTitle = "U"

    /// Redoボタンタイトル
    let kRedoButtonTitle = "R"

    /// 前へボタンタイトル
    let kPrevButtonTitle = "▲"

    /// 次へボタンタイトル
    let kNextButtonTitle = "▼"

    /// 閉じるボタンタイトル
    let kCloseButtonTitle = "↓"

    private let kImageSize: CGFloat = 16.0

    /// タグ
    private enum Tag: Int {
        case Other
        case Undo
        case Redo
        case Prev
        case Next
        case Close
    }

    // MARK: - Variables

    /// バナービュー
    @IBOutlet weak var bannerView: GADBannerView!

    /// 対象のビュー
    var targetView: UIView?

    /// 行番号
    var listNumber: Int!

    /// Undoボタン
    var undoButton: UIBarButtonItem?

    /// Redoボタン
    var redoButton: UIBarButtonItem?

    /**
     拡張キーボードボタン押下時の処理

     - Parameter sender: 押下されたボタン
     */
    func onClickExtendKeyboardButton(sender: UIBarButtonItem) {
        let tag = sender.tag
        if tag == Tag.Undo.rawValue {
            // Undoボタンの場合
            if let targetView = targetView as? UITextView {
                // 対象のビューがUITextViewの場合
                let undoManager = targetView.undoManager
                if undoManager == nil {
                    // Undoマネージャが無効な場合、何もしない。
                    return
                }
                if undoManager!.canUndo {
                    // Undo可能な場合、Undoを行う。
                    undoManager!.undo()
                }
            }

        } else if tag == Tag.Redo.rawValue {
            // Redoボタンの場合
            if let targetView = targetView as? UITextView {
                // 対象のビューがUITextViewの場合
                let undoManager = targetView.undoManager
                if undoManager == nil {
                    // Undoマネージャが無効な場合、何もしない。
                    return
                }
                if undoManager!.canRedo {
                    // Redo可能な場合、Redoを行う。
                    undoManager!.redo()
                }
            }

        } else if tag == Tag.Next.rawValue {
            // 次の行へボタンの場合
            if listNumber < kListNumberMax - 1 {
                listNumber = listNumber + 1
            } else {
                listNumber = 0
            }
            setExtendKeyboardItems(listNumber)

        } else if tag == Tag.Prev.rawValue {
            // 前の行へボタンの場合
            if listNumber > 0 {
                listNumber = listNumber - 1
            } else {
                listNumber = kListNumberMax - 1
            }
            setExtendKeyboardItems(listNumber)

        } else if tag == Tag.Close.rawValue {
            // キーボードを閉じるボタンの場合
            targetView?.resignFirstResponder()

        } else {
            // その他の場合
            // 入力された文字をビューに反映する。
            let title = sender.title
            if let targetView = targetView as? UITextView {
                //targetView.text = targetView.text + title!
                let range = rangeToTextRange(targetView)
                targetView.replaceRange(range!, withText: title!)

            } else if let targetView = targetView as? UITextView {
                //targetView.text = targetView.text + title!
                let range = rangeToTextRange(targetView)
                targetView.replaceRange(range!, withText: title!)
            }
        }
    }

    /**
     NSRangeをUITextRangeに変換する。

     - Parameter textView: テキストビュー
     - Returns: UITextRange
     */
    func rangeToTextRange(textView: UITextView) -> UITextRange? {
        if let rangeStart = textView.positionFromPosition(textView.beginningOfDocument, offset: textView.selectedRange.location),
            rangeEnd = textView.positionFromPosition(rangeStart, offset: textView.selectedRange.length) {
            return textView.textRangeFromPosition(rangeStart, toPosition: rangeEnd)
        }
        return nil
    }

    // MARK: - Extend Keyboard

    /**
     拡張キーボードのボタンを生成する。

     - Parameter lineNumber: 行番号
     - Returns: 拡張キーボードのボタン
     */
    func createExtendKeyboardItems(lineNumber: Int) -> [UIBarButtonItem] {
        let extendKeyList: [String]!
        if lineNumber == 0 {
            extendKeyList = kExtendKeyList1

        } else if lineNumber == 1 {
            extendKeyList = kExtendKeyList2

        } else if lineNumber == 2 {
            extendKeyList = kExtendKeyList3

        } else {
            extendKeyList = kExtendKeyList4
        }

        let barButtonArray = NSMutableArray()
        let action = #selector(BaseViewController.onClickExtendKeyboardButton(_:))

        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            // スマホの場合
            if ((targetView as? UITextView) != nil) {
                // 対象のビューがUITextViewの場合
                // Undoボタン
//                let undoImageName = CommonConst.Image.Icon.kUndo
//                let undoImage = ImageUtils.createImage(undoImageName, width: kImageSize, height: kImageSize)
//                let undoButton = UIBarButtonItem(image: undoImage, style: .Plain, target: self, action: action)
                let undoButton = UIBarButtonItem(title: kUndoButtonTitle, style: .Plain, target: self, action: action)
                undoButton.tag = Tag.Undo.rawValue
                barButtonArray.addObject(undoButton)

                // Redoボタン
//                let redoImageName = CommonConst.Image.Icon.kRedo
//                let redoImage = ImageUtils.createImage(redoImageName, width: kImageSize, height: kImageSize)
//                let redoButton = UIBarButtonItem(image: redoImage, style: .Plain, target: self, action: action)
                let redoButton = UIBarButtonItem(title: kRedoButtonTitle, style: .Plain, target: self, action: action)
                redoButton.tag = Tag.Redo.rawValue
                barButtonArray.addObject(redoButton)
            }
        }

        let count = extendKeyList.count
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        for i in 0 ..< count {
            let title = extendKeyList[i]
            let button = UIBarButtonItem(title: title, style: .Plain, target: self, action: action)
            barButtonArray.addObject(button)
            barButtonArray.addObject(space)
        }

        // 次の行ボタン
//        let nextImageName = CommonConst.Image.Icon.kNext
//        let nextImage = ImageUtils.createImage(nextImageName, width: kImageSize, height: kImageSize)
//        let nextButton = UIBarButtonItem(image: nextImage, style: .Plain, target: self, action: action)
        let nextButton = UIBarButtonItem(title: kNextButtonTitle, style: .Plain, target: self, action: action)
        nextButton.tag = Tag.Next.rawValue
        barButtonArray.addObject(nextButton)

        // 前の行ボタン
//        let prevImageName = CommonConst.Image.Icon.kPrev
//        let prevImage = ImageUtils.createImage(prevImageName, width: kImageSize, height: kImageSize)
//        let prevButton = UIBarButtonItem(image: prevImage, style: .Plain, target: self, action: action)
        let prevButton = UIBarButtonItem(title: kPrevButtonTitle, style: .Plain, target: self, action: action)
        prevButton.tag = Tag.Prev.rawValue
        barButtonArray.addObject(prevButton)

        // キーボードを閉じるボタン
//        let closeImageName = CommonConst.Image.Icon.kClose
//        let closeImage = ImageUtils.createImage(closeImageName, width: kImageSize, height: kImageSize)
//        let closeButton = UIBarButtonItem(image: closeImage, style: .Plain, target: self, action: action)
        let closeButton = UIBarButtonItem(title: kCloseButtonTitle, style: .Plain, target: self, action: action)
        closeButton.tag = Tag.Close.rawValue
        barButtonArray.addObject(closeButton)

        return barButtonArray as NSArray as! [UIBarButtonItem]
    }

    /**
     拡張キーボードを生成する。

     - Returns: 拡張キーボード
     */
    func createExtendKeyboard() -> UIToolbar {
        let frame = CGRectMake(0, 0, view.frame.width, 0)
        let accessoryView = UIToolbar(frame: frame)
        accessoryView.sizeToFit()
        return accessoryView
    }

    /**
     拡張キーボードのボタンを設定する。

     - Parameter listNumber: 行番号
     */
    private func setExtendKeyboardItems(listNumber: Int) {
        if targetView != nil {
            let extendKeyboard = targetView!.inputAccessoryView as! UIToolbar
            let extendKeyboardItems = createExtendKeyboardItems(listNumber)
            extendKeyboard.setItems(extendKeyboardItems, animated: false)
        }
    }
}