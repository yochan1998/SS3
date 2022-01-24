//
//  PurposeChooseViewController.swift
//  Fire Fly
//
//  Created by 酒井のどか on 2022/01/09.
//


import UIKit

//継承元をViewControllerに変更
class PurposeChooseViewController: ViewController {
    
    @IBOutlet var beerButton: UIButton!
    @IBOutlet var tradeButton: UIButton!
    @IBOutlet var buttonView: UIView!
    let beerImage = UIImage(named: "beer2.png")
    let tradeImage = UIImage(named: "trade.png")
    let lightImage = UIImage(named: "light.png")
    var beerSwitch = false
    var tradeSwitch = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //最初のボタンの背景色を白に設定
        beerButton.backgroundColor = UIColor.white
        tradeButton.backgroundColor = UIColor.white
        //ボタンの角を丸く
        beerButton.layer.cornerRadius = 10.0
        tradeButton.layer.cornerRadius = 10.0
        
        //ボタンに画像をセット
        beerButton.setImage(beerImage, for: .normal)
        tradeButton.setImage(tradeImage, for: .normal)
        
        //viewを最前面に移動
        self.view.addSubview(buttonView)
        self.view.bringSubviewToFront(buttonView)
        
        //ボタンを最前面に移動
        self.view.addSubview(beerButton)
        self.view.bringSubviewToFront(beerButton)
        self.view.addSubview(tradeButton)
        self.view.bringSubviewToFront(tradeButton)
    }
    
    //ビールボタンが押された時の処理
    @IBAction func Beer(){
        self.markers_info.Reverse_marker(purpose: "beer") //beerマーカーの表示,非表示を反転
        if ( beerSwitch ) {
            //ビールボタンが選択されていない場合
            print("false")
            beerSwitch = false
            beerButton.backgroundColor = UIColor.white
        }
        else {
            //ビールボタンが選択されている場合
            print("true")
            beerSwitch = true
            beerButton.backgroundColor = UIColor.black.withAlphaComponent(0.15)
            
            //地図上に「飲み」を目的として設定している人のピンを表示
        }
    }
    
    //交換ボタンが押された時の処理
    @IBAction func Trade(){
        self.markers_info.Reverse_marker(purpose: "trade") //tradeマーカーの表示,非表示を反転
        if ( tradeSwitch ) {
            //交換ボタンが選択されていない場合
            print("false")
            tradeSwitch = false
            tradeButton.backgroundColor = UIColor.white
        }
        else {
            //交換ボタンが選択されている場合
            print("true")
            tradeSwitch = true
            tradeButton.backgroundColor = UIColor.black.withAlphaComponent(0.15)
            
            //地図上に「交換」を目的として設定している人のピンを表示

        }
        
    }
    
    
    //右上の完了ボタン
    @IBAction func done(){
        //選ばれている目的が1種類の場合、「探索ページ」へ
        //それ以外は警告を表示
        
        if beerSwitch == true && tradeSwitch == false{
            
            //ビールボタンだけ選択 → 探索モードへ移行し、飲み仲間探索
            self.performSegue(withIdentifier: "startSearch", sender: self)
            
        } else if beerSwitch == false && tradeSwitch == true {
            
            //交換ボタンだけ選択 → 探索モードへ移行し、交換仲間探索
            self.performSegue(withIdentifier: "startSearch", sender: self)
            
        } else {
            
            //選択されている目的が0or2 → 警告表示
            let alert = UIAlertController(title: "注意！", message: "目的を1つだけ選択してください", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // OKボタンが押されたらアラートを消す
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            // アラート表示
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    //beerとtradeのどちらが選ばれたか、ViewControllerへ値渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let nextViewController = segue.destination as! LightViewController
        nextViewController.beerSwitch = beerSwitch
        nextViewController.tradeSwitch = tradeSwitch
        
    }

}

