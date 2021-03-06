//
//  CoinsViewController.swift
//  iCripto
//
//  Created by Sebastian Ortiz Velez on 01/09/2019.
//  Copyright © 2019 Sebastian Ortiz Velez. All rights reserved.
//

import UIKit

class CoinsViewController: UITableViewController {

    var coins : Array<Coin> = []
    var senderView : Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkConnection()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func checkConnection(){

        if(coins.count == 0){
            let myalert = UIAlertController(title: "Connection error", message: "Please, check your internet connection", preferredStyle: UIAlertController.Style.alert) 
            myalert.addAction(UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in 
                self.goToMainViewController()
            })

            self.present(myalert, animated: true) 
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "CoinCell")
        cell.textLabel?.text  = coins[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let coin = coins[indexPath.row]
        
        switch senderView {
        case 1:
            UserDefaults.standard.set(try! PropertyListEncoder().encode(coin), forKey: "firstCoin")
        case 2:
            UserDefaults.standard.set(try! PropertyListEncoder().encode(coin), forKey: "secondCoin")
        case 3:
            UserDefaults.standard.set(try! PropertyListEncoder().encode(coin), forKey: "thirdCoin")
        default:
            UserDefaults.standard.set(try! PropertyListEncoder().encode(coin), forKey: "fourthCoin")
        }
        
        goToMainViewController()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
      //  cell.backgroundColor = UIColor.clear
    }
    
    func goToMainViewController(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destVC = storyboard.instantiateViewController(withIdentifier: "mainVC") as! ViewController
        
        destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        self.present(destVC, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
