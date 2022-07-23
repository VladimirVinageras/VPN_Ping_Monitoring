//
//  Monitor.swift
//  VPN_Ping_Monitoring_App
//
//  Created by Vladimir Vinageras on 21.07.2022.
//

import SwiftUI
import Foundation


extension Host{
    
    struct Monitor{
        let MAX_FAILURE_PERMITTED = 5
        let HTTP_STRING = "https://"
        
        private var failureCounter: Int = 0
        private var isServerReachable: Bool = false
        private var isMonitoring: Bool = false 

        var hostname: String = ""
        var ipAddress: String = ""
        var checkFrequency: Double = 5
        
        
        
        init(hostname: String, ipAddress: String, checkFrequency: Int){
            self.hostname = hostname
            self.ipAddress = ipAddress
            self.checkFrequency = Double(checkFrequency)
            }
        
        func monitoringRequest(){
            Timer.scheduledTimer(withTimeInterval: checkFrequency, repeats: true){timer in
                 sendHTTPRequest()
                if failureCounter >= 5 {
                    timer.invalidate()
                }
            }
        }
        
        func Start(){
            
        }
        
        func Stop(){
            //change
        }
        
        
        func sendHTTPRequest(){
            let hostUrl: String = HTTP_STRING + self.hostname
            
            if let url = URL(string: hostUrl){
                var request = URLRequest(url: url)
                request.httpMethod = "HEAD"
                URLSession(configuration: .default)
                    .dataTask(with: request){(_, response, error) -> Void in
                        guard error == nil else{
                            NSLog("ERROR")
                            
                            return
                        }
                        guard (response as? HTTPURLResponse)?
                            .statusCode == 200 else {
                            NSLog("The host is down")
                            
                            return
                    }
                        NSLog("The server is ok")
                        
                    
                    }
                    .resume()
            }
        }
}

    func StartMonitoring(){
       
    }
    
    func StopMonitoring(){
        
    }
    
    
}
