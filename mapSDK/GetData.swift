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

    func Get_pin_circle_data(my_info : MyPosition) -> Array<Pin_circle_data>{
        // サンプルコード
        let my_lat = my_info.MyLat
        let my_lng = my_info.MyLng
        // pin_circle_arrayにDBから取得したピン,丸の情報を入れる
        // my_lat, my_lng周辺の情報に限定する？
        var pin_circle_array: Array<Pin_circle_data> = []
        pin_circle_array.append(Pin_circle_data(lat: my_lat, lng: my_lng, count: 1, purpose: "beer", type: "pin", user_id: [0]))
        pin_circle_array.append(Pin_circle_data(lat: my_lat + 0.0010 + Randlat(), lng: my_lng + 0.0016 + Randlng(), count: 1, purpose: "trade", type: "pin", user_id: [1]))
        pin_circle_array.append(Pin_circle_data(lat: my_lat - 0.0006 + Randlat(), lng: my_lng - 0.0003 + Randlng(), count: 1, purpose: "beer", type: "pin", user_id: [2]))
        pin_circle_array.append(Pin_circle_data(lat: my_lat + 0.0012 + Randlat(), lng: my_lng - 0.0008 + Randlng(), count: 1, purpose: "beer", type: "pin", user_id: [3]))
        pin_circle_array.append(Pin_circle_data(lat: my_lat - 0.0005 + Randlat(), lng: my_lng + 0.0012 + Randlng(), count: 1, purpose: "trade", type: "pin", user_id: [4]))
        pin_circle_array.append(Pin_circle_data(lat: my_lat - 0.0015 + Randlat(), lng: my_lng - 0.0003 + Randlng(), count: 1, purpose: "trade", type: "pin", user_id: [5]))
        pin_circle_array.append(Pin_circle_data(lat: my_lat + 0.0002 + Randlat(), lng: my_lng + 0.0015 + Randlng(), count: 2, purpose: "beer", type: "circle", user_id: [6,7]))
        pin_circle_array.append(Pin_circle_data(lat: my_lat - 0.0018 + Randlat(), lng: my_lng - 0.0001 + Randlng(), count: 3, purpose: "beer", type: "circle", user_id: [8,9,10]))
        pin_circle_array.append(Pin_circle_data(lat: my_lat - 0.0006 + Randlat(), lng: my_lng + 0.0011 + Randlng(), count: 1, purpose: "trade", type: "circle", user_id: [11]))
        pin_circle_array.append(Pin_circle_data(lat: my_lat + 0.0009 + Randlat(), lng: my_lng - 0.0016 + Randlng(), count: 1, purpose: "beer", type: "circle", user_id: [12]))
        pin_circle_array.append(Pin_circle_data(lat: my_lat - 0.0005 + Randlat(), lng: my_lng + 0.0009 + Randlng(), count: 2, purpose: "trade", type: "circle", user_id: [13,14]))
        pin_circle_array.append(Pin_circle_data(lat: my_lat + 0.0011 + Randlat(), lng: my_lng - 0.0009 + Randlng(), count: 1, purpose: "trade", type: "circle", user_id: [15]))
        pin_circle_array.append(Pin_circle_data(lat: my_lat + 0.0013 + Randlat(), lng: my_lng - 0.0015 + Randlng(), count: 4, purpose: "beer", type: "circle", user_id: [16,17,18,19]))
        return pin_circle_array
    }
}
