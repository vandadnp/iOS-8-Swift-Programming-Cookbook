//
//  ViewController.swift
//  Providing Basic Content to a Collection View
//
//  Created by Vandad Nahavandipoor on 7/1/14.
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

  let allSectionColors = [
    UIColor.redColor(),
    UIColor.greenColor(),
    UIColor.blueColor()]
  
  override init(collectionViewLayout layout: UICollectionViewLayout!) {
    super.init(collectionViewLayout: layout)
    
    collectionView.registerClass(UICollectionViewCell.classForCoder(),
      forCellWithReuseIdentifier: "cell")
    
    collectionView.backgroundColor = UIColor.whiteColor()
  }
  
  convenience required init(coder aDecoder: NSCoder) {
    
    let flowLayout = UICollectionViewFlowLayout()
    
    flowLayout.minimumLineSpacing = 20
    flowLayout.minimumInteritemSpacing = 10
    flowLayout.itemSize = CGSize(width: 80, height: 120);
    flowLayout.scrollDirection = .Vertical
    
    flowLayout.sectionInset =
      UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    
    self.init(collectionViewLayout: flowLayout)
  }
  
  override func numberOfSectionsInCollectionView(
    collectionView: UICollectionView!) -> Int{
      return allSectionColors.count
  }
  
  override func collectionView(collectionView: UICollectionView!,
    numberOfItemsInSection section: Int) -> Int{
      /* Generate between 20 to 40 cells for each section */
      return Int(arc4random_uniform(21)) + 20
  }
  
  override func collectionView(collectionView: UICollectionView!,
    cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell!{
      
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
        "cell",
        forIndexPath: indexPath) as UICollectionViewCell
      
      cell.backgroundColor = allSectionColors[indexPath.section]
      
      return cell
      
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
}

