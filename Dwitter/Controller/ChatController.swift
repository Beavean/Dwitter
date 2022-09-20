//
//  ChatController.swift
//  Dwitter
//
//  Created by Beavean on 19.09.2022.
//

import UIKit

class ChatController: UICollectionViewController {
    
    //MARK: - Properties
    
    private let user: User
    private var messages = [Message]()
    
    private lazy var customInputView: CustomInputView = {
        let inputView = CustomInputView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        return inputView
    }()
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override var inputAccessoryView: UIView? {
        get { return customInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    //MARK: - Selectors
    
    
    
    //MARK: - Helpers
    
    func configureUI() {
        navigationItem.title = user.username
    }
}

//MARK: - UICollectionViewDataSource

extension ChatController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.messageCellReuseId, for: indexPath) as! MessageCell
        cell.message = messages[indexPath.row]
        cell.message?.user = user
        return cell
    }
}
