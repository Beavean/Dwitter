//
//  ProfileFilterView.swift
//  Dwitter
//
//  Created by Beavean on 09.09.2022.
//

import UIKit

protocol ProfileFilterViewDelegate: AnyObject {
    func filterView(_ view: ProfileFilterView, didSelect index: Int)
}

class ProfileFilterView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: ProfileFilterViewDelegate?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBlue
        return view
    }()
    
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(ProfileFilterCell.self, forCellWithReuseIdentifier: Constants.profileFilterCellReuseIdentifier)
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
    }
    
    override func layoutSubviews() {
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width / 3, height: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    
}

//MARK: - UICollectionViewDataSource + Delegate

extension ProfileFilterView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.profileFilterCellReuseIdentifier, for: indexPath) as? ProfileFilterCell else { return UICollectionViewCell() }
        let option = ProfileFilterOptions(rawValue: indexPath.row)
        cell.option = option
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileFilterOptions.allCases.count
    }
}

//MARK: - UICollectionViewDelegate

extension ProfileFilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let xPosition = cell?.frame.origin.x ?? 0
        UIView.animate(withDuration: 0.1, delay: 0) {
            self.underlineView.frame.origin.x = xPosition
        }
        delegate?.filterView(self, didSelect: indexPath.row)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProfileFilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = CGFloat(ProfileFilterOptions.allCases.count)
        return CGSize(width: frame.width / count, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


