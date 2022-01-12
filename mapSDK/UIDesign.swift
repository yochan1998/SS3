//
//  UIDesign.swift
//  mapSDK
//
//  Created by 木村陽太 on 2021/12/28.
//

// マップ外のUI関連の処理(ボタン,ラベルの配置)をする

import UIKit
var WIDTH = 0.0
var HEIGHT = 0.0

// UIColor <-> hex
// https://www.mulong.me/tech/xcode/swift-uicolor-hex-convert/

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    func toHexString() -> String {
        var red: CGFloat     = 1.0
        var green: CGFloat   = 1.0
        var blue: CGFloat    = 1.0
        var alpha: CGFloat   = 1.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let r = Int(String(Int(floor(red*100)/100 * 255)).replacingOccurrences(of: "-", with: ""))!
        let g = Int(String(Int(floor(green*100)/100 * 255)).replacingOccurrences(of: "-", with: ""))!
        let b = Int(String(Int(floor(blue*100)/100 * 255)).replacingOccurrences(of: "-", with: ""))!
        let a = Int(String(Int(floor(alpha*100)/100 * 255)).replacingOccurrences(of: "-", with: ""))!

        let result = String(r, radix: 16).leftPadding(toLength: 2, withPad: "0") + String(g, radix: 16).leftPadding(toLength: 2, withPad: "0") + String(b, radix: 16).leftPadding(toLength: 2, withPad: "0") + String(a, radix: 16).leftPadding(toLength: 2, withPad: "0")
        return result
    }
}

extension String {
    // 左から文字埋めする
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return String(repeatElement(character, count: toLength - stringLength)) + self
        } else {
            return String(self.suffix(toLength))
        }
    }
}

// UIButtonの使い方
// https://developer.apple.com/documentation/uikit/uibutton
// https://qiita.com/tanakadaichi_1989/items/84cdf7ea23b61a462f59

// selectorに変数を渡せないので、UIButtonを継承した新たなクラスを作りプロパティに目的に関する情報を入れる
// https://qiita.com/fromage-blanc/items/d32642c467599a171f2c
class Choose_purpose_button:UIButton{
    var purpose_id: Int = -1
    var is_active: Bool = true
}
class Choose_purpose_buttons_info {
    // 目的選択ボタン
    var buttons: Array<Choose_purpose_button> = []
    let purpose_to_color: Array<UIColor> = [.cyan, .magenta, .orange]  // 目的ごとの文字色
    let backgroundColor_active = UIColor(hex: "#dddddd") // アクティブ時の背景色
    let backgroundColor_inactive = UIColor(hex: "#222222") // 非アクティブ時の背景色
    func Position(purpose_id: Int) ->CGRect{
        return CGRect(x: WIDTH*0.8, y: HEIGHT*(0.4+Double(purpose_id)*0.1), width: WIDTH*0.15, height: HEIGHT*0.07)  // ボタンの位置
    }
}

class Buttons_info {
    // ボタンを種類別に並べる
    var choose_purpose_buttons_info = Choose_purpose_buttons_info()
    
}

class Labels_info {
    // ラベルを種類別に並べる
    
}
