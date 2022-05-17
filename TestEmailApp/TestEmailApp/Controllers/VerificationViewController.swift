//
//  VerificationViewController.swift
//  TestEmailApp
//
//  Created by Михаил Фролов on 10.05.2022.
//

import UIKit

class VerificationViewController: UIViewController {
    @IBOutlet weak var informationTextLabel: UILabel!
    @IBOutlet weak var verificationButton: UIButton!
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let collectionView = MailCollectionView(frame: .zero,
                                                    collectionViewLayout: UICollectionViewFlowLayout())

    private let mailTextField = MailTextField()
    private let verificationModel = VerificationModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setDelegates()
        setConstraints()
        

        
    }
    
    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        view.addSubview(collectionView)
        view.addSubview(mailTextField)
        
        verificationButton.layer.cornerRadius = 8
        verificationButton.isEnabled = false
        verificationButton.alpha = 0.5
    }
    
    private func setDelegates() {
        collectionView.dataSource = self
        collectionView.selectMailDelegate = self
        mailTextField.textFieldDelegate = self
    }
    
    @IBAction func VerificationButtonDidPressed(_ sender: Any) {
        
    }
    
}

//MARK: - SelectProposedMailProtocol

extension VerificationViewController: SelectProposedMailProtocol {
    func selectProposedMail(indexPath: IndexPath) {
        print(indexPath)
    }
}

//MARK: - ActionsMailTextFieldProtocol

extension VerificationViewController: ActionsMailTextFieldProtocol {
    func typingText(text: String) {
        print(text)
    }
    
    func cleanOutTextField() {
        print("clear")
    }
    
}

//MARK: - UICollectionViewDataSource

extension VerificationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        verificationModel.filtredMailArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IdCell.idMailCell.rawValue, for: indexPath) as? MailCollectionViewCell
        else { return UICollectionViewCell() }
        return cell
    }
}

//MARK: - SetConstraints

extension VerificationViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: verificationButton.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        NSLayoutConstraint.activate([
            mailTextField.topAnchor.constraint(equalTo: informationTextLabel.bottomAnchor, constant: 10),
            mailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            mailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            mailTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension UITextField {
    func indent(size:CGFloat) {
        self.leftView = UIView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: size, height: self.frame.height))
        self.leftViewMode = .always
    }
}
