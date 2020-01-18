//
//  RestaurantData.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 1/18/20.
//  Copyright © 2020 Ali Alobaidi. All rights reserved.
//

import Foundation

struct RestaurantData: Decodable {
    let name: String
    let uid: String
    let location: String
    let logoImageUrl: String
    let menuId: String
}
