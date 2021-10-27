//
//  HomeViewController.swift
//  ProductsMT
//
//  Created by Mac on 21/10/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var toggleBtn: UISwitch!
    @IBOutlet weak var productsView: UICollectionView!
    
    var products = [Product]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleBtnAction(UISwitch())
    }
    
    @IBAction func toggleBtnAction(_ sender: Any) {
        if toggleBtn.isOn{
            dataFromAPI()
        }else{
            let dbObj = DBHelper()
           // dbObj.createProductTable()
            if let products = dbObj.displayProduct(){
                self.products = products
                self.productsView.reloadData()
            }
        }
    }
       
//MARK: API Calling
    func dataFromAPI(){
        let apiString = "https://fakestoreapi.com/products"
        if let url = URL(string: apiString) {
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: url) { [weak self](dataFromServer, responce, error) in
                guard let data = dataFromServer else {
                    return
                }
                
                guard let products = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] else {
                    return
                }
                
                for product in products {
                    
                    guard let rating = product["rating"] as? [String:Any] else {
                        return
                    }
                    let rate = rating["rate"] as? Double ?? 0.0
                    let count = rating["count"] as? Int ?? 0
                    
                    let product = Product(id: (product["id"] as? Int) ?? 0, title: (product["title"] as? String) ?? "", price: (product["price"] as? Double) ?? 0.0, desc: (product["description"] as? String) ?? "", cat: (product["category"] as? String) ?? "", img: (product["image"] as? String) ?? "", rate: rate, count: count)
                    self?.products.append(product)
                    DispatchQueue.main.async {
                        self?.productsView.reloadData()
                    }
                }

            }
            dataTask.resume()
        }else{
            print("Invalid Url!!!")
        }
    }

}
//MARK:UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let product = products[indexPath.row]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell{
            cell.titleLabel.text = product.title
            cell.priceLabel.text = String(product.price)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

//MARK:UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = CGFloat(200)
        return CGSize(width: width, height: height)
    }
}

//MARK:UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        if toggleBtn.isOn{
            if let displayProductViewControllerObj = storyboard?.instantiateViewController(withIdentifier: "DisplayProductViewController") as? DisplayProductViewController{
                displayProductViewControllerObj.product = product
                navigationController?.pushViewController(displayProductViewControllerObj, animated: true)
            } else{
                print("Unable to locate DisplayProductViewController!!!")
            }
        }else{
            if let displayProductViewControllerObj = storyboard?.instantiateViewController(withIdentifier: "DisplayProductViewController") as? DisplayProductViewController{
                displayProductViewControllerObj.product = product
                displayProductViewControllerObj.flag=1
                navigationController?.pushViewController(displayProductViewControllerObj, animated: true)
            } else{
                print("Unable to locate DisplayProductViewController!!!")
            }
        }
        
    }
}
