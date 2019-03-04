//
//  MainViewController.swift
//  1l_2S_Mihailov_Mihail
//
//  Created by Лекс Лютер on 28/02/2019.
//  Copyright © 2019 Лекс Лютер. All rights reserved.
//
import Foundation
import UIKit
import SafariServices

class MainViewController: UIViewController {
    var transportLine = Int()
    
    @IBOutlet weak var messgeField: UITextView!
    
    @IBAction func watchigButton(_ sender: UIButton) { // Переход на страницу поиска 
        
        let screenName =  String(base[transportLine].favoriteАnime).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let url = "https://shikimori.org/animes?search=" + screenName!
        let urlString = NSURL(string:url)
        
        let svc = SFSafariViewController(url: urlString! as URL)
            present(svc, animated: true, completion: nil)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Main Board"
        
        let emptyView = UIView(frame: .zero)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: emptyView)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        messgeField.text = "Приветствую " + base[transportLine].name + ", давненько мы не виделись." + "\n" + "Ваше любимое анимэ " + base[transportLine].favoriteАnime + " ждет))"
        
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer)  // Возврат к предыдушему меню по свайпу
    {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer
        {
            switch swipeGesture.direction
            {
            case UISwipeGestureRecognizer.Direction.right:
                self.navigationController?.popViewController(animated: true)
            default:
                break
            }
        }
    }




}
