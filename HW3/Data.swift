//
//  Data.swift
//  HW3
//
//  Created by Yu Zhi on 2022/11/11.
//

import Foundation

struct bagel{
    var bread:String
    var sauce:String
    var extra:String
}


let bread:[String] = ["Salt","Garlic","Sesame","Cheese","Onion","Wheat"]

let extra:[String] = ["Egg🥚","Aged goat cheese🧀","Avocado🥑","Salmon","Cucumber🥒","Spiced Ham","Bacon🥓","Banana🍌","Grapes🍇","Almond","Blueberries🫐","Tomatoes🍅"]


let sauce:[String] = ["Labneh","Grainy Mustard","Coconut Oil","None"]

struct order{
    let time:Date
    let bread:String
    let sauce:String
    let extra:String
    let count:Int
    let score:Double
}
