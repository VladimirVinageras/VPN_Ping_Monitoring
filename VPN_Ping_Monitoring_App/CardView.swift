//
//  CardView.swift
//  VPN_Ping_Monitoring_App
//
//  Created by Vladimir Vinageras on 19.07.2022.
//

import SwiftUI

struct CardView: View {
    
    @ObservedObject var notificationManager = LocalNotificationManager()
    @ObservedObject var monitorManager: MonitorManager
    @State private var errorWrapper: ErrorWrapper?
    
    @Environment (\.scenePhase) private var scenePhase
    
        var body: some View {
        
        VStack{
            VStack(alignment: .leading){
                Text(monitorManager.host.name)
                    .font(.headline)
            }
            Spacer()
            VStack(alignment: .leading){
                HStack(alignment: .center){
                    Label("\(monitorManager.host.hostname)", systemImage: "network")
                    Spacer()
                HStack(alignment: .center){
                    Label ("Monitoring: \(String(monitorManager.isMonitoring)) " ,systemImage: "gearshape.2")
                        .font(.caption)
                    }
                }
                Spacer()
                HStack{
                    Label("\(monitorManager.host.ipAddress)", systemImage: "server.rack")
                }
                Spacer()
                HStack{
                    Label(" \(monitorManager.checkFrequency) seconds.", systemImage: "clock.arrow.2.circlepath")
                        .font(.caption)
                Spacer()
                
                    Label("The connection is  \(monitorManager.hostStatusMessage)",systemImage: "app.connected.to.app.below.fill")
                    .font(.caption)
                }
            }
        }
        .onAppear(){
            monitorManager.monitoringHost()
        }
    }
        
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(monitorManager: MonitorManager.sampleMonitorManager)
            .previewLayout(.sizeThatFits)
    }
 }


private extension CardView{

    var monitoringNotificationAction: () {
        if  !monitorManager.isMonitoring{
         self.notificationManager.sendNotification(title: "Host status has changed", subtitle: nil, body: "Host is not reachable. Check your Internet conection or check the aplication for more details", launchIn:2)
     }
    }
    }



  



 
