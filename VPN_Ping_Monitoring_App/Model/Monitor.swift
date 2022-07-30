//
//  Monitor.swift
//  VPN_Ping_Monitoring_App
//
//  Created by Vladimir Vinageras on 21.07.2022.
//
/*
import SwiftUI
import Foundation

//You are working on Transformation Branch
//Create a new Wrapper Class
//After that, create a [Wrapper] var  and start working form here
    
struct Monitor: Identifiable, Codable{
        var HTTP_STRING = "https://"
    
    let id: UUID
       
        var hostname: String = ""
        var hostStatusMessage: String = ""

    init(id: UUID = UUID(), hostname: String){
        self.id = id
        self.hostname = hostname
        }

       
         func isHostReachable()-> Bool{
                
                if  self.sendHTTPRequest() != Status.reachable {
                    return false
                }
                 return true
                
            }
    
 /*  func sendHTTPRequest()-> Status{
            let hostUrl: String = HTTP_STRING + self.hostname
          var serverStatus : Status = .unknown
            
            if let url = URL(string: hostUrl){
                var request = URLRequest(url: url)
                request.httpMethod = "HEAD"
                URLSession(configuration: .default)
                    .dataTask(with: request){(_, response, error) -> Void in
                        guard error == nil else{
                            NSLog("ERROR trying to reach server \(self.hostname)")
                            serverStatus = .unknown
                            return
                        }
                        guard (response as? HTTPURLResponse)?
                            .statusCode == 200 else {
                            serverStatus = .unreachable
                            NSLog("The server \(self.hostname) is down")
                            
                            return
                    }
                        NSLog("The server \(self.hostname) is ok")
                        serverStatus = .reachable
        
                    }
                    .resume()
            }
        
          return serverStatus
        } */
    
    mutating func updatingStatusMessage(serverStatus: Status){
        hostStatusMessage = serverStatus.Status()
    }
    }


extension Monitor{
    struct Data{
        var hostname: String = ""
    }
    
    
    var data: Data{
        Data(hostname: hostname)
    }
    
    mutating func update(from data: Data){
        hostname = data.hostname
    }
    
    init(data : Data){
        id = UUID()
        hostname = data.hostname
    }
}

extension Monitor{
    
    static let sampleMonitor : Monitor = Monitor(hostname: "swift.org")
    }





*/
