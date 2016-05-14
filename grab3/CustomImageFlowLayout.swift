//
//  CustomImageFlowLayout.swift
//  grab3
//
//  Created by Emily on 5/13/16.
//  Copyright © 2016 emilyosowski. All rights reserved.
//

import UIKit

class CustomImageFlowLayout: UICollectionViewFlowLayout {
    // inheritance gives it neccessary classes and methods
    
    override init() {
        super.init()
        setupLayout()
    }
    // initialize method to setup layout immediately, inherits from super
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    // unsure
    
    override var itemSize: CGSize {
        set {
            
        }
        get {
            let numberOfColumns: CGFloat = 4
            
            let itemWidth = (CGRectGetWidth(self.collectionView!.frame) - (numberOfColumns - 1)) / numberOfColumns
            return CGSizeMake(itemWidth, itemWidth)
        }
    }
    
    // changes the size of the columns and therefore the cells so it fits various interfaces
    
    func setupLayout() {
        minimumInteritemSpacing = 1
        minimumLineSpacing = 1
        scrollDirection = .Vertical
    }
    
    // formatting initial layout
    
}
