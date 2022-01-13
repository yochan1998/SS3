//
//  FeedbackViewController.swift
//  Fire Fly
//
//  Created by 酒井のどか on 2022/01/09.
//

import UIKit

class FeedbackViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func successMatching() {
        //データベースに出会えたことをフィードバックするコード
        
        //地図ページに戻るコード
        //地図ページに戻るコード
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func failMatching(){
        //データベースに出会えなかったことをフィードバックするコード
        
        //地図ページに戻るコード
        self.dismiss(animated: true, completion: nil)
    }



}
