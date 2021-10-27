//
//  DisplayProductViewController.swift
//  ProductsMT
//
//  Created by Mac on 21/10/21.
//

import UIKit

class DisplayProductViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    var product: Product?
    var flag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Product details"
        display()
        if flag == 0{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "WishList", style: .plain, target: self, action: #selector(addProductButtonAction))
        }
    }
    
   @objc func addProductButtonAction(){
        let dbObj = DBHelper()
    if let product = product{
        dbObj.insertValuesInProduct(product: product)
    }else{
        print("nil value find in Product")
    }
   }
    
//MARK: Display
    func display(){
        titleLabel.text = product?.title
        descriptionLabel.text = product?.desc
        categoryLabel.text = product?.cat
        countLabel.text = String(product?.count ?? 0)
        rateLabel.text = String(product?.rate ?? 0.0)
        let imgURL = URL.init(string: product!.img)
        let imageData = try? Data.init(contentsOf: imgURL!)
        imageLabel.image = UIImage.init(data: imageData!)
    }
}
