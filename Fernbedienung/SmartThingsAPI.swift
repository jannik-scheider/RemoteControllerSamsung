//
//  SmartThingsAPI.swift
//  Fernbedienung
//
//  Created by Jannik Scheider on 15.05.24.
//

import Foundation
import Alamofire

class SmartThingsAPI {
    let apiKey = "your api key"

    func getDevices(completion: @escaping ([Device]) -> Void) {
        let url = "https://api.smartthings.com/v1/devices"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)"
        ]
        
        AF.request(url, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any], let items = json["items"] as? [[String: Any]] {
                    var devices: [Device] = []
                    for item in items {
                        if let id = item["deviceId"] as? String, let label = item["label"] as? String {
                            let device = Device(id: id, label: label)
                            devices.append(device)
                        }
                    }
                    completion(devices)
                } else {
                    completion([])
                }
            case .failure(let error):
                print("Failed to get devices: \(error)")
                completion([])
            }
        }
    }

    func setVolume(deviceID: String, volume: Int, completion: @escaping (Bool) -> Void) {
        let url = "https://api.smartthings.com/v1/devices/\(deviceID)/commands"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = [
            "commands": [
                [
                    "component": "main",
                    "capability": "audioVolume",
                    "command": "setVolume",
                    "arguments": [volume]
                ]
            ]
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response { response in
            switch response.result {
            case .success:
                completion(true)
            case .failure(let error):
                print("Failed to set volume: \(error)")
                completion(false)
            }
        }
    }
}
