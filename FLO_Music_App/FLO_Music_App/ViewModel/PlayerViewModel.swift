//
//  PlayerViewModel.swift
//  FLO_Music_App
//
//  Created by yoon tae soo on 2020/10/18.
//

import Foundation
import AVFoundation

//2일차 부터 구현 ~
class PlayerViewModel {
    
    static let singleton = PlayerViewModel()
    
    let player = AVPlayer()
    
    func play(){
        
        player.play()
        
    }
    
    func plause(){
        
        player.pause()
    }
    
    
    func isPlaying() -> Bool {
        
        if player.currentItem == nil {return false}
        
        return player.rate == 0 ? false : true
    }
    
    // 재생 음악 변경
    func replaceCurrentItem(with item: AVPlayerItem?){
        player.replaceCurrentItem(with: item)
    }
    
    //4일차 구현
    //음악 재생 시간 변경
    func seek(time : CMTime , completionHandler : @escaping(Bool) -> ()){

//            self.player.seek(to: time)
        self.player.seek(to: time, completionHandler: completionHandler)
            
    }
    
    //5일차 구현
    //mainQueue에서 현재 음악 재생시간을 추적
    func addPeriodicTimeObserver(interval: CMTime, queue: DispatchQueue?, using : @escaping (CMTime) -> Void) -> Any{
        self.player.addPeriodicTimeObserver(forInterval: interval, queue: queue, using: using)
    }
    
    
    
}
