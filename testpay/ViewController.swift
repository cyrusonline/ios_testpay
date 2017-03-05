//
//  ViewController.swift
//  testpay
//
//  Created by Cyrus Chan on 1/3/2017.
//  Copyright © 2017 ckmobile.com. All rights reserved.
//

//Geeklylemon 7:43

import UIKit
import StoreKit
class ViewController: UIViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate{
    
    @IBOutlet weak var buyButton: UIButton!
    var product: SKProduct?
    var productID = "com.ckmobile.testpay.item01"

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        buyButton.isEnabled = false
        SKPaymentQueue.default().add(self)
        //The above make sure this class handle all the transaction
        
        
        getPurchaseInfo()
        let save = UserDefaults.standard
        if save.value(forKey: "buy") != nil{
            removePic()
        }
        
        restorePurchase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func buy(_ sender: Any) {
        
        let payment = SKPayment(product: product!)
        SKPaymentQueue.default().add(payment)
        //this trigger paymment Queue
        
    }
    @IBAction func restore(_ sender: Any) {
        
        restorePurchase()
    }
    
    func getPurchaseInfo(){
        
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: NSSet(objects: self.productID) as! Set<String>)
            request.delegate = self
            request.start()
        }else{
            productTitle.text = "Please enable your IAP"
            
        }
       
        
        
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        var products = response.products
        if (products.count != 0) {
            buyButton.isEnabled = true
            product = products[0]
            productTitle.text = product?.localizedTitle
            
        }else{
            productTitle.text = "product not found"
        }
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions{
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                buyButton.isEnabled = false
                productTitle.text = "Transaction state purchased"
                self.removePic()
                
            case SKPaymentTransactionState.failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                  productTitle.text = "Transaction state failed"
                
                
            default:
                break
            }
        }
        
    }
    
    func removePic(){
        picture.isHidden = true
        let save = UserDefaults.standard
        save.set(true, forKey: "buy")
        save.synchronize()
    }
    
    func restorePurchase(){
        if (SKPaymentQueue.canMakePayments()) {
            SKPaymentQueue.default().restoreCompletedTransactions()
        }
        
    }


}

