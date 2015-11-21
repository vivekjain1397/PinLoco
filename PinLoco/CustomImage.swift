//
//  CustomImage.swift
//  PinLoco
//
//  Created by Nicholas Cai on 11/15/15.
//  Copyright © 2015 Vivek Jain. All rights reserved.
//

import UIKit

class CustomImage {
    let rating: Int?
    let image: UIImage?

    
    init?(rating: Int?, image: UIImage?) {
        self.rating = rating
        self.image = image
    }

    
}
