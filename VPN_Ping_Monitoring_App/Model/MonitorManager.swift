//
//  MonitorManager.swift
//  VPN_Ping_Monitoring_App
//
//  Created by Vladimir Vinageras on 28.07.2022.
//

import SwiftUI

class MonitorManager: Identifiable, Codable, ObservableObject{

    var MAX_FAILURE_PERMITTED = 5
    var HTTP_STRING = "https://"
    
    var id: UUID
   @Published var host: Host
   // var monitor: Monitor
   @Published var checkFrequency: Int = 5
   @Published var hostStatusMessage: String = ""

    init(id: UUID = UUID()){
        self.id = id
        host = Host.sampleData[0]
     //   monitor = Monitor.sampleMonitor
    }

    func monitoringHost(){
        var failureCounter = 0
        Timer.scheduledTimer(withTimeInterval: TimeInterval(checkFrequency), repeats: true){ [self] timer in
            if !isHostReachable(){
                failureCounter += 1
                NSLog("\(failureCounter) It has to increase")
            } else{
            
            }
            if failureCounter >= MAX_FAILURE_PERMITTED {
                timer.invalidate()
                
                NSLog("THE MONITORING HAS BEEN STOPED")
            }
            
        }
    }
    
    func isHostReachable()-> Bool{
           
           if  self.sendHTTPRequest() != Status.reachable {
               return false
           }
            return true
           
       }
    
    func sendHTTPRequest()-> Status{
        let hostUrl: String = HTTP_STRING + self.host.hostname
             var serverStatus : Status = .unknown
               
               if let url = URL(string: hostUrl){
                   var request = URLRequest(url: url)
                   request.httpMethod = "HEAD"
                   URLSession(configuration: .default)
                       .dataTask(with: request){ [self](_, response, error) -> Void in
                           guard error == nil else{
                               NSLog("ERROR trying to reach server \(host.hostname)")
                               serverStatus = .unknown
                               return
                           }
                           guard (response as? HTTPURLResponse)?
                               .statusCode == 200 else {
                               serverStatus = .unreachable
                               NSLog("The server \(host.hostname) is down")
                               
                               return
                       }
                           NSLog("The server \(host.hostname) is ok")
                           serverStatus = .reachable
           
                       }
                       .resume()
               }
             hostStatusMessage = serverStatus.Status()
             return serverStatus
           }
    
    init(data: ManagerData){
        id = UUID()
        host = data.host
     //   monitor = data.monitor
        checkFrequency = data.checkFrequency
    }
    
    
    
    enum CodingKeys: String, CodingKey {
        case hostId
        case id
        case name
        case hostname
        case ipAddress
        case checkFrecuency
        case hostStatusMessage
      }
    
    
    
      required init(from decoder: Decoder) throws {
         
        let values = try decoder.container(keyedBy: CodingKeys.self)
           id = try values.decode(UUID.self, forKey: .id)
          let hostId = try values.decode(UUID.self, forKey: .id)
          let name = try values.decode(String.self, forKey: .name)
          let hostname = try values.decode(String.self, forKey: .hostname)
          let ipAddress = try values.decode(String.self, forKey: .ipAddress)
        checkFrequency = try values.decode(Int.self, forKey: .checkFrecuency)
        hostStatusMessage = try values.decode(String.self, forKey: .hostStatusMessage)
          host  = Host(id: hostId,name: name, hostname: hostname, ipAddress: ipAddress)
      }

    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(host.id, forKey: .hostId)
        try container.encode(host.name, forKey: .name)
        try container.encode(host.hostname, forKey: .hostname)
        try container.encode(host.ipAddress, forKey: .ipAddress)
        try container.encode(id, forKey: .id)
        try container.encode(checkFrequency, forKey: .checkFrecuency)
        try container.encode(hostStatusMessage, forKey: .hostStatusMessage)
      }

    
}



extension MonitorManager{
    struct ManagerData{
        var host: Host = Host.sampleData[0]
     //   var monitor: Monitor = Monitor.sampleMonitor
        var checkFrequency: Int = 5
        
    }
    
    
    var data: ManagerData{
        ManagerData(host: host, /*monitor: monitor,*/ checkFrequency: checkFrequency)
    }
    
    func update(from data: ManagerData){
        host = data.host
     //   monitor = data.monitor
        checkFrequency = data.checkFrequency
    }
    
}
    
    
extension MonitorManager{
    
    static let sampleMonitorManager : MonitorManager = MonitorManager()


}






