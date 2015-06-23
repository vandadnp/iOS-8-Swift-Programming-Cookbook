//
//  ViewController.swift
//  Providing Header and Footer in a Collection View
//
//  Created by Vandad Nahavandipoor on 7/2/14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//
//  These example codes are written for O'Reilly's iOS 8 Swift Programming Cookbook
//  If you use these solutions in your apps, you can give attribution to
//  Vandad Nahavandipoor for his work. Feel free to visit my blog
//  at http://vandadnp.wordpress.com for daily tips and tricks in Swift
//  and Objective-C and various other programming languages.
//  
//  You can purchase "iOS 8 Swift Programming Cookbook" from
//  the following URL:
//  http://shop.oreilly.com/product/0636920034254.do
//
//  If you have any questions, you can contact me directly
//  at vandad.np@gmail.com
//  Similarly, if you find an error in these sample codes, simply
//  report them to O'Reilly at the following URL:
//  http://www.oreilly.com/catalog/errata.csp?isbn=0636920034254

import UIKit

class ViewController: UICollectionViewController {
  
  let animationDuration = 0.20
  
  let allImages = [
    UIImage(named: "1"),
    UIImage(named: "2"),
    UIImage(named: "3")
  ]
  
  
  func randomImage() -> UIImage{
    return allImages[Int(arc4random_uniform(UInt32(allImages.count)))]!
  }
  
  override init(collectionViewLayout layout: UICollectionViewLayout) {
    super.init(collectionViewLayout: layout)
    
    /* Register the nib with the collection view for easy retrieval */
    let nib = UINib(nibName: "MyCollectionViewCell", bundle: nil)
    collectionView!.registerNib(nib, forCellWithReuseIdentifier: "cell")
    
    /* Register the header's nib */
    let headerNib = UINib(nibName: "Header", bundle: nil)
    collectionView!.registerNib(headerNib,
      forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
      withReuseIdentifier: "header")
    
    /* Register the footer's nib */
    let footerNib = UINib(nibName: "Footer", bundle: nil)
    collectionView!.registerNib(footerNib,
      forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
      withReuseIdentifier: "footer")
    
    collectionView!.backgroundColor = UIColor.whiteColor()
  }
  
convenience required init(coder aDecoder: NSCoder) {
  let flowLayout = UICollectionViewFlowLayout()
  
  flowLayout.minimumLineSpacing = 20
  flowLayout.minimumInteritemSpacing = 10
  flowLayout.itemSize = CGSize(width: 80, height: 120);
  flowLayout.scrollDirection = .Vertical
  
  flowLayout.sectionInset =
    UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
  
  /* Set the reference size for the header and the footer views */
  flowLayout.headerReferenceSize = CGSize(width: 300, height: 50)
  flowLayout.footerReferenceSize = CGSize(width: 300, height: 50)
  
  self.init(collectionViewLayout: flowLayout)
}
  
  override func collectionView(collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
      
      var identifier = "header"
      if kind == UICollectionElementKindSectionFooter{
        identifier = "footer"
      }
      
      let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
        withReuseIdentifier: identifier,
        forIndexPath: indexPath) as UICollectionReusableView
      
      if kind == UICollectionElementKindSectionHeader{
        if let header = view as? Header{
          header.label.text = "Section Header \(indexPath.section+1)"
        }
      }
      else if kind == UICollectionElementKindSectionFooter{
        if let footer = view as? Footer{
          let title = "Section Footer \(indexPath.section+1)"
          footer.button.setTitle(title, forState: .Normal)
        }
      }

      return view
    
  }

  
  override func numberOfSectionsInCollectionView(
    collectionView: UICollectionView) -> Int {
      /* Between 3 to 6 sections */
      return Int(3 + arc4random_uniform(4))
  }
  
  override func collectionView(collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
      /* Each section has between 10 to 15 cells */
      return Int(10 + arc4random_uniform(6))
  }
  
  override func collectionView(collectionView: UICollectionView,
    cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
        "cell", forIndexPath: indexPath) as! MyCollectionViewCell
      
      cell.imageViewBackgroundImage.image = randomImage()
      cell.imageViewBackgroundImage.contentMode = .ScaleAspectFit
      
      return cell
      
  }
  
  override func collectionView(collectionView: UICollectionView,
    didSelectItemAtIndexPath indexPath: NSIndexPath){
      
      let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)
      as UICollectionViewCell!
      
      UIView.animateWithDuration(animationDuration, animations: {
        selectedCell.alpha = 0
        }, completion: {[weak self] (finished: Bool) in
          UIView.animateWithDuration(self!.animationDuration, animations: {
            selectedCell.alpha = 1
            })
        })
      
  }
  
  override func collectionView(collectionView: UICollectionView,
    didHighlightItemAtIndexPath indexPath: NSIndexPath) {
      
      let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)
      as UICollectionViewCell!
      
      UIView.animateWithDuration(animationDuration, animations: {
        selectedCell.transform = CGAffineTransformMakeScale(4, 4)
        })
      
  }
  
  override func collectionView(collectionView: UICollectionView,
    didUnhighlightItemAtIndexPath indexPath: NSIndexPath){
      
      let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)
      as UICollectionViewCell!
      
      UIView.animateWithDuration(animationDuration, animations: {
        selectedCell.transform = CGAffineTransformIdentity
        })
      
  }
}

