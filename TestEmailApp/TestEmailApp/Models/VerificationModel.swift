//
//  VerificationModel.swift
//  TestEmailApp
//
//  Created by Михаил Фролов on 17.05.2022.
//

import Foundation

class VerificationModel {
    private let mailsArray = ["@gmail.com", "@yahoo.com", "@yahoo.ua", "@yandex.com", "@yandex.ua"]
    
    public var nameMail = String()
    public var filtredMailArray = [String]()
    
    private func filtringMails(text: String) {
        var domainMail = String()
        filtredMailArray = []
        
        guard let firstIndex = text.firstIndex(of: "@") else { return }
        let endIndex = text.index(before: text.endIndex)
        let range = text[firstIndex...endIndex]
        domainMail = String(range)
        
        mailsArray.forEach { mail in
            if mail.contains(domainMail) {
                if !filtredMailArray.contains(mail) {
                    filtredMailArray.append(mail)
                }
            }
        }
    }
    
    public func deriveNameMail(text: String) {
        guard let atSimbolIndex = text.firstIndex(of: "@") else { return }
        let endIndex = text.index(before: atSimbolIndex)
        let firstIndex = text.startIndex
        let range = text[firstIndex...endIndex]
        nameMail = String(range)
    }
    
    public func getFiltredMail(text: String) {
        filtringMails(text: text)
    }
    
    public func getMailName(text: String) {
        deriveNameMail(text: text)
    }
}
