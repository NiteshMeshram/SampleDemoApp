//
//  DataManager.swift
//  SampleDemoApp
//
//  Created by Nitesh Meshram on 02/06/19.
//  Copyright © 2019 Nitesh Meshram. All rights reserved.
//

import Foundation

let apiURLPath: String = "https://dl.dropboxusercontent.com"
enum DemoUri {
    
    case apiURL
    
    func uriString() -> String {
        switch self {
        case .apiURL: return "/s/2iodh4vg0eortkl/facts.json"
            //            https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json
            
        }
        
    }
}



class DataManager {
    
     typealias JSONDictionary = [String: Any]
    var modelArray: [DataModel] = []
    
    // 1
    let defaultSession = URLSession(configuration: .default)
    // 2
    var dataTask: URLSessionDataTask?
    
    var errorMessage = ""
    
    class func sharedInstance() -> DataManager {
        struct Static {
            //Singleton instance. Initializing Data manager.
            static let sharedInstance = DataManager()
        }
        /** @return Returns the default singleton instance. */
        return Static.sharedInstance
    }
    
    func readLocalJson() {
        do {
            if let file = Bundle.main.url(forResource: "sampledemo", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let responseJSONDict = try JSONSerialization.jsonObject(with: data, options: [])  as? JSONDictionary
                self.createModelObjects(objectDictionary: responseJSONDict!)
            
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func createModelObjects(objectDictionary: JSONDictionary) {
        
        if let rowArray = objectDictionary["rows"] as? [JSONDictionary] {
            var index = 0
            for objectDictionary in rowArray {
                
                if let tuple = objectDictionary as? JSONDictionary,
                    
                    let imageHrefString = tuple["imageHref"] as? String,
                    let imageURL = URL(string: imageHrefString),
                    
                    let title = tuple["title"] as? String,
                    let description = tuple["description"] as? String {
                    
                    modelArray.append(DataModel(title: title, description: description, imageHref: imageURL, index: index))
                    
                    index += 1
                } else {
                    errorMessage += "Problem parsing trackDictionary\n"
                }
            }
        }
        
    }
    
    
    
    func factsAPI() {
        dataTask?.cancel()
        
        let urlString = "\(apiURLPath)\(DemoUri.apiURL.uriString())"
        
        if var urlComponents = URLComponents(string: urlString) {
            guard let url = urlComponents.url else { return }
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    self.parseResuslt(data)
                    DispatchQueue.main.async {
                        //                        completion(self.tracks, self.errorMessage)
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    func parseResuslt( _ data: Data) {
        
        
       
        //            tracks.removeAll()
        
        let responseStrInISOLatin = String(data: data, encoding: String.Encoding.isoLatin1)
        guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
            print("could not convert data to UTF-8 format")
            return
        }
        do {
            let responseJSONDict = try JSONSerialization.jsonObject(with: modifiedDataInUTF8Format) as? JSONDictionary
//            print(responseJSONDict)
            
            if let rowData = responseJSONDict?["rows"] as? [JSONDictionary] {
                print(rowData)
            }
            
            
//            guard let array = response!["rows"] as? [Any] else {
//                errorMessage += "Dictionary does not contain results key\n"
//                return
//            }
//
//            var index = 0
//            for trackDictionary in array {
//
//                print(trackDictionary)
//
//
//                if let trackDictionary = trackDictionary as? JSONDictionary,
//                    let previewURLString = trackDictionary["previewUrl"] as? String,
//                    let previewURL = URL(string: previewURLString),
//                    let name = trackDictionary["trackName"] as? String,
//                    let artist = trackDictionary["artistName"] as? String {
//                    tracks.append(Track(name: name, artist: artist, previewURL: previewURL, index: index))
//                    index += 1
//                } else {
//                    errorMessage += "Problem parsing trackDictionary\n"
//                }
//
//            }

            
        } catch {
            print(error)
        }
        
    }
    
}
