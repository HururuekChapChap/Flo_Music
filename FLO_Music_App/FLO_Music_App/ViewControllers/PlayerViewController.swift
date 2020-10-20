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
    
    @IBOutlet weak var seekBar: UISlider!
    
    let splashViewModel = ApiViewModel()
    let playerViewModel = PlayerViewModel.singleton
    
    var itemToplay : AVPlayerItem? = nil
    

    //    var lyrics : [String : String] = ["00:00":"연주"]
    var lyrics : [Int : String] = [:]
    
    //1일차 구현
    var musicData : musicInfo? = nil {
        didSet{
            setUIImage()
            setUILabel()
            prepareToPlay()
            
            //4일차구현
            splashViewModel.getlyrics(lyrics: musicData!.lyrics) { (dictionay) in
                self.lyrics = dictionay
                self.lyrics[0] = "연주"
            }
            //

        }
    }
    
    var seekingPressed : Bool = false
    
    @IBOutlet weak var lyricLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //1일차 구현
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
        
        
        //3일차 구현
        let timeSeek = CMTime(seconds: 1, preferredTimescale: 1000) // 0.1초
        
        let _ = playerViewModel.player.addPeriodicTimeObserver(forInterval: timeSeek, queue: .main) { (currentTime) in
            let time = CMTime(seconds: currentTime.seconds, preferredTimescale: currentTime.timescale).seconds
            self.updateSlider(time: time)
        }
        
        
    }
    
    //2일차 구현
    override func viewDidLayoutSubviews() {
            
        if #available(iOS 13.0 , *){}
        else{

            playButton.setImage(UIImage(named: "playFill.png"), for: .normal)
    
        }
        
    }
    
    
    //2일차 구현
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
    
    //3일차 구현
    @IBAction func seekBarPressed(_ sender: UISlider) {
        
        seekingPressed = true
        
    }
    
    //3일차 구현
    @IBAction func seekBarOut(_ sender: UISlider) {
        

        let second = sender.value * Float( musicData!.duration )
        let cmtime = CMTime(seconds: Double(second), preferredTimescale: 1000)
            
        playerViewModel.seek(time: cmtime) { (_) in
            self.seekingPressed = false
        }
        
        
    }
    
    @IBAction func seekBarAction(_ sender: UISlider) {

    }
    
}

extension PlayerViewController {
    
    //2일차 구현
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
    
    //2일차 구현
    func changePlayBtnPlay(){
        
        playButton.isSelected  = true
        
        if #available(iOS 13.0, *){
            
            //Configuration Point Size를 지정해줄 수 있는 함수 이다.
            let configuration = UIImage.SymbolConfiguration(pointSize: 50)
            let image = UIImage(systemName: "pause.fill", withConfiguration: configuration)
            playButton.setImage(image, for: .normal)
            
        }
        else{
            
            playButton.setImage(UIImage(named: "pause.png"), for: .selected)
            
        }
 
    }
    
    //3일차 구현
    func updateSlider(time : Double){
        
        let currentTime = Int(time)
        
        //4일차 구현
        let time = splashViewModel.searchLyrics(time: currentTime)

        if let exist = lyrics[time]{
            lyricLabel.text = exist
        }
        //
        
        currentTimeLabel.text = String(format: "%02d:%02d", currentTime / 60 , currentTime % 60)
        
        if !seekingPressed{
    
        seekBar.value = Float( Float(currentTime) / Float(musicData!.duration) )
            
        
        if seekBar.value == 1 {
            playerViewModel.seek(time: CMTime.zero){_ in }
            changePlayBtnPlause()
            playerViewModel.plause()
            
        }
            
        }
        
    }
    
}

extension PlayerViewController {
    
    //1일차 구현
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
    
    //1일차 구현
    func setUILabel(){
        
        DispatchQueue.main.async {
            
            self.songName.text = self.musicData!.title
            self.artistName.text = self.musicData!.singer
            self.albumName.text = self.musicData!.album
            
        }
        
    }
    
    //2일차 구현
    func prepareToPlay(){
        
        guard let url = splashViewModel.returnURL(url: musicData!.file) else{
            print("NO Music Data")
            return
        }
        
        itemToplay = AVPlayerItem(url: url)
        playerViewModel.replaceCurrentItem(with: itemToplay)
        
//        print(playerViewModel.player.currentItem)
        
        //4일차 구현
        DispatchQueue.main.async {
            self.endTimeLabel.text = String(format: "%02d:%02d", self.musicData!.duration / 60 , self.musicData!.duration % 60)
        }
        
    }
    
}
