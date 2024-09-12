//
//  ChannelsListViews.swift
//  DemoAssignment
//
//  Created by IA on 08/09/24.
//

import UIKit
//
// MARK: - ChannelsListCell
//
class ChannelsListCell: UICollectionViewCell {
    
    //
    // MARK: - assign / update data here
    //
    var channels: Channels? {
        didSet { // property observer
            titleLabel.text = channels?.name
        }
    }
    
    //
    // MARK: - create UI
    //
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: FontSize.small)
        return label
    }()
    
    //
    // MARK: - init
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        addSubview(titleLabel)
        
        // MARK: - setup autoLayout
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Spacing.viewMarginMedium).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Spacing.viewMarginSmall).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Spacing.viewMarginSmall).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Spacing.viewMarginSmall).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
// MARK: - ChannelsListHeader
//
class ChannelsListHeader: UICollectionReusableView {
    
    //
    // MARK: - assign / update data here
    //
    var setterObj: String? {
        didSet { // property observer
            titleLabel.text = setterObj
        }
    }
    
    //
    // MARK: - create UI
    //
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: FontSize.medium, weight: .bold)
        return label
    }()
    
    //
    // MARK: - init
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        backgroundColor = .coolBackground
        addSubview(titleLabel)
        
        // MARK: - setup autoLayout
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Spacing.viewMarginSmall).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Spacing.viewMarginSmall).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Spacing.viewMarginSmall).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Spacing.viewMarginSmall).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
