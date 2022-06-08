//
//  NetworkDataFetch.swift
//  TestEmailApp
//
//  Created by Михаил Фролов on 30.05.2022.
//

import Foundation

class NetworkDataFetch {
    let networkManager: NetworkManager
    
    init(networkManager:NetworkManager = NetworkManager()){
        self.networkManager = networkManager
    }
    
    func fetchMail(verifiableMail: String, response: @escaping(MailResponseModel?, Error?) -> Void) {
        networkManager.requestData(verifiableMail: verifiableMail) { result in
            switch result {
            case .success(let data):
                do {
                    let mail = try JSONDecoder().decode(MailResponseModel.self, from: data)
                    response(mail, nil)
                } catch let jsonError {
                    print("Failed to decode", jsonError)
                }
            case .failure(let error):
                print("Error recieved requesting data: \(error.localizedDescription)")
                response(nil, error)
            }
        }
    }
}
