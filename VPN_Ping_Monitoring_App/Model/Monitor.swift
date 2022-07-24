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
        
        @State private var failureCounter: Int = 0
        @State var isServerReachable: Bool = false
        @State var isMonitoring: Bool = false
        @State var serverState: Status = .unreachable
        
        var hostname: String = ""
        var ipAddress: String = ""
        var checkFrequency: Double = 5
        
        
        
        
        init(hostname: String, ipAddress: String, checkFrequency: Int){
            self.hostname = hostname
            self.ipAddress = ipAddress
            self.checkFrequency = Double(checkFrequency)
            }
        
        func monitoringServer() {
            monitoringRequest()
        }
        
        private func monitoringRequest(){
            isMonitoring = true
            Timer.scheduledTimer(withTimeInterval: checkFrequency, repeats: true){ timer in
                    serverState = sendHTTPRequest()
                if  serverState != Status.reachable {
                    failureCounter += 1
                    isMonitoring = false
                }
                
                if failureCounter >= 5 {
                    timer.invalidate()
                }
            }
          
        }
        
      func sendHTTPRequest()-> Status{
            let hostUrl: String = HTTP_STRING + self.hostname
          var serverState : Status = .unknow
            
            if let url = URL(string: hostUrl){
                var request = URLRequest(url: url)
                request.httpMethod = "HEAD"
                URLSession(configuration: .default)
                    .dataTask(with: request){(_, response, error) -> Void in
                        guard error == nil else{
                            NSLog("ERROR")
                            serverState = .unknow
                            return
                        }
                        guard (response as? HTTPURLResponse)?
                            .statusCode == 200 else {
                            serverState = .unreachable
                            NSLog("The host is down")
                            
                            return
                    }
                        NSLog("The server is ok")
                        serverState = .reachable
        
                    }
                    .resume()
            }
          return serverState
        }
    }

    
    var monitor: Monitor{
        Monitor(hostname: hostname, ipAddress: hostname, checkFrequency: checkFrequency)
        }
    
    

}
