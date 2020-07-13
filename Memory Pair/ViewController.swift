//
//  ViewController.swift
//  Memory Pair
//
//  Created by Simerpreet singh Jassal on 2020-07-12.
//  Copyright © 2020 Simerpreet singh Jassal. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    
    let countryNames = ["Canada","China","England","France", "Germany", "Jamaica","Japan","Netherlands","NewZealand","Spain","Turkey", "UnitedStates"]
    var countriesSelectedForGame = [String]()
    let TOTAL_CELLS = 10
    var howManySelected = 0
    var firstSelectedCell : CardCell?
    var firstSelectedImage = ""
    var score = 0
    var cellImageView: UIImageView?
    var oldImageView: UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
        startTheGame()
       
        // Do any additional setup after loading the view.
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TOTAL_CELLS
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "card", for: indexPath)  as? CardCell else{
            fatalError("Unable to dequeue PersonCell.")
        }
        cell.imageForCard.image = UIImage(named: "images")
        cell.imageForCard.layer.borderWidth = 3
        cell.imageForCard.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    
    func startTheGame(){
        countriesSelectedForGame = Array(countryNames.shuffled().prefix(TOTAL_CELLS/2))
        countriesSelectedForGame.append(contentsOf: countriesSelectedForGame)
        countriesSelectedForGame.shuffle()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score: \(score)", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let  cell = collectionView.cellForItem(at: indexPath) as? CardCell else{return}
        if(howManySelected==2){
            return
        }
        cellImageView = cell.imageForCard
        
        if howManySelected == 0 {
           onlyOneCardSelected(cell,indexPath)
           return
        }
        perform(#selector(myflip))
        cell.imageForCard.image = UIImage(named: countriesSelectedForGame[indexPath.row])
        title = countriesSelectedForGame[indexPath.row]
        howManySelected += 1
        if firstSelectedImage == countriesSelectedForGame[indexPath.row] {
            howManySelected = 0
            score += 1
            if score == 5 {
                score = 0
                displayWinningMessage()
            }
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score: \(score)", style: .done, target: self, action: nil)
            navigationItem.rightBarButtonItem?.tintColor = UIColor.black
            title = ""
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now()+2.0){
                [weak self] in
                self?.cardDontMatch(cell)
            }
        }
    }
    
    
    func onlyOneCardSelected(_ cell: CardCell, _ indexPath: IndexPath ){
       firstSelectedCell = cell
       oldImageView = firstSelectedCell?.imageForCard
       firstSelectedImage = countriesSelectedForGame[indexPath.row]
       title = firstSelectedImage
       howManySelected += 1
       perform(#selector(myflip))
       cell.imageForCard.image = UIImage(named: countriesSelectedForGame[indexPath.row])
       oldImageView = firstSelectedCell?.imageForCard
    }
    func cardDontMatch(_ cell: CardCell){
        title = ""
        perform(#selector(myflip))
        perform(#selector(flipTheOld))
        firstSelectedCell?.imageForCard.image = UIImage(named: "images")
        cell.imageForCard.image = UIImage(named: "images")
        oldImageView = nil
        cellImageView = nil
        howManySelected = 0
    }
    func displayWinningMessage(){
        let ac = UIAlertController(title: "You Won", message: "Do you want to play again?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default){
            [weak self] _ in
            self?.startTheGame()
            self?.collectionView.reloadData()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac,animated: true)
    }
    
    @objc func myflip(){
        let transitionOptions : UIView.AnimationOptions = [.transitionFlipFromTop,.showHideTransitionViews]
        if let imageView = cellImageView{
            UIView.transition(with: imageView, duration: 1.0, options: transitionOptions, animations: {})
        }
    }
    @objc func flipTheOld(){
        let transitionOptions : UIView.AnimationOptions = [.transitionFlipFromTop,.showHideTransitionViews]
        if let secondView = oldImageView{
            UIView.transition(with: secondView, duration: 1.0, options: transitionOptions, animations: {})
        }
    }
}

