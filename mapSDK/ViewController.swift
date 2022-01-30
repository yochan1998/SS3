//
//  ViewController.swift
//  mapSDK
//
//  Created by k i on 2021/12/13.
//

// 2022/01/16 : storyboard上の目的選択ボタンをマップのマーカーに反映


import UIKit
import Firebase
import GoogleMaps
import GooglePlaces

var timer_Foreground: Timer!
var timer_Background: Timer!
let TIME_INTERVAL = 0.1
let loop_DB = 20 // 0.1*20=2[s]
let MY_ID = 0
let deviceId = UIDevice.current.identifierForVendor!.uuidString

class ViewController: UIViewController, CLLocationManagerDelegate {    
    var t = 0.0 // アプリ起動時からの経過時間[s]
    var markers_info = Markers_info()
    var input_info = GetData()
    var output_info = SetData()
    var my_info = My_info(my_id: MY_ID)
    var locationManager = CLLocationManager()
    //var mapView: GMSMapView!
    var centerLocationSwitch: Bool = true
    var loopCount = 0
    var pin_circle_array: Array<Pin_circle_data> = []
    //var databaseRef: DatabaseReference!
    func loop_Foreground(){
        // フォアグラウンドで一定間隔で実行する処理
        // my_id : ユーザのID
        my_info.Reload_Position() // 位置情報の更新
        markers_info.Reload_marker(pin_circle_array: pin_circle_array, my_id: MY_ID) // 画面表示
        /*
        for purpose in markers_info.new_purpose_set{
            // 新規の目的があれば画面のボタンを追加
            if purpose == "beer"{
                
            }
            else if purpose == "trade"{
                
            }
        }
        */
        if(loopCount % 20) == 0 {
            output_info.Set_my_position(my_info: my_info) // 位置情報の送信
        }
        if(loopCount % 20) == 0{
            pin_circle_array = input_info.Get_pin_circle_data(my_info: my_info, t: t, my_id: MY_ID) // ピン,丸情報の受信
        }
        
        //カメラ座標変更(1度だけ)
        if mLat != nil {
            if centerLocationSwitch == true {
                let camera = GMSCameraPosition.camera(withLatitude: my_info.CameraLat, longitude: my_info.CameraLng, zoom: 18.0)
                mapView.animate(to: camera)
                print(my_info.CameraLat,",",my_info.CameraLng)
                centerLocationSwitch = false
            }
        }
        t += TIME_INTERVAL
        loopCount += 1
    }
    
    // バックグラウンドで一定間隔で実行する処理
    // Background App Refresh Tasks (Background Fetch), Background Processing Tasksなどを使うとできるらしい？
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 画面サイズの読み込み
        //初期値はApple本社
        let camera = GMSCameraPosition.camera(withLatitude: my_info.CameraLat, longitude: my_info.CameraLng, zoom: 18.0)
        mapView = GMSMapView.map(withFrame: CGRect(origin: .zero, size: view.bounds.size), camera: camera)
        mapView.settings.myLocationButton = true //右下のボタン追加する
        mapView.isMyLocationEnabled = true
        if let mylocation = mapView.myLocation {
          print("User's location: \(mylocation)")
        } else {
          print("User's location is unknown")
        }
        
        //let marker = GMSMarker()
        //marker.position = CLLocationCoordinate2D(latitude: my_info.MyLat, longitude: my_info.MyLng)
        //marker.map = mapView
        // バックグラウンドでの位置情報更新を許可
        // locationManager.allowsBackgroundLocationUpdates = true
        

        // User Location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

        self.view.addSubview(mapView)
        self.view.bringSubviewToFront(mapView)
        //print(mapView)
        
        
        timer_Foreground = Timer.scheduledTimer(timeInterval: TIME_INTERVAL, target: self, selector: #selector(self.update_Foreground), userInfo: nil, repeats: true)
        timer_Foreground.fire()
    }
    @objc func update_Foreground(tm: Timer) {
        //この関数を繰り返す、repeat this function
        loop_Foreground()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let newLocation = locations.last else {
            return
        }

        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)
        
        mLat = location.latitude
        mLng = location.longitude
    }
}
