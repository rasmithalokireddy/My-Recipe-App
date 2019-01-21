//
//  RecipeListTableViewCell.swift
//  MyRecipeApp
//
//  Created by SAMPATH ANUMALA on 05/12/18.
//  Copyright © 2018 SAMPATH ANUMALA. All rights reserved.
//

import UIKit

class RecipeListTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
