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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        let coin = coins[indexPath.row].id
        
        switch "" {
        case "":
            UserDefaults.standard.set(coin, forKey: "firstCoin")
        case "":
            UserDefaults.standard.set(coin, forKey: "secondCoin")
        case "":
            UserDefaults.standard.set(coin, forKey: "thirdCoin")
        default:
            UserDefaults.standard.set(coin, forKey: "fourthCoin")
        }
        
        goToMainViewController()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
      //  cell.backgroundColor = UIColor.clear
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    func goToMainViewController(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destVC = storyboard.instantiateViewController(withIdentifier: "mainVC") as! ViewController
        
        destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        self.present(destVC, animated: true, completion: nil)
    }
}