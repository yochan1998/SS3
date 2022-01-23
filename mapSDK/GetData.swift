//
//  GetData.swift
//  mapSDK
//
//  Created by 木村陽太 on 2021/12/26.
//

// DBから受信
// TIME_INTERVAL[s]ごとに呼び出される
//    周辺のピン,丸情報を取得する

// ルートや設定を変更する場合80~89行目を編集してください

import Foundation

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
class UnionFind{
    var par: Array<Int> = []
    var N: Int
    init(N: Int){
        self.N = N
        for i in 0..<N{
            self.par.append(i)
        }
    }
    func root(x: Int) ->Int{
        if (self.par[x] == x){
            return x
        }
        self.par[x] = root(x: self.par[x])
        return self.par[x]
    }
    func unite(x: Int, y: Int){
        let rx = root(x: x)
        let ry = root(x: y)
        if rx == ry{
            return
        }
        self.par[rx] = ry
        return
    }
    func group() -> Array<Set<Int>>{
        var g: Array<Set<Int>> = []
        var gidx: Array<Int> = []
        var s = Set<Int>()
        for i in 0..<N{
            gidx.append(-1)
            s.insert(root(x: i))
        }
        var ii = 0
        for key in s{
            g.append([])
            gidx[key] = ii
            ii += 1
        }
        for i in 0..<N{
            let r = root(x: i)
            g[gidx[r]].insert(i)
        }
        return g
    }
}
class GetData {
    // ----- ここを編集する
    let N = 6
    let Path = [[[35.602557, 139.683479], [35.602582, 139.683361], [35.602840, 139.683192], [35.602819, 139.683452]],
                 [[35.602776, 139.683903], [35.602819, 139.683452]],
                 [[35.602756, 139.684071], [35.602792, 139.683728]],
                 [[35.603039, 139.683768], [35.602792, 139.683728]],
                 [[35.602818, 139.683484], [35.602764, 139.683992]],
                 [[35.602719, 139.684369], [35.602764, 139.683992]]]
    let Purpose_array = ["beer", "beer", "trade", "trade", "trade", "trade"]
    let Unite_dist = 20.0 // ピンの結合距離[m]
    let START_TIME = 5.0 // シミュレーション開始時刻[s]
    // -----
    
    func Randlat() ->Double{
        let randomDoublelat = Double.random(in: -0.0001...0.0001)
        return randomDoublelat
    }
    func Randlng() ->Double{
        let randomDoublelng = Double.random(in: -0.0001...0.0001)
        return randomDoublelng
    }
    func Harversine_distance(lat1: Double, lat2: Double, lng1: Double, lng2: Double) ->Double{
        let R = 6371071.0
        let rlat1 = lat1 * (Double.pi / 180.0)
        let rlat2 = lat2 * (Double.pi / 180.0)
        let difflat = rlat2 - rlat1
        let difflon = (lng2 - lng1) * (Double.pi / 180.0)
        let d = 2.0 * R * asin(sqrt(sin(difflat/2.0)*sin(difflat/2.0) + cos(rlat1)*cos(rlat2)*sin(difflon/2.0)*sin(difflon/2.0)))
        return d
    }
    func Pos_simulate(t: Double, id: Int) ->Array<Double>{
        var latlng: Array<Double> = [0.0, 0.0]
        let M = Path[id].count
        var i = 0
        var dist_tmp = 0.0
        let t1 = max(t-START_TIME, 0.0)
        let dist = t1 * 80.0 / 60.0
        while(true){
            if(i >= M-1){
                latlng = Path[id][M-1]
                break
            }
            let dist_diff = Harversine_distance(lat1: Path[id][i][0], lat2: Path[id][i+1][0], lng1: Path[id][i][1], lng2: Path[id][i+1][1])
            if(dist_tmp + dist_diff >= dist){
                let dist_rem = dist - dist_tmp
                for j in 0..<2{
                    latlng[j] = Path[id][i][j] + (Path[id][i+1][j] - Path[id][i][j]) * dist_rem / dist_diff
                }
                break
            }
            else{
                dist_tmp += dist_diff
            }
            i += 1
        }
        return latlng
    }
    
    func Unite(pin_circle_array: Array<Pin_circle_data>) ->Array<Pin_circle_data>{
        var purpose_set = Set<String>()
        for id in 0..<N{
            purpose_set.insert(pin_circle_array[id].purpose)
        }
        var pin_circle_array_new: Array<Pin_circle_data> = []
        let uf = UnionFind(N: N)
        for key in purpose_set{
            var g: Array<Int> = []
            for id in 0..<N{
                if pin_circle_array[id].purpose == key{
                    g.append(id)
                }
            }
            for x in g{
                for y in g{
                    let lat1 = pin_circle_array[x].lat
                    let lng1 = pin_circle_array[x].lng
                    let lat2 = pin_circle_array[y].lat
                    let lng2 = pin_circle_array[y].lng
                    if Harversine_distance(lat1: lat1, lat2: lat2, lng1: lng1, lng2: lng2) <= Unite_dist{
                        uf.unite(x: x, y: y)
                    }
                }
            }
        }
        let gg = uf.group()
        for user_id_new in gg{
            let count = user_id_new.count
            var type = "pin"
            if count >= 2{
                type = "circle"
            }
            var lat = 0.0
            var lng = 0.0
            var purpose = ""
            for user_id in user_id_new{
                lat += pin_circle_array[user_id].lat
                lng += pin_circle_array[user_id].lng
                purpose = pin_circle_array[user_id].purpose
            }
            lat /= Double(count)
            lng /= Double(count)
            pin_circle_array_new.append(Pin_circle_data(lat: lat, lng: lng, count: count, purpose: purpose, type: type, user_id: user_id_new))
        }
        return pin_circle_array_new
    }

    func Get_pin_circle_data(my_info : MyPosition, t: Double) -> Array<Pin_circle_data>{
        // サンプルコード
        let my_lat = my_info.MyLat
        let my_lng = my_info.MyLng
        // pin_circle_arrayにDBから取得したピン,丸の情報を入れる
        // my_lat, my_lng周辺の情報に限定する？
        var pin_circle_array: Array<Pin_circle_data> = []
        for id in 0..<N{
            let latlng = Pos_simulate(t: t, id: id)
            pin_circle_array.append(Pin_circle_data(lat: latlng[0], lng: latlng[1], count: 1, purpose: Purpose_array[id], type: "pin", user_id: [id]))
        }
        pin_circle_array = Unite(pin_circle_array: pin_circle_array)
        /*
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
         */
        return pin_circle_array
    }
}
