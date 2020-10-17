//
//  PlayerViewController.swift
//  FLO_Music_App
//
//  Created by yoon tae soo on 2020/10/17.
//

import UIKit

class PlayerViewController: UIViewController {

    @IBOutlet weak var ablumImage: UIImageView!
    
    let splashViewModel = SplashViewModel()
    var musicData : musicInfo? = nil {
        didSet{
            setUIImage()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let inputURL = "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/song.json"
        if let URL = splashViewModel.returnURL(url: inputURL){
            
        splashViewModel.returnMusicinfo(URL) { (result) in
            
            switch result {
            
            case .success(let info):
                self.musicData = info
            case .failure(let error):
                print(error.rawValue)
            }
        }
        
        }
        else{
            print("URL is wrong")
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

}

extension PlayerViewController {
    
    func setUIImage(){
        
        guard let url = splashViewModel.returnURL(url: musicData!.image) else{
            print("NO DATA Image")
            return}
        
        splashViewModel.getImage(url: url) { (result) in
    
            DispatchQueue.main.async {
                
                switch result {
                
                case .success(let responseImage):
                    self.ablumImage.image = UIImage(data: responseImage)
                case .failure(_):
                    self.ablumImage.image = UIImage(named: "FLO_EMPTYIMAGE.png")
                }
                
            }
            
        }
        
        
    }
    
    
}
