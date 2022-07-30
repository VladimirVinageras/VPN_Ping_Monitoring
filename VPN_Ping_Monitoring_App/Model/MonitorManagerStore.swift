//
//  MonitorManagerStore.swift
//  VPN_Ping_Monitoring_App
//
//  Created by Vladimir Vinageras on 20.07.2022.
//

import SwiftUI
import Foundation


class MonitorManagerStore: ObservableObject{
    @Published var monitorManagers : [MonitorManager] = []

    func refresh() async throws -> (){
        try await monitorManagers.forEach { monitorManager in
        monitorManager.refresh()
      }
    }

    private static func fileURL() throws -> URL{
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("monitorManagers.data")
    }
  
    
    static func load() async throws -> [MonitorManager]{
        try await withCheckedThrowingContinuation{ continuation in
            load{result in
                switch result{
                case .failure(let error):
                    continuation.resume(throwing: error)
                
                case .success(let monitorManagers):
                    continuation.resume(returning: monitorManagers)
                }
            }
            
        }
    }
    
    
    
    static func load(completion: @escaping(Result<[MonitorManager], Error>) -> Void){
        DispatchQueue.global(qos: .background).async{
            do{
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else{
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let monitorManagers = try JSONDecoder().decode([MonitorManager].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(monitorManagers))
                }
                
            }catch{
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    
    @discardableResult
    static func save(monitorManagers: [MonitorManager]) async throws -> Int{
        try await withCheckedThrowingContinuation{ continuation in
            save(monitorManagers: monitorManagers){ result in
                switch result{
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let monitorManagerSaved):
                    continuation.resume(returning: monitorManagerSaved)
                }
                
            }
            
        }
    }
    
    
    static func save(monitorManagers: [MonitorManager], completion: @escaping(Result<Int, Error>)-> Void){
        DispatchQueue.global(qos: .background).async{
            do{
                let data = try JSONEncoder().encode(monitorManagers)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(monitorManagers.count))
                }
                
            }catch{
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}

