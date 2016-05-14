//
//  ImageCollectionViewCell.swift
//  grab3
//
//  Created by Emily on 5/13/16.
//  Copyright © 2016 emilyosowski. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    // connects cell to imageview
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    // no iteration just reusing 
}




