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

class SplashViewModel {
    
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
    
    
    
}
