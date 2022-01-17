//
//  HomeViewController.swift
//  FireBaseBasicLogin
//
//  Created by 近藤米功 on 2022/01/17.
//

import UIKit

class HomeViewController: UIViewController {
    var passedUser: User? {
        didSet{
            print("passedUser.name:",passedUser?.name)
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let passedUser = passedUser {
            nameLabel.text = passedUser.name + "さんようこそ"
            emailLabel.text = passedUser.email
            let dateString = dateFormatterForCreatedAt(date: passedUser.createdAt.dateValue())
            dateLabel.text = "作成日:" + dateString
        }
    }
    private func dateFormatterForCreatedAt(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
}
