//
//  ViewController.swift
//  FireBaseBasicLogin
//
//  Created by 近藤米功 on 2022/01/15.
//

import UIKit
import Firebase
 
class ViewController: UIViewController {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        registerButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
        
        //キーボードが出てきた時の通知を受け取る
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        //キーボードが閉じた時の通知を受け取る
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @objc func showKeyboard(notification:Notification){
        print("showKeyboard is showing")
        //キーボードのフレームを取得
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        
        //guard let この処理がnilだったらretrunを返す(処理を終わらせる)
        //キーボードの最小高さを取得
        guard let keyboardMinY = keyboardFrame?.minY else {return}
        
        let registerButtonMaxY = registerButton.frame.maxY
        
        let distance = registerButtonMaxY - keyboardMinY + 20
        
        let transform = CGAffineTransform(translationX: 0, y: -distance)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.view.transform = transform
        })
    }
    @objc func hideKeyboard(){
        print("hideKeyboard is hide")
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.view.transform = .identity
        })
    }
    
    @IBAction func tappedRegisterButton(_ sender: Any) {
        handleAuthFirebase()
    }
    private func handleAuthFirebase(){
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (res,err) in
            if let err = err {
                print("認証に失敗しました")
                return
            }
            //ユーザUIDの取得
            guard let uid = Auth.auth().currentUser?.uid else { return }
            //ユーザの名前を取得
            guard let name = self.usernameTextField.text else { return }
            
            let docData = ["email": email,"name": name,"createdAt": Timestamp()] as [String : Any]
            
            //コレクション名をusersにしてドキュメントをユーザUIDにしてdocDataを保存する
            Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
                if let err = err {
                    print("Firestoreへの保存に失敗しました")
                    return
                }
                print("Firestoreへの保存に成功しました")
            }
        }
        
    }
}

extension ViewController: UITextFieldDelegate{
    //textFieldの情報を受け取ってくれるデリゲートメソッド
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print("textField.text",textField.text!)
        
        //isEmptyがnilならtrueを返す
        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
        let passwordEmpty = passwordTextField.text?.isEmpty ?? true
        let usernameIsEmpty = usernameTextField.text?.isEmpty ?? true
        
        //情報が欠けていたら(true)であれば登録ボタンを押せなくする
        if emailIsEmpty || passwordEmpty || usernameIsEmpty {
            registerButton.isEnabled = false
            //ボタンを押せない時の背景色を変える
            registerButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
            
        }else{
            registerButton.isEnabled = true
            registerButton.backgroundColor = UIColor.rgb(red: 200, green: 200, blue: 200)
        }
    }
}
