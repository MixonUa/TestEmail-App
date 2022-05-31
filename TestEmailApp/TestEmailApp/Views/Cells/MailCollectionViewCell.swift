//
//  MailCollectionViewCell.swift
//  TestEmailApp
//
//  Created by Михаил Фролов on 13.05.2022.
//

import Foundation
import UIKit

class MailCollectionViewCell: UICollectionViewCell {
    private let domainLable: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = .white
        contentView.alpha = 0.5
        contentView.layer.cornerRadius = 10
        //меняем именно у ContentView а не просто у ячейки
        
        addSubview(domainLable)
    }
    
    private func configure(mailLabelText: String) {
        domainLable.text = mailLabelText
    }
    
    public func cellConfigure(mailLableText: String) {
        configure(mailLabelText: mailLableText)
    }
}

extension MailCollectionViewCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            domainLable.centerXAnchor.constraint(equalTo: centerXAnchor),
            domainLable.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
