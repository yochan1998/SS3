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
        //self.MyLat = 35.602712
        //self.MyLng = 139.683812
        //self.CameraLat = 35.602712
        //self.CameraLng = 139.683812
        self.MyLat = 0.0
        self.MyLng = 0.0
        self.CameraLat = 35.711966
        self.CameraLng = 139.568376
    }
    func Reload_Position() {

        if mLat != nil {
            //self.MyLat = 35.711966
            //self.MyLng = 139.568376
            //self.CameraLat = 35.711966
            //self.CameraLng = 139.568376
            //self.MyLat = 35.602712
            //self.MyLng = 139.683812
            //self.CameraLat = 35.602712
            //self.CameraLng = 139.683812
            //自分の座標の更新
            self.MyLat = mLat
            self.MyLng = mLng

            // カメラ座標の更新
            //self.CameraLat = mLat
            //self.CameraLng = mLng
        }
    }
}
