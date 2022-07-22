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
        var pingMonitor: PingMonitor
        private var failureCounter: Int = 0
        private var isServeReachable: Bool = false
        private var isMonitoring: Bool = false 

        var hostname: String = ""
        var ipAddress: String = ""
        var checkFrequency: Double = 5
        var status: Status = .unreachable
        
        
        init(hostname: String, ipAddress: String, checkFrequency: Int, status: Status){
            self.ipAddress = ipAddress
            self.checkFrequency = Double(checkFrequency)
            self.status = status
            self.pingMonitor = PingMonitor(hostname: self.hostname, ipAddress: self.ipAddress)
            }
        
        func makePing(){ // TODO organizar las funciones y poner este codigo en su lugar 
            Timer.scheduledTimer(withTimeInterval: checkFrequency, repeats: true){timer in
              //  if pingMonitor == nil{
               
                    pingMonitor.start(forceIPv4: true, forceIPv6: false)
                    
                
                if failureCounter >= 5 {
                    timer.invalidate()
                }
            }
        }
        
        func Start(){
            pingMonitor.start(forceIPv4: true, forceIPv6: false)
        }
        
        func Stop(){
            //change
        }
        
       
}
    func StartMonitoring(){
        let monitor: Monitor = Monitor(hostname: self.hostname, ipAddress: self.ipAddress, checkFrequency: self.checkFrequency, status: self.status)
        monitor.makePing()
    }
    
    func StopMonitoring(){
        
    }
    
    
    
    mutating func update(from monitor: Monitor){
        
            status = monitor.status
        }

}
