//
//  DBHelper.swift
//  ProductsMT
//
//  Created by Mac on 21/10/21.
//

import Foundation
import SQLite3
class DBHelper{
    
        var db: OpaquePointer?
        init() {
           db = createAndOpen()
        }
//MARK: create And Open Table
        private func createAndOpen() ->OpaquePointer? {
            let dataBaseName = "ProductDataBase.sqlite"
            var db : OpaquePointer?
            
            do {
                let documentDir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dataBaseName)
                
                if sqlite3_open(documentDir.path, &db) == SQLITE_OK{
                    print("Database opened successfully..")
                    print("Database path \(documentDir.path)")
                    return db
                }else{
                    print("Unable to open Database")
                }
            } catch {
                print("Unable to get document Directory \(error.localizedDescription)")
            }
            return nil
        }//createAndOpen func end
        
        func createProductTable(){
            var createTableStatement: OpaquePointer?
            let createTableQuery = "CREATE TABLE IF NOT EXISTS product(id INTGER PRIMARY KEY,title TEXT,price Double, description TEXT,category TEXT,image Text,rate Double,count INTGER)"
            
            if sqlite3_prepare_v2(db, createTableQuery, -1, &createTableStatement, nil) == SQLITE_OK{
                if sqlite3_step(createTableStatement) == SQLITE_DONE{
                    print("User table successfully created..")
                }else{
                    print("Unable to create User Table!!!")
                }
            }else{
                print("Unable to prepare create table statement!!")
            }
        }//createUserTable function end
//MARK: Insert Query
        func insertValuesInProduct(product:Product){
            var insertStatement: OpaquePointer?
            let insertQuery = "INSERT INTO product(id,title,price,description,category,image,rate,count) VALUES(?,?,?,?,?,?,?,?)"
            if sqlite3_prepare_v2(db, insertQuery, -1, &insertStatement, nil) == SQLITE_OK{
                let idInt32 = Int32(product.id)
                sqlite3_bind_int(insertStatement, 1, idInt32)
                
                let titleNs = product.title as NSString
                let titleText = titleNs.utf8String
                sqlite3_bind_text(insertStatement, 2, titleText, -1, nil)
                
                let price = Double(product.price)
                sqlite3_bind_double(insertStatement, 3, price)
                
                let descNS = (product.desc as NSString).utf8String
                sqlite3_bind_text(insertStatement, 4, descNS, -1, nil)
                let categoryNS = (product.cat as NSString).utf8String
                sqlite3_bind_text(insertStatement, 5, categoryNS, -1, nil)
                let imageNS = (product.img as NSString).utf8String
                sqlite3_bind_text(insertStatement, 6, imageNS, -1, nil)
                let rate = Double(product.rate)
                sqlite3_bind_double(insertStatement, 7, rate)
                let count = Int32(product.count)
                sqlite3_bind_int(insertStatement, 8, count)
               if sqlite3_step(insertStatement) == SQLITE_DONE{
                    print("Values inserted successfully in product table..")
                }else{
                    print("Unable to insert values in table!!!")
                }
            }else{
                print("Unable to prepare insert Query!!!")
            }
            sqlite3_finalize(insertStatement)
        }
//MARK: Display Product
        func displayProduct()-> [Product]?{
            var selectStatement: OpaquePointer?
            let selectQuery = "SELECT * FROM product"
            var products = [Product]()
            
            if sqlite3_prepare_v2(db,selectQuery, -1, &selectStatement, nil) == SQLITE_OK{
                while sqlite3_step(selectStatement) == SQLITE_ROW {
                    
                    let id = Int(sqlite3_column_int(selectStatement, 0))
                    guard let title_CStr = sqlite3_column_text(selectStatement, 1) else{
                        print("Error while getting name from db!!!")
                        continue
                    }
                    let title = String(cString: title_CStr)
                    let price = Double(sqlite3_column_double(selectStatement, 2))
                    guard let desc_CStr = sqlite3_column_text(selectStatement, 3) else {
                        print("Error while getting description from db!!!")
                        continue
                    }
                    let description = String(cString: desc_CStr)
                    
                    guard let category_CStr = sqlite3_column_text(selectStatement, 4) else {
                        print("Error while getting category from db!!!")
                        continue
                    }
                    let category = String(cString: category_CStr)
                    
                    guard let image_CStr = sqlite3_column_text(selectStatement, 5) else {
                        print("Error while getting image from db!!!")
                        continue
                    }
                    let image = String(cString: image_CStr)
                    
                    let rate = Double(sqlite3_column_double(selectStatement, 6))
                    
                    let count = Int(sqlite3_column_int(selectStatement, 7))
                    let product = Product(id: id, title: title, price: price, desc: description, cat: category, img: image, rate: rate, count: count)
                    products.append(product)
                }
                sqlite3_finalize(selectStatement)
                return products
            }else{
                print("Unable to prepare select query!!!")
            }
            return nil
        }
    }


