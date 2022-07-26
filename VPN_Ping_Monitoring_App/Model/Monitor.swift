//
//  Monitor.swift
//  VPN_Ping_Monitoring_App
//
//  Created by Vladimir Vinageras on 21.07.2022.
//

import SwiftUI
import Foundation


    
    struct Monitor{
        let MAX_FAILURE_PERMITTED = 5
        let HTTP_STRING = "https://"
        
 
        @State var isMonitoring: Bool = false
        @State var serverState: Status
        
        var hostname: String = ""
        var ipAddress: String = ""
        var checkFrequency: Double = 5
        
        
        
        
        init(hostname: String, ipAddress: String, checkFrequency: Int, serverState: Status){
            self.hostname = hostname
            self.ipAddress = ipAddress
            self.checkFrequency = Double(checkFrequency)
            self.serverState = serverState
            }
        
        init(serverState: Status){
            self.serverState = serverState
        }
        
        func monitoringHost(){
            isMonitoring = true
            var failureCounter = 0
            Timer.scheduledTimer(withTimeInterval: checkFrequency, repeats: true){ [self] timer in
                
                if !isHostReachable(){
                    failureCounter += 1
                    NSLog("\(failureCounter) It has to increase")
                }
                if failureCounter >= 5 {
                    timer.invalidate()
                    isMonitoring = false
                    NSLog("THE MONITORING HAS BEEN STOPED")
                
                
             }
           
         }

      }
        
         func isHostReachable()-> Bool{
                self.serverState = self.sendHTTPRequest()
                
                if  serverState != Status.reachable {
                    return false
                }
                 return true
                
            }
          
        
    
        
      func sendHTTPRequest()-> Status{
            let hostUrl: String = HTTP_STRING + self.hostname
          var serverState : Status = .unknown
            
            if let url = URL(string: hostUrl){
                var request = URLRequest(url: url)
                request.httpMethod = "HEAD"
                URLSession(configuration: .default)
                    .dataTask(with: request){(_, response, error) -> Void in
                        guard error == nil else{
                            NSLog("ERROR trying to reach server \(hostname)")
                            serverState = .unknown
                            return
                        }
                        guard (response as? HTTPURLResponse)?
                            .statusCode == 200 else {
                            serverState = .unreachable
                            NSLog("The server \(hostname) is down")
                            
                            return
                    }
                        NSLog("The server \(hostname) is ok")
                        serverState = .reachable
        
                    }
                    .resume()
            }
          return serverState
        }
    }

extension Host{

    var monitor: Monitor{
        Monitor(hostname: hostname, ipAddress: hostname, checkFrequency: checkFrequency, serverState: status)
        }
    
    }
