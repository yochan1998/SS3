
import UIKit
import AVFoundation

class LightViewController: UIViewController {
    
    //選択された目的に合わせてピンを表示させ、同じ目的を持った他のユーザと近づいた場合合体
    //点灯ボタンタップでライト点灯
    //再度同じボタンタップで消灯&フィードバックページへ
    
    @IBOutlet var lightButton: UIButton!
    var toggle:Bool = true
    var timer: Timer!
    var beerSwitch: Bool = false
    var tradeSwitch: Bool = false
    let avDevice = AVCaptureDevice.default(for: AVMediaType.video)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ライトボタンの背景を白く
        lightButton.backgroundColor = UIColor.white
        //ボタンの角を丸く
        lightButton.layer.cornerRadius = 10.0
    }
    
    //ライトボタンが押された時の処理
    @IBAction func buttonTapped(_ sender : Any) {
        if(toggle){
            ledFlash(flg: true)
            toggle = false
            lightButton.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        }
        else{
            ledFlash(flg: false)
            toggle = true
        }
    }
    

    func ledFlash(flg: Bool){
        //使用している端末にライトが付いているかどうか
        if avDevice.hasTorch {
            do {
                // torch device lock on
                try avDevice.lockForConfiguration()
                
                //点灯ボタンが押されているかどうか
                if (flg){
                    // ビールを選択しているとき、1秒ごとに点滅させる
                    if (beerSwitch){
                        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                        timer.fire()
                    }
                    // 交換を選択しているとき、0.5秒ごとに点滅させる
                    else if (tradeSwitch){
                        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                        timer.fire()
                    }
                } else {
                    // flash LED OFF
                    avDevice.torchMode = AVCaptureDevice.TorchMode.off
                    stopTimer()
                    //ライトボタンの背景を白に戻す
                    lightButton.backgroundColor = UIColor.white
                    //フィードバック画面に遷移
                    self.performSegue(withIdentifier: "toFeedback", sender: self)
                }
                // torch device unlock
                avDevice.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    //ライトボタンがtrueの間, 行われる処理
    var time = 1
    @objc func update(tm: Timer) {
        //この関数を繰り返す、repeat this function
        if avDevice.hasTorch {
            do {
                // torch device lock on
                try avDevice.lockForConfiguration()
                
                time += 1
                if time == 1 {
                    // 昼のとき、ライトを明るくする
                    // 関数getTimeの中身は一番下にあります
                    if "06:00:00" <= getTime() && getTime() <= "17:00:00" {
                        try avDevice.setTorchModeOn(level: 1)
                        print("お昼だよー")
                    }
                    // 夜のとき、ライトを暗くする
                    else {
                        try avDevice.setTorchModeOn(level: 0.25)
                        print("夜でーす")
                    }
                } else if time == 2 {
                    avDevice.torchMode = AVCaptureDevice.TorchMode.off
                    time = 0
                }
                //print(time)
                avDevice.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    //タイマーのていし
    func stopTimer() {
        timer.invalidate()
    }
    // 現在時刻を取得する関数getTime
    func getTime () -> String {
    let date = Date()
    let df = DateFormatter()
    df.dateFormat = "HH:mm:ss"
    let string = df.string(from: date)
    return string
}
}
