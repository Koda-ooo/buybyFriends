//
//  RoundedButton.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/17.
//

import UIKit

class RoundedButton: UIButton {
    convenience init(title: String, fontSize: CGFloat) {
        self.init(frame: CGRect(origin: .zero, size: CGSize()))

        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)

        adjustSize() // サイズの調整
        roundCorners() // 角を丸くする
        configureColor() // 色をつける
    }

    private func adjustSize() {
        sizeToFit()
        let width = self.frame.width
        let height = self.frame.height
    // sizeToFit() を実行しても幅が狭いので、高さは変えずに
    // 幅だけ +30 します。この数値は好みで変更してください。
        frame.size = CGSize(width: width + 30, height: height)
    }

    private func roundCorners() {
        clipsToBounds = true
        layer.cornerRadius = bounds.height / 2
        layer.borderWidth = 0.0
    }

    private func configureColor() {
        backgroundColor = UIColor.systemBlue
        setTitleColor(UIColor.white, for: .normal)
    }
}
