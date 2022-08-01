//
//  MonitorManager.swift
//  VPN_Ping_Monitoring_App
//
//  Created by Vladimir Vinageras on 28.07.2022.
//

import SwiftUI

class MonitorManager: Identifiable, Codable,     ObservableObject{

    var MAX_FAILURE_PERMITTED = 5
    var HTTP_STRING = "https://"
    
    var id: UUID
   @Published var host: Host
 
    @Published var checkFrequency: Int = 5
    @Published var hostStatusMessage: String = ""
    var isMonitoring: Bool = false
    private var hostStatus: Status = .reachable
    private var failureCounter: Int = 0
    private var counter: Int = 0  // Visualize the number of checks made
        
    init(id: UUID = UUID()){
        self.id = id
        host = Host.sampleData[0]
    }

    func monitoringHost(){
        if (isMonitoring == false){
            hostStatus = checkingHostStatus()
        guard hostStatus == .reachable else {return}
           failureCounter = 0
           isMonitoring = true
        
        Timer.scheduledTimer(withTimeInterval: TimeInterval(checkFrequency), repeats: true){ [self] timer in
            hostStatus = checkingHostStatus()
            if hostStatus != Status.reachable{
                failureCounter += 1
                NSLog("\(failureCounter) It has to increase in failure")  //Visualize in log the number of failures
            } else {
                failureCounter = 0
            }
            if failureCounter >= MAX_FAILURE_PERMITTED {
                timer.invalidate()
                isMonitoring = false
                NSLog("THE MONITORING HAS BEEN STOPED")
            }
            hostStatusMessage = hostStatus.Status()
        }
      }
    }
    
    func checkingHostStatus()-> Status{
            return sendHTTPRequest()
       }
    
    func sendHTTPRequest()-> Status{
        let hostUrl: String = HTTP_STRING + self.host.hostname
       
               
               if let url = URL(string: hostUrl){
                   var request = URLRequest(url: url)
                   request.httpMethod = "HEAD"
                   URLSession(configuration: .default)
                       .dataTask(with: request){ [self](_, response, error) -> Void in
                           guard error == nil else{
                               NSLog("ERROR trying to reach server \(host.hostname)")   // Visualize the server status
                               hostStatus = .unknown
                               return
                           }
                           guard (response as? HTTPURLResponse)?
                               .statusCode == 200 else {
                               hostStatus = .unreachable
                               NSLog("The server \(host.hostname) is down")    // Visualize the server status. The app send a request but the server is not OK 
                               return
                       }
                           NSLog("The server \(host.hostname) is ok")
                           NSLog("The server \(host.hostname) has been checked \(counter) times ")
                           counter += 1
                           hostStatus = .reachable
           
                       }
                       .resume()
               }
             hostStatusMessage = hostStatus.Status()
             return hostStatus
           }
    
    
    func refresh(){
        failureCounter = 0
        monitoringHost()
        }
    

    
    init(data: ManagerData){
        id = UUID()
        host = data.host
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
        var checkFrequency: Int = 5
        
    }
    
    
    var data: ManagerData{
        ManagerData(host: host, checkFrequency: checkFrequency)
    }
    
    func update(from data: ManagerData){
        host = data.host
        checkFrequency = data.checkFrequency
    }
    
}
    
    
extension MonitorManager{
    
    static let sampleMonitorManager : MonitorManager = MonitorManager()


}






