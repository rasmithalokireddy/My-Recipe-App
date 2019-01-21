

import UIKit

class RecipeDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var ingredientsLbl: UILabel!
    
    @IBOutlet weak var quantityLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
