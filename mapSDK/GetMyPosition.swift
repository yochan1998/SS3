//
//  GetMyPosition.swift
//  mapSDK
//
//  Created by 木村陽太 on 2022/01/12.
//
var mLat : Double!
var mLng : Double!

class MyPosition{
    var MyLat: Double
    var MyLng: Double
    var CameraLat: Double
    var CameraLng: Double
    
    init() {
        // ここに自分の座標とカメラ座標の初期値を取得するコードを書く
        // サンプルコード
        self.MyLat = 35.7035
        self.MyLng = 139.7530
        self.CameraLat = 35.7035
        self.CameraLng = 139.7530
    }
    func Reload_Position() {

        if mLat != nil {
            //自分の座標の更新
            self.MyLat = mLat
            self.MyLng = mLng

            // カメラ座標の更新
            self.CameraLat = mLat
            self.CameraLng = mLng
        }
    }
}
