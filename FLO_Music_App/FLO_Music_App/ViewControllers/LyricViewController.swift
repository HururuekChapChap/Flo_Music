//
//  LyricViewController.swift
//  FLO_Music_App
//
//  Created by yoon tae soo on 2020/10/21.
//

import UIKit
import AVFoundation

//5일차 구현 시작
class LyricViewController: UIViewController {

    //5일차
    var handler : ((Int)->())?
    
    var playingHandler : ((Bool)->())?
    
    var lyrics : [Int : String]?
    var stringLyrics : [(word :String, time : Int)] = []
    
    let apiViewModel = ApiViewModel()
    let playerViewModel = PlayerViewModel.singleton
    var timeObserver : Any?
    
    var indexpath : IndexPath?
    var isScrolling : Bool = false
    
    var firtViewLoad : Bool = true
    
    @IBOutlet weak var lyricTableView: UITableView!
    @IBOutlet weak var playerButton: UIButton!
    @IBOutlet weak var toggleSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setdelegate()
        setLyricSorted()
        firstViewLoad()
        loadUISwitch()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //5일차 구현
        let timeSeek = CMTime(seconds: 1, preferredTimescale: 1000)
        
        timeObserver = playerViewModel.addPeriodicTimeObserver(interval: timeSeek, queue: .main) { (currentTime) in
            let time = CMTime(seconds: currentTime.seconds, preferredTimescale: currentTime.timescale).seconds
            
            if !self.isScrolling{
            
            let index = self.searchLyrics(input: time)
            let input = IndexPath(row: index, section: 0)
            self.lyricTableView.scrollToRow(at: input, at: .top, animated: true)
            self.updateCellLabel(input: input)
               
            }
            
        }

        
    }
    
    //5일차 구현
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let token = timeObserver{
            playerViewModel.player.removeTimeObserver(token)
            timeObserver = nil
        }
        
    }
    
    //5일차
    @IBAction func closeBtn(_ sender: UIButton) {
                
        dismiss(animated: true, completion: nil)
        
    }
   
    //6일차 구현
    @IBAction func switchOnOff(_ sender: UISwitch) {
        
        UserDefaults.standard.set(sender.isOn, forKey: "toggleSwitchData")
        
        if sender.isOn{
            lyricTableView.isScrollEnabled = true
        }
        else{
            lyricTableView.isScrollEnabled = false
        }
        
        
    }
    
    @IBAction func playBtn(_ sender: UIButton) {
        
        checkisPlaying()
        
    }
    
}

extension LyricViewController : UITableViewDelegate, UITableViewDataSource{
    
    //5일차
    func setdelegate(){
        self.lyricTableView.delegate = self
        self.lyricTableView.dataSource = self
    }
    
    //5일차
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stringLyrics.count
    }
    
    //5일차
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LyricTableViewCell") as? LyricTableViewCell else{return UITableViewCell()}
        
        cell.updateLyricLable(word: stringLyrics[indexPath.row].word)
        
        return cell
        
    }
    
    //5일차
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 버튼을 눌러서 토글이 켜져 있을 때만 선택 할 수 있도록 해야함.
        //6일차 구현
        if toggleSwitch.isOn {
        
        //5일차 구현 - 핸들러를 이용해서 데이터 재전송 backword
        handler?(stringLyrics[indexPath.row].time)
        
        lyricTableView.reloadData()
        self.indexpath = nil
            
        }
        else{
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    //5일차 구현
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
                
            isScrolling = true

    }
    
    //5일차 구현
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            isScrolling = false
    }
        
}

extension LyricViewController {
    
    //5일차
    func updateCellLabel(input : IndexPath ){
                
            if self.indexpath == nil {

                guard let table = self.lyricTableView.cellForRow(at: input) else {return}
                guard let cell = table as? LyricTableViewCell else{return}

                cell.changeLyricLableUI(color: .orange)
                
                self.indexpath = input

            }
            else{
                
                //현재 indexPath가 보여지지 않을 경우에는 오류가 발생한다.
                //이 부분을 해결해줘야한다.
                //그래서 계속 추적이 필요하다.
                guard let beforeTable = self.lyricTableView.cellForRow(at: self.indexpath! ) else {
                    print("1")
                    self.indexpath = nil
                    return}
                guard let beforeCell = beforeTable as? LyricTableViewCell else{
                    print("2")
                    self.indexpath = nil
                    return}
                
                beforeCell.changeLyricLableUI(color: .black)
                
                guard let table = self.lyricTableView.cellForRow(at: input) else {
                    print("3")
                    self.indexpath = nil
                    return}
                guard let cell = table as? LyricTableViewCell else{
                    print("4")
                    self.indexpath = nil
                    return}

                cell.changeLyricLableUI(color: .orange)
                
                self.indexpath = input

            }
            
    }
    
    
    //5일차
    func setLyricSorted(){
        
        guard let lyrics = lyrics else {return}
        
        let sortLyrics = lyrics.sorted { (element1, element2) -> Bool in
            return element1.key < element2.key
        }
        
        let makeArray = sortLyrics.map { (element) -> (String,Int )in
            return (element.value , element.key)
        }
        
        stringLyrics = makeArray
     
        lyricTableView.reloadData()
        
    }
    
    //4일차 구현
    func searchLyrics(input : Double) -> Int{
        
        let time = Int(input)
        var start = 0
        var end = stringLyrics.count - 1
        
        while start <= end {
            
            let mid = (start + end) / 2
            
            if stringLyrics[mid].time < time {
                start = mid + 1
            }
            else if stringLyrics[mid].time == time {
                return mid
            }
            else{
                end = mid - 1
            }
            
        }
        
        return end < 0 ? 0 : end
        
    }
    
    //6일차 구현
    func checkisPlaying(){
        
        //재생을 -> 멈춤
        if playerViewModel.isPlaying() {
            playingHandler?(false)
            changePlayBtnPlause()
            playerViewModel.plause()
        }
        //멈춤 -> 재생
        else{
            playingHandler?(true)
            changePlayBtnPlay()
            playerViewModel.play()
        }
        
    }
    
    //6일차 구현
    func firstViewLoad(){
        
        if playerViewModel.isPlaying() {
            changePlayBtnPlay()
        }
        else{
            changePlayBtnPlause()
        }
        
        
    }
    
    
    //6일차 구현
    func changePlayBtnPlause(){
                
        playerButton.isSelected  = false
        
        guard let image = UIImage(named: "playFill.png") else {
                print("pause.png empyt")
                return}
            
        playerButton.setImage(image, for: .normal)
            
        
    }
    
    //6일차 구현
    func changePlayBtnPlay(){
        
        playerButton.isSelected  = true
        
        playerButton.setImage(UIImage(named: "pause.png"), for: .selected)
            
    }
    
    //6일차 구현
    func loadUISwitch(){
        if let toggleSwitchData = UserDefaults.standard.value(forKey: "toggleSwitchData"){
            
            toggleSwitch.isOn = toggleSwitchData as! Bool
            
            if toggleSwitch.isOn {
                lyricTableView.isScrollEnabled = true
            }
            else{
                lyricTableView.isScrollEnabled = false
            }
            
        }
    }
    
    
}

