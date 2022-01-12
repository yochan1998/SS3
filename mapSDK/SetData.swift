//
//  SetData.swift
//  mapSDK
//
//  Created by 木村陽太 on 2022/01/05.
//

// DBに送信
// TIME_INTERVAL[s]ごとに呼び出される
// 　　自分の位置情報
// 適宜呼び出される
//    ピン削除
//    丸拡大
//    特徴更新

struct My_position{
    var lat: Double
    var lng: Double
    var my_id: Int
    init(lat: Double, lng: Double, my_id: Int) {
        self.lat = lat;
        self.lng = lng;
        self.my_id = my_id;
    }
}
class SetData {
    func Set_my_position(lat: Double, lng: Double, my_id: Int){
        // my_positionに自分の位置情報を入れてサーバに送信する
        var my_position = My_position(lat: lat, lng: lng, my_id: my_id)
        
        
    }
}
