//
//  ChatViewController.swift
//  YouChat
//
//  Created by Hell on 08/01/2022.
//

import UIKit
import MessageKit

struct Message:MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Sender:SenderType {
    var photoURL:String
    var senderId: String
    var displayName: String
}



class ChatViewController: MessagesViewController {
    
    var messages : [Message] = []
    
    var selfSender = Sender(photoURL: "", senderId: "1", displayName: "Me")

    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
    }
}


extension ChatViewController:MessagesDataSource,MessagesLayoutDelegate,MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
    
    
}
