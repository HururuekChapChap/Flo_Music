//
//  SplashViewModel.swift
//  FLO_Music_App
//
//  Created by yoon tae soo on 2020/10/17.
//

import Foundation

enum APIERROR : String, Error {
    case statusEr = "statusError"
    case requestEr = "requestError"
    case emptydata = "data is nil"
}

struct musicInfo : Codable {
    
    let singer : String
    let album : String
    let title : String
    let duration : Int
    let image : String
    let file : String
    let lyrics : String
    
}

//1일차 구현
class ApiViewModel {
    
    //4일차 구현
    var search : [Int] = []
    
    public func returnURL(url : String) -> URL?{
        
        guard let urlComponent = URLComponents(string: url) else {return nil}

        return urlComponent.url
    }
    
    public func returnMusicinfo(_ url : URL , completeHandler : @escaping(Result<musicInfo,APIERROR>) -> ()) {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        session.dataTask(with: url) { (data, res, error) in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return}
            guard let statusCode = (res as? HTTPURLResponse)?.statusCode else {
                completeHandler(.failure(.statusEr))
                return}
            if !(200..<300).contains(statusCode){
                completeHandler(.failure(.requestEr))
                return}
            
            guard let result = data else {
                completeHandler(.failure(.emptydata))
                return
            }
            
            do{
                
                let response = try JSONDecoder().decode(musicInfo.self, from: result)
                completeHandler(.success(response))
                
            }
            catch let error{
                print(error.localizedDescription)
            }
            
        }.resume()
        
    }
    
    public func getImage(url : URL , completeHandler : @escaping (Result<Data,APIERROR>) -> ()){
        
        DispatchQueue.global().async {
            
            if let responseImage = try? Data(contentsOf: url) {
                
                completeHandler(.success(responseImage))
                    
            }
            else{
                completeHandler(.failure(.emptydata))
            }
            
        
        }
        
    }
    
    //4일차 구현
    func returnStringByRex(pattern : String , word : String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            
            let result = regex.matches(in: word, options: [], range: NSRange(location: 0, length: word.count))
            
            let rexStrings = result.map { (element) -> String in
                
                let range = Range(element.range, in: word)!
                
                return String(word[range])
                
            }
            
            return rexStrings
        } catch let error {
            print(error.localizedDescription)
        }
        
        return []
        
    }
    
    //4일차 구현
    func getlyrics(lyrics : String , completeHandler : @escaping([Int: String])->()){
        
        let list = lyrics.components(separatedBy: "\n")
        
        var dict : [Int : String] = [:]
        
//        var dict : [String : String] = [:]
        
        DispatchQueue.global().async {
            
            for element in list{
                
                let time = self.returnStringByRex(pattern: "[0-9][0-9]:[0-9][0-9]", word: element).first!
                let word = element.components(separatedBy: "]")[1]
                
                let minute = Int(time.components(separatedBy: ":")[0])!
                let second = Int(time.components(separatedBy: ":")[1])!
                
                let totalTime = minute * 60 + second
                dict[totalTime] = word
                self.search.append(totalTime)
//                dict[time] = word
                
            }
            
            completeHandler(dict)
//            completeHandler(dict)
            
        }
        
        
    }
    
    //4일차 구현
    func searchLyrics(time : Int) -> Int{
        
        var start = 0
        var end = search.count - 1
        
        while start <= end {
            
            let mid = (start + end) / 2
            
            if search[mid] < time {
                start = mid + 1
            }
            else if search[mid] == time {
                return search[mid]
            }
            else{
                end = mid - 1
            }
            
        }
        
        return end < 0 ? 0 : search[end]
        
    }
    
    
}
