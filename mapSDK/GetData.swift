//
//  GetData.swift
//  mapSDK
//
//  Created by 木村陽太 on 2021/12/26.
//

// DBから受信
// TIME_INTERVAL[s]ごとに呼び出される
//    周辺のピン,丸情報を取得する

struct Pin_circle_data{
    var lat: Double
    var lng: Double
    let count: Int
    var purpose: String
    var type: String // pin,circle
    var user_id: Set<Int>
    init(lat: Double, lng: Double, count: Int, purpose: String, type: String, user_id: Set<Int>) {
        self.lat = lat;
        self.lng = lng;
        self.count = count;
        self.purpose = purpose;
        self.type = type;
        self.user_id = user_id;
    }
}
class GetData {
    func Randlat() ->Double{
        let randomDoublelat = Double.random(in: -0.0001...0.0001)
        return randomDoublelat
    }
    func Randlng() ->Double{
        let randomDoublelng = Double.random(in: -0.0001...0.0001)
        return randomDoublelng
    }

    func Get_pin_circle_data() -> Array<Pin_circle_data>{
        // サンプルコード
        // pin_circle_arrayにDBから取得したピン,丸の情報を入れる
        var pin_circle_array: Array<Pin_circle_data> = []
        pin_circle_array.append(Pin_circle_data(lat: 35.703950 + Randlat(), lng: 139.753050 + Randlng(), count: 1, purpose: "A", type: "pin", user_id: [0]))
        pin_circle_array.append(Pin_circle_data(lat: 35.703100 + Randlat(), lng: 139.753300 + Randlng(), count: 1, purpose: "B", type: "pin", user_id: [1]))
        pin_circle_array.append(Pin_circle_data(lat: 35.703200 + Randlat(), lng: 139.752200 + Randlng(), count: 1, purpose: "A", type: "pin", user_id: [2]))
        pin_circle_array.append(Pin_circle_data(lat: 35.703700 + Randlat(), lng: 139.754000 + Randlng(), count: 1, purpose: "A", type: "pin", user_id: [3]))
        pin_circle_array.append(Pin_circle_data(lat: 35.703500 + Randlat(), lng: 139.753000 + Randlng(), count: 1, purpose: "B", type: "pin", user_id: [4]))
        pin_circle_array.append(Pin_circle_data(lat: 35.704000 + Randlat(), lng: 139.753700 + Randlng(), count: 1, purpose: "B", type: "pin", user_id: [5]))
        pin_circle_array.append(Pin_circle_data(lat: 35.703800 + Randlat(), lng: 139.753150 + Randlng(), count: 2, purpose: "A", type: "circle", user_id: [6,7]))
        pin_circle_array.append(Pin_circle_data(lat: 35.703900 + Randlat(), lng: 139.753000 + Randlng(), count: 3, purpose: "A", type: "circle", user_id: [8,9,10]))
        pin_circle_array.append(Pin_circle_data(lat: 35.705600 + Randlat(), lng: 139.752600 + Randlng(), count: 1, purpose: "B", type: "circle", user_id: [11]))
        pin_circle_array.append(Pin_circle_data(lat: 35.704300 + Randlat(), lng: 139.753200 + Randlng(), count: 1, purpose: "A", type: "circle", user_id: [12]))
        pin_circle_array.append(Pin_circle_data(lat: 35.704000 + Randlat(), lng: 139.752800 + Randlng(), count: 2, purpose: "B", type: "circle", user_id: [13,14]))
        pin_circle_array.append(Pin_circle_data(lat: 35.703850 + Randlat(), lng: 139.752950 + Randlng(), count: 1, purpose: "B", type: "circle", user_id: [15]))
        pin_circle_array.append(Pin_circle_data(lat: 35.705100 + Randlat(), lng: 139.752000 + Randlng(), count: 4, purpose: "A", type: "circle", user_id: [16,17,18,19]))
        return pin_circle_array
    }
}
