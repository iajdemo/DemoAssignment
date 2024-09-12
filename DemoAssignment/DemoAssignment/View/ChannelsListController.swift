//
//  ChannelsListController.swift
//  DemoAssignment
//
//  Created by IA on 08/09/24.
//

import UIKit

class ChannelsListController: UIViewController {
    
    // MARK: - setup variables
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    var channelsListArray: [Channels]?
    private var sections: [Section] = []
    private let listCollectionViewCellID: String = "listCollectionViewCellID"
    private let listCollectionViewHeaderID: String = "listCollectionViewHeaderID"
    private let channelListResource = ChannelsListResource()
    
    //
    // MARK: - create UI
    //
    lazy var listCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.register(ChannelsListCell.self, forCellWithReuseIdentifier: self.listCollectionViewCellID)
        cv.register(ChannelsListHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: listCollectionViewHeaderID)
        return cv
    }()
    
    lazy var signOutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .primaryDark
        button.setTitle(StringConstants.signOut, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(handleSignOutButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSignOutButton(_ sender: UIButton) {
        
        let signOutAlert = UIAlertController(title: StringConstants.signOutConfirmation, message: nil, preferredStyle: .alert)
        
        signOutAlert.addAction(UIAlertAction(title: StringConstants.yes, style: .default, handler: { action in
            self.doSignOut()
        }))
        
        signOutAlert.addAction(UIAlertAction(title: StringConstants.no, style: .default, handler: { action in
            signOutAlert.dismiss(animated: true, completion: nil)
        }))
        
        present(signOutAlert, animated: true, completion: nil)
    }
    
    func doSignOut() {
        userDefaults.set(false, forKey: "isLoggedIn")
        userDefaults.synchronize()
        let success = KeychainService.delete(forKey: "keyToken")
        if success {
            print("Token deleted successfully")
        } else {
            print("Failed to delete token")
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    //
    // MARK: - viewDidLoad
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    func setupData() {
        let isLoggedIn = userDefaults.bool(forKey: "isLoggedIn")
        let token = retrieveToken()
        if isLoggedIn,
           !token.isEmpty {
            Task {
                await getChannelsListData(token)
                reloadCollectionView()
            }
        } else {
            if let unwrappedArray = channelsListArray,
               !unwrappedArray.isEmpty {
                handleData(unwrappedArray: unwrappedArray)
            } else {
                handleEmptyData(title: StringConstants.noDataFound)
            }
            reloadCollectionView()
        }
    }
    
    func getChannelsListData(_ token: String) async {
        do {
            startLoading()
            self.channelsListArray = try await channelListResource.getChannelsList(token: token)
            if let unwrappedArray = channelsListArray,
               !unwrappedArray.isEmpty {
                handleData(unwrappedArray: unwrappedArray)
            } else {
                handleEmptyData(title: StringConstants.noDataFound)
            }
        } catch let error {
            handleEmptyData(title: error.localizedDescription)
        }
    }
    
    func handleData(unwrappedArray: [Channels]) {
        let groupFolderName = Dictionary(grouping: unwrappedArray, by: { $0.group_folder_name })
        sections = groupFolderName.map { Section(title: $0.key ?? "", channels: $0.value) }
    }
    
    func handleEmptyData(title: String) {
        sections.removeAll()
        stopLoading()
        showAlert(title: title, message: StringConstants.pleaseRetryLater)
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.stopLoading()
            self.listCollectionView.reloadData()
        }
    }
    
    func retrieveToken() -> String {
        let keyToken = "keyToken"
        if let retrievedData = KeychainService.retrieve(forKey: keyToken),
           let retrievedToken = String(data: retrievedData, encoding: .utf8) {
            //            print("retrievedToken: \(retrievedToken)")
            return retrievedToken
        } else {
            showAlert(title: StringConstants.somethingWentWrong, message: StringConstants.failedTokenRetrieve)
            return ""
        }
    }
}
//
// MARK: - UICollectionViewDataSource methods
//
extension ChannelsListController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].channels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listCollectionViewCellID, for: indexPath) as? ChannelsListCell else { return UICollectionViewCell() }
        cell.channels = sections[indexPath.section].channels[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: listCollectionViewHeaderID, for: indexPath) as? ChannelsListHeader else { return UICollectionReusableView() }
        header.setterObj = sections[indexPath.section].title
        return header
    }
}
//
// MARK: - UICollectionViewDelegateFlowLayout methods
//
extension ChannelsListController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
}
//
// MARK: - handle loading
//
extension ChannelsListController {
    
    func startLoading() {
        activityIndicator.startAnimating(in: view)
        view.isUserInteractionEnabled = false
    }
    
    func stopLoading() {
        activityIndicator.stopAnimatingIndicator()
        view.isUserInteractionEnabled = true
    }
}
//
// MARK: - setupUI
//
extension ChannelsListController {
    
    func setupUI() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        view.addSubview(signOutButton)
        view.addSubview(listCollectionView)
        
        // MARK: - setup autoLayout
        signOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.viewMarginMedium).isActive = true
        signOutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Spacing.viewMarginMedium).isActive = true
        signOutButton.widthAnchor.constraint(equalToConstant: RegularButtonSize.width).isActive = true
        signOutButton.heightAnchor.constraint(equalToConstant: RegularButtonSize.height).isActive = true
        
        listCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        listCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        listCollectionView.topAnchor.constraint(equalTo: signOutButton.bottomAnchor, constant: Spacing.viewMarginMedium).isActive = true
        listCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
