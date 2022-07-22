//
//  PingController.swift
//  VPN_Ping_Monitor
//
//  Created by Vladimir Vinageras on 23.06.2022.
//

import Foundation


class PingMonitor: NSObject, SimplePingDelegate{
    
    let hostname: String
    let ipAddress: String
    let timeInterval = 1
    var pinger: SimplePing?
    var sendTimer: Timer?
    
    init(hostname: String, ipAddress: String){
        self.ipAddress = ipAddress
        self.hostname = hostname
    }
    
    
    func start(forceIPv4: Bool, forceIPv6:Bool){

        NSLog("Start")
        
        let pinger = SimplePing(hostName: self.hostname)
        self.pinger = pinger
        
        
        
        if(forceIPv4 && !forceIPv6){
            pinger.addressStyle = .icmPv4
        }else if (forceIPv6 && !forceIPv4){
            pinger.addressStyle = .icmPv6
        }
        pinger.delegate = self
        pinger.start()
        self.simplePing(pinger: pinger, didStartWithAddress: Data(self.ipAddress.utf8) as NSData)
        pinger.send(with: nil)
    }
    

    func stop(){
        NSLog("Stop")
        self.pinger?.stop()
        self.pinger = nil
        self.sendTimer?.invalidate()
        self.sendTimer = nil
    
        self.pingerDidStop()
        
    }
        
    @objc func sendPing(){
        self.pinger?.send(with: nil)
        }
        
    private func simplePing(pinger: SimplePing, didStartWithAddress address: NSData){
        let ipAddressData = Data(ipAddress.utf8) as NSData
        NSLog("pinging $@", PingMonitor.displayAddressForAddress(address: ipAddressData))
        self.sendPing()

        assert(self.sendTimer == nil)
        self.sendTimer = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector: #selector(PingMonitor.sendPing), userInfo: nil, repeats: true)
    }
    
    private func simplePing(pinger:SimplePing, didFailWithError error: NSError){
        NSLog("Failed: $@", self.shortErrorFromError(error: error))
        self.stop()
    }
    
    private func simplePing(pinger: SimplePing, didSendPacket packet: NSData, sequenceNumber: UInt16){
        NSLog("#%u sent", sequenceNumber)
    }
    
    private func simplePing(pinger: SimplePing, didFailToSendPacket packet: NSData, sequenceNumber: UInt16, error: Error){
        NSLog("#$u send failed: $@", sequenceNumber, self.shortErrorFromError(error: error as NSError))
    }
    
    private func simplePing(pinger: SimplePing, didReceivePingResponsePacket packet: NSData, sequenceNumber: UInt16){
        NSLog("#$u received, size = $zu",sequenceNumber, packet.length)
    }
    
    private func simplePing(pinger: SimplePing, didReceiveUnexpectedPacket packet: NSData){
        NSLog("unexpected packet, size=$zu", packet.length)
    }
    
    
    
    static func displayAddressForAddress(address: NSData) -> String{
        var hostStr = [Int8](repeating: 0, count: Int(NI_MAXHOST))
        
        let sockAddr: UnsafePointer<sockaddr> = (address.bytes).assumingMemoryBound(to: sockaddr.self)
        
        let success = getnameinfo(sockAddr, socklen_t(address.length), &hostStr, socklen_t(hostStr.count), nil, 0, NI_NUMERICHOST) == 0
        
        let result: String
        
        if success{
            result = String(cString: hostStr)
            print(result)
        } else {
            result = "?"
        }
        return result
    }
    
    
    private func shortErrorFromError(error: NSError) -> String{
        if error.domain == kCFErrorDomainCFNetwork as String && error.code == Int(CFNetworkErrors.cfHostErrorUnknown.rawValue){
            if let failureObj = error.userInfo[kCFGetAddrInfoFailureKey as String]{
                if let failureNum = failureObj as? NSNumber {
                    if failureNum.intValue != 0 {
                        let fail = gai_strerror(Int32(failureNum.intValue))
                        if fail != nil {
                            let result = String(cString: fail!)
                            return result
                    }
                }
            }
        }
        if let result = error.localizedFailureReason{
            return result
        }
    }
        return error.localizedFailureReason ?? ""
    }
    
    func pingerWillStart(){}
    
    
    func pingerDidStop(){}
}

