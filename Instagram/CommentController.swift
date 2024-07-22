//
//  CommentController.swift
//  Instagram
//
//  Created by WEBSYSTEM-MAC41 on 2024/07/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class CommentController: UIViewController {
    
    @IBOutlet weak var commentTextField: UITextField!
    
    var postData: PostData? // 投稿データを受け取るためのプロパティ

    override func viewDidLoad() {
        super.viewDidLoad()
        // 画面タップでキーボードを閉じる設定
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func addComment(to postData: PostData, comment: String, name: String) {
        let commentData: [String: Any] = [
            "comment": comment,
            "name": name
        ]
        
        // 保存先のドキュメント参照
        let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
        
        // コメントデータを追加する
        postRef.updateData([
            "comments": FieldValue.arrayUnion([commentData])
        ]) { error in
            if let error = error {
                print("Error adding comment: \(error)")
            } else {
                print("Comment added successfully")
            }
        }
    }
    
    @IBAction func postComment(_ sender: Any) {
        guard let commentText = commentTextField.text, !commentText.isEmpty else {
            // コメントが空の場合の処理
            return
        }
        
        guard let postData = postData else {
            return
        }
        
        // 現在のユーザーの名前を取得
        if let userName = Auth.auth().currentUser?.displayName {
            // Firestoreにコメントを追加する処理
            addComment(to: postData, comment: commentText, name: userName)
            self.dismiss(animated: true, completion: nil) // モーダルを閉じる
        }
    }
    
    @IBAction func caoncel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil) // モーダルを閉じる
    }
    
}
