//
//  PlayerViewController.swift
//  FLO_Music_App
//
//  Created by yoon tae soo on 2020/10/17.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {

    @IBOutlet weak var ablumImage: UIImageView!
    @IBOutlet weak var imageContainerView: UIView!
    
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumName: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    
    let splashViewModel = ApiViewModel()
    let playerViewModel = PlayerViewModel.singleton
    
    var itemToplay : AVPlayerItem? = nil
    
    
    var musicData : musicInfo? = nil {
        didSet{
            setUIImage()
            setUILabel()
            prepareToPlay()
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
            
        if #available(iOS 13.0 , *){}
        else{

            playButton.setImage(UIImage(named: "playFill.png"), for: .normal)
    
        }
        
    }
    
    
    @IBAction func playerBtn(_ sender: UIButton) {
                
        if playerViewModel.isPlaying() {
            changePlayBtnPlause()
            playerViewModel.plause()
        }
        else{
            changePlayBtnPlay()
            playerViewModel.play()
        }
        
    }
    
}

extension PlayerViewController {
    
    func changePlayBtnPlause(){
                
        playButton.isSelected  = false
        
        if #available(iOS 13.0, *){
            
            let configuration = UIImage.SymbolConfiguration(pointSize: 50)
            let image = UIImage(systemName: "play.fill", withConfiguration: configuration)
            playButton.setImage(image, for: .normal)
            
        }
        else{
                
            guard let image = UIImage(named: "playFill.png") else {
                print("pause.png empyt")
                return}
            
            playButton.setImage(image, for: .normal)
            
        }
        
    }
    
    func changePlayBtnPlay(){
        
        playButton.isSelected  = true
        
        if #available(iOS 13.0, *){
            
            let configuration = UIImage.SymbolConfiguration(pointSize: 50)
            let image = UIImage(systemName: "pause.fill", withConfiguration: configuration)
            playButton.setImage(image, for: .normal)
            
        }
        else{
            
            playButton.setImage(UIImage(named: "pause.png"), for: .selected)
            
        }
        
        
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
    
    func setUILabel(){
        
        DispatchQueue.main.async {
            
            self.songName.text = self.musicData!.title
            self.artistName.text = self.musicData!.singer
            self.albumName.text = self.musicData!.album
            
        }
        
    }
    
    func prepareToPlay(){
        
        guard let url = splashViewModel.returnURL(url: musicData!.file) else{
            print("NO Music Data")
            return
        }
        
        itemToplay = AVPlayerItem(url: url)
        playerViewModel.replaceCurrentItem(with: itemToplay)
        
//        print(playerViewModel.player.currentItem)
        

    }
    
    
}
