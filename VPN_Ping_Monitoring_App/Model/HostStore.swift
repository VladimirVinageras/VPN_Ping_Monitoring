//
//  HostStore.swift
//  VPN_Ping_Monitoring_App
//
//  Created by Vladimir Vinageras on 20.07.2022.
//

import SwiftUI
import Foundation


class HostStore: ObservableObject{
    @Published var hosts : [Host] = []
    
    private static func fileURL() throws -> URL{
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("hosts.data")
    }
  
    
    static func load() async throws -> [Host]{
        try await withCheckedThrowingContinuation{ continuation in
            load{result in
                switch result{
                case .failure(let error):
                    continuation.resume(throwing: error)
                
                case .success(let hosts):
                    continuation.resume(returning: hosts)
                }
            }
            
        }
    }
    
    
    static func load(completion: @escaping(Result<[Host], Error>) -> Void){
        DispatchQueue.global(qos: .background).async{
            do{
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else{
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let hosts = try JSONDecoder().decode([Host].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(hosts))
                }
                
            }catch{
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    
    @discardableResult
    static func save(hosts: [Host]) async throws -> Int{
        try await withCheckedThrowingContinuation{ continuation in
            save(hosts: hosts){ result in
                switch result{
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let hostSaved):
                    continuation.resume(returning: hostSaved)
                }
                
            }
            
        }
    }
    
    
    static func save(hosts: [Host], completion: @escaping(Result<Int, Error>)-> Void){
        DispatchQueue.global(qos: .background).async{
            do{
                let data = try JSONEncoder().encode(hosts)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(hosts.count))
                }
                
            }catch{
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
