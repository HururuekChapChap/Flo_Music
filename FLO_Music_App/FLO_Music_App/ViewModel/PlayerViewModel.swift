//
//  PlayerViewModel.swift
//  FLO_Music_App
//
//  Created by yoon tae soo on 2020/10/18.
//

import Foundation
import AVFoundation

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
    
    func replaceCurrentItem(with item: AVPlayerItem?){
        player.replaceCurrentItem(with: item)
    }
    
    
}
