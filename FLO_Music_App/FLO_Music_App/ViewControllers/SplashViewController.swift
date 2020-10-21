//
//  SplashViewController.swift
//  FLO_Music_App
//
//  Created by yoon tae soo on 2020/10/17.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
                if #available(iOS 13.0, *) {
                    
                    
                    guard let playerVC = self.storyboard?.instantiateViewController(identifier: "PlayerViewController") else {return}
                    
                    playerVC.modalPresentationStyle = .overFullScreen
                    playerVC.modalTransitionStyle = .crossDissolve
                    
                    self.present(playerVC, animated: true, completion: nil)
                    
                    
                }
                else {
                    // Fallback on earlier versions
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let playerVC  = storyBoard.instantiateViewController(withIdentifier: "PlayerViewController")
                    
                    playerVC.modalPresentationStyle = .overFullScreen
                    playerVC.modalTransitionStyle = .crossDissolve
                    
                    self.present(playerVC, animated: true, completion: nil)
                    
                }
           
            
            
        }
        
    }

}
