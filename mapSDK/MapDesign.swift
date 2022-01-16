//
//  MapDesign.swift
//  mapSDK
//
//  Created by 木村陽太 on 2021/12/26.
//

// マップ上のマーカーに関する処理を行う

import UIKit
import GoogleMaps
import GooglePlaces

var mapView = GMSMapView()

struct Marker_info{
    let marker = GMSMarker()
    var lat: Double
    var lng: Double
    var count: Int
    var purpose: String
    var type: String // me,pin,circle
    var user_id: Set<Int>
    
    mutating func set_marker(icon: UIImage, position: CLLocationCoordinate2D, mapView: GMSMapView){
        self.marker.icon = icon
        self.marker.position = position
        self.marker.map = mapView
    }
        
}

class Markers_info{
    var markers: Array<Marker_info> = []
    var purpose_dict: Dictionary<String, Int> = [:] // purpose str to purpose id
    var purpose_size = 0
    var is_active_purpose: Array<Bool> = []
    var new_purpose_set: Set<String> = []
    func user_id_to_purpose_id(idx: Int) -> Int {
        let purpose_id = (self.purpose_dict[self.markers[idx].purpose] ?? -1)
        return purpose_id
    }
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        // https://qiita.com/akidon0000/items/bf67f052179c1f704699
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    func Reverse_marker(purpose: String){
        // (目的名)のマーカーの表示,非表示を反転
        // PurposeChooseViewControllerで使用
        let purpose_id = (self.purpose_dict[purpose] ?? -1)
        if purpose_id != -1{
            self.is_active_purpose[purpose_id] = !self.is_active_purpose[purpose_id]
        }
        else{
            print("目的名が定義されていません")
            assert(false)
        }
    }
    func Reload_marker(pin_circle_array: Array<Pin_circle_data>, my_id: Int){
        self.new_purpose_set.removeAll()
        for mk in self.markers{
            mk.marker.map = nil
        }
        self.markers.removeAll()
        for input in pin_circle_array{
            if !self.purpose_dict.keys.contains(input.purpose){
                self.purpose_dict[input.purpose] = self.purpose_size
                self.new_purpose_set.insert(input.purpose)
                self.is_active_purpose.append(true)
                self.purpose_size += 1
            }
            var type = input.type
            if input.user_id.contains(my_id){
                type = "me"
            }
            self.markers.append(Marker_info(lat: input.lat, lng: input.lng, count: input.count, purpose: input.purpose, type: type, user_id: input.user_id))
        }
        var idx:Int = -1
        for input in pin_circle_array{
            idx += 1
            let position = CLLocationCoordinate2D(latitude: input.lat, longitude: input.lng)
            let purpose_id = self.user_id_to_purpose_id(idx: idx)
            if !is_active_purpose[purpose_id]{
                continue
            }
            var icon = GMSMarker.markerImage(with: .black)
            if input.type == "pin"{
                let size_w = 20.0
                let size_h = size_w * 605.0 / 420.0
                switch purpose_id {
                case 0:
                    icon = imageWithImage(image: UIImage(named: "a")!, scaledToSize: CGSize(width: size_w, height: size_h))
                case 1:
                    icon = imageWithImage(image: UIImage(named: "b")!, scaledToSize: CGSize(width: size_w, height: size_h))
                case 2:
                    icon = imageWithImage(image: UIImage(named: "c")!, scaledToSize: CGSize(width: size_w, height: size_h))
                default:
                    icon = imageWithImage(image: UIImage(named: "d")!, scaledToSize: CGSize(width: size_w, height: size_h))
                }
            }
            else if input.type == "circle"{
                let size = 20.0 * sqrt(Double(input.count))
                switch purpose_id {
                case 0:
                    icon = imageWithImage(image: UIImage(named: "0")!, scaledToSize: CGSize(width: size, height: size))
                case 1:
                    icon = imageWithImage(image: UIImage(named: "1")!, scaledToSize: CGSize(width: size, height: size))
                case 2:
                    icon = imageWithImage(image: UIImage(named: "2")!, scaledToSize: CGSize(width: size, height: size))
                default:
                    icon = imageWithImage(image: UIImage(named: "3")!, scaledToSize: CGSize(width: size, height: size))
                }
            }
            else if input.type == "me"{
                // DBの送信してDBから取得した情報 : ラグがあるので良くない
                icon = GMSMarker.markerImage(with: .red)
            }
            else{
                assert(false)
            }
            self.markers[idx].set_marker(icon: icon, position: position, mapView: mapView)
        }
    }

}
