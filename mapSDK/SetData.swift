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

import Firebase

class My_info: MyPosition{
    var my_id: Int
    var my_purpose: String
    init(my_id: Int) {
        self.my_id = my_id
        self.my_purpose = "undefined"
    }
}
class SetData {
    // 現在時刻を取得する関数getTime
    func getTime () -> String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss"
        let string = df.string(from: date)
        return string
    }
    func Set_my_position(my_info: My_info){
        // my_positionに自分の位置情報を入れてサーバに送信する
        
        // DBへ送信(サンプルコード)
        let db = Firestore.firestore()
        let time = getTime()
        let docData: [String: Any] = [
            "user_id" : my_info.my_id,
            "lat" : my_info.MyLat,
            "lng": my_info.MyLng,
            "purpose" : my_info.my_purpose,
            "time" : time
        ]
        // ユーザDBの更新
        db.collection("user").document("\(my_info.my_id)").setData(docData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}
