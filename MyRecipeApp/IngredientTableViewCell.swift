
import UIKit

class IngredientTableViewCell: UITableViewCell {

    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var ingredientsLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
