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
    
    let netwokrManager = NetworkDataFetch()
    
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
    
    public func setDefaultLayerSettings() {
        informationTextLabel.text = "Check your mail"
        informationTextLabel.textColor = .black
    }
    
    public func setDefaultButtonSettings() {
        verificationButton.layer.cornerRadius = 8
        verificationButton.isEnabled = false
        verificationButton.alpha = 0.5
    }
    
    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        view.addSubview(collectionView)
        view.addSubview(mailTextField)
        setDefaultLayerSettings()
        setDefaultButtonSettings()
    }
    
    private func setDelegates() {
        collectionView.dataSource = self
        collectionView.selectMailDelegate = self
        mailTextField.textFieldDelegate = self
    }
    
    private func mailValidation(text: Bool) {
        if text {
            informationTextLabel.text = "Mail is valid"
            informationTextLabel.textColor = .green
            verificationButton.isEnabled = true
            verificationButton.alpha = 1
        } else {
            informationTextLabel.text = "Mail is not valid. Example: name@domain.ua"
            informationTextLabel.textColor = .red
            verificationButton.isEnabled = false
            verificationButton.alpha = 0.5
        }
    }
    
    @IBAction func VerificationButtonDidPressed(_ sender: Any) {
        guard let mail = mailTextField.text else { return }
        netwokrManager.fetchMail(verifiableMail: mail) { (result, error) in
            if error == nil {
                guard let result = result else { return }
                if result.success {
                    guard let didYouMeanError = result.did_you_mean else {
                        Alert.showResultAlert(vc: self, message: "Mail status \(result.result) \n \(result.reasonDescription)")
                        return
                    }
                    Alert.showErrorAlert(vc: self, message: "Did you mean \(didYouMeanError)") { [weak self] in
                        guard let self = self else { return }
                        self.mailTextField.text = didYouMeanError
                    }
                } else {
                    guard let errorDiscription = error?.localizedDescription else { return }
                    Alert.showResultAlert(vc: self, message: errorDiscription)
                }
            }
        }
    }
}

//MARK: - SelectProposedMailProtocol

extension VerificationViewController: SelectProposedMailProtocol {
    func selectProposedMail(indexPath: IndexPath) {
        guard let text = mailTextField.text else { return }
        verificationModel.getMailName(text: text)
        let domainMail = verificationModel.filtredMailArray[indexPath.row]
        let mailFullName = verificationModel.nameMail + domainMail
        mailTextField.text = mailFullName
        mailValidation(text: mailFullName.isValid())
        verificationModel.filtredMailArray = []
        collectionView.reloadData()
    }
}

//MARK: - ActionsMailTextFieldProtocol

extension VerificationViewController: ActionsMailTextFieldProtocol {
    func typingText(text: String) {
        mailValidation(text: text.isValid())
        
        verificationModel.getFiltredMail(text: text)
        collectionView.reloadData()
    }
    
    func cleanOutTextField() {
        setDefaultLayerSettings()
        setDefaultButtonSettings()
        verificationModel.filtredMailArray = []
        collectionView.reloadData()
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
        
        let mailLableText = verificationModel.filtredMailArray[indexPath.row]
        cell.cellConfigure(mailLableText: mailLableText)
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
