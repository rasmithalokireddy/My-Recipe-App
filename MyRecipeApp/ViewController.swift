//
//  ViewController.swift
//  MyRecipeApp
//
//  Created by Rashmitha reddy on 05/12/18.
//  Copyright © 2018 Rashmitha reddy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var recipes = [String]()
    

    @IBOutlet weak var recipeCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Recipe Categories"
        recipeCollectionView.delegate = self
        recipeCollectionView.dataSource = self
         recipes = ["Appetisers","Brunch","Breakfast","Lunch","Dinner","Snacks","Soups","Salads","Rice","Noodles","Pasta","Pies","Burgers","Chicken","Turkey","Meat","Seafood","Sauces","Desserts","Drinks"]
        print(recipes)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCollectionViewCell", for: indexPath) as! RecipeCollectionViewCell
        cell.recipeName.text = recipes[indexPath.row]
        cell.recipeImageView.image = UIImage(named: recipes[indexPath.row])
        cell.recipeImageView.layer.cornerRadius = 10
        cell.recipeName.layer.cornerRadius = 10
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //RecipeListViewController
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "RecipesListViewController") as! RecipesListViewController
        controller.recipe = recipes[indexPath.row]
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: recipeCollectionView.frame.width / 3-5 , height: (recipeCollectionView.frame.height / 4)-10)
        
    }
    
}

