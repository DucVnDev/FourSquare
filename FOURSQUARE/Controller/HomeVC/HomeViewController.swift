//
//  HomeViewController.swift
//  FOURSQUARE
//
//  Created by Van Ngoc Duc on 01/03/2022.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var breakfastBtn: UIButton!
    @IBOutlet weak var thingBtn: UIButton!
    @IBOutlet weak var nightlifeBtn: UIButton!
    @IBOutlet weak var coffeeBtn: UIButton!
    @IBOutlet weak var dinnerBtn: UIButton!
    @IBOutlet weak var lunchBtn: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()

        setUpBtn()
    }

    func setUpBtn() {
        searchBtn.layer.cornerRadius = 8

        breakfastBtn.configuration?.image = UIImage(named: "Breakfast1.png")
        breakfastBtn.configuration?.title = "Breakfast"
        breakfastBtn.configuration?.attributedTitle?.font = UIFont.systemFont(ofSize: 12)
        breakfastBtn.configuration?.imagePadding = 20
        //breakfastBtn.configuration?.imagePlacement =

        lunchBtn.configuration?.image = UIImage(named: "Lunch1.png")
        lunchBtn.configuration?.title = "Lunch"
        lunchBtn.configuration?.attributedTitle?.font = UIFont.systemFont(ofSize: 12)
        lunchBtn.configuration?.imagePadding = 20

        dinnerBtn.configuration?.image = UIImage(named: "Dinner1.png")
        dinnerBtn.configuration?.title = "Dinner"
        dinnerBtn.configuration?.attributedTitle?.font = UIFont.systemFont(ofSize: 12)
        dinnerBtn.configuration?.imagePadding = 20

        coffeeBtn.configuration?.image = UIImage(named: "Coffee&Tee1.png")
        coffeeBtn.configuration?.title = "Coffee & Tea"
        coffeeBtn.configuration?.attributedTitle?.font = UIFont.systemFont(ofSize: 12)
        coffeeBtn.configuration?.imagePadding = 20

        nightlifeBtn.configuration?.image = UIImage(named: "Nightlife1.png")
        nightlifeBtn.configuration?.title = "Nightlife"
        nightlifeBtn.configuration?.attributedTitle?.font = UIFont.systemFont(ofSize: 12)
        nightlifeBtn.configuration?.imagePadding = 20

        thingBtn.configuration?.image = UIImage(named: "ThingsToDo1.png")
        thingBtn.configuration?.title = "Things to do"
        thingBtn.configuration?.attributedTitle?.font = UIFont.systemFont(ofSize: 12)
        thingBtn.configuration?.imagePadding = 20
    }

    
    @IBAction func searchBtnDidTap(_ sender: Any) {
        self.navigationController?.pushViewController(SearchViewController(), animated: true)
    }

    @IBAction func breakfastBtnDidTap(_ sender: Any) {
        self.navigationController?.pushViewController(ListSearchViewController(), animated: true)
    }
    @IBAction func lunchBtnDidTap(_ sender: Any) {
    }
    @IBAction func dinnerBtnDidTap(_ sender: Any) {
    }
    @IBAction func coffeeBtnDidTap(_ sender: Any) {
    }
    @IBAction func nightlifeBtnidTap(_ sender: Any) {
    }
    @IBAction func thingBtnDidTap(_ sender: Any) {
    }

}
