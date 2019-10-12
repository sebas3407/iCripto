//
//  ViewController.swift
//  iCripto
//
//  Created by Sebastian Ortiz Velez on 18/04/2019.
//  Copyright © 2019 Sebastian Ortiz Velez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var coins : Array<Coin> = []
    
    //UI controls
    @IBOutlet weak var viewFirstCoin: UIView!{
        didSet {
            viewFirstCoin.setGradient(colorTop: (UIColor(named: "purpleTop")?.cgColor)!, colorBottom: (UIColor(named: "purpleBottom")?.cgColor)!)
        }
    }
    
    @IBOutlet weak var viewSecondCoin: UIView!{
        didSet {
            viewSecondCoin.setGradient(colorTop: (UIColor(named: "greenTop")?.cgColor)!, colorBottom: (UIColor(named: "greenBottom")?.cgColor)!)
        }
    }
    
    @IBOutlet weak var viewThirdCoin: UIView!{
        didSet{
            viewThirdCoin.setGradient(colorTop: (UIColor(named: "orangeTop")?.cgColor)!, colorBottom: (UIColor(named: "orangeBottom")?.cgColor)!)
        }
    }
    
    @IBOutlet weak var viewFourthCoin: UIView!{
        didSet{
             viewFourthCoin.setGradient(colorTop: (UIColor(named: "pinkTop")?.cgColor)!, colorBottom: (UIColor(named: "pinkBottom")?.cgColor)!)
        }
    }
    
    @IBOutlet weak var lblToday: UILabel!{
        didSet{
            lblToday.text = setFormatedDate(date: Date())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DownloadCoins()
        
        let views : [UIView] = [viewFirstCoin, viewSecondCoin, viewThirdCoin, viewFourthCoin]
        for i in 0..<views.count{
            let tap = UITapGestureRecognizer(target: self, action: #selector(openCoinsView(sender:)))
            tap.accessibilityLabel = String(i + 1)
            views[i].addGestureRecognizer(tap)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let firsCoin = UserDefaults.standard.string(forKey: "firstCoin")
        let secondCoin = UserDefaults.standard.string(forKey: "secondCoin")
        let thirdCoin = UserDefaults.standard.string(forKey: "thirdCoin")
        let fourthCoin = UserDefaults.standard.string(forKey: "fourthCoin")
    }
    
    func DownloadCoins()
    {
        //Implementing URLSession
        let urlString = "https://api.coinmarketcap.com/v1/ticker/?limit=0"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let dataFromUrl = data else { return }
            do {
                self.coins = try JSONDecoder().decode(Array<Coin>.self, from: dataFromUrl)
                
                DispatchQueue.main.async {}
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
        //End implementing URLSession
    }
    
    func setFormatedDate(date : Date) -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    @objc func openCoinsView(sender: UITapGestureRecognizer) {
        let senderView = sender.accessibilityLabel
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destVC = storyboard.instantiateViewController(withIdentifier: "destinationVC") as! CoinsViewController
        
        destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        destVC.coins = self.coins
        destVC.senderView = Int(senderView!)!
        
        self.present(destVC, animated: true, completion: nil)
    }
}
