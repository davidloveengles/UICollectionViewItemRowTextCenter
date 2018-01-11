//
//  ViewController.swift
//  TestCollectionView
//
//  Created by David on 2018/1/10.
//  Copyright © 2018年 David. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    var list = ["撒打发斯蒂芬爱上了地方几十块", "你好呀", "阿斯顿发撒地方", "家里可见到过地方", "地方"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = CollectionLayout()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
    }
    
    


}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        cell.backgroundColor = UIColor.magenta
        let textLabel = UILabel(frame: cell.bounds)
        textLabel.textColor = UIColor.blue
        textLabel.textAlignment = .center
        cell.addSubview(textLabel)
        
        textLabel.text = list[indexPath.item]
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = list[indexPath.item]
        
        let textSize = (text as NSString).boundingRect(with: CGSize(width: 1000, height: 30), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17)], context: nil).size
        return CGSize(width: textSize.width + 10, height: 30)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

class CollectionLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let attributes = super.layoutAttributesForElements(in: rect)!
        
        guard attributes.count > 0 else {
            return attributes
        }
        
        // 每一行作为一个数组添加进rows
        var rows = [[UICollectionViewLayoutAttributes]]()
        var curRowList = [UICollectionViewLayoutAttributes]()
        curRowList.append(attributes.first!)
        rows.append(curRowList)
        for i in 1..<attributes.count {
            let curFrame = attributes[i].frame
            let preFrame = attributes[i - 1].frame
            if curFrame.origin.y == preFrame.origin.y {
                rows.removeLast()
                curRowList.append(attributes[i])
                rows.append(curRowList)
            }else {
                curRowList = [UICollectionViewLayoutAttributes]()
                curRowList.append(attributes[i])
                rows.append(curRowList)
            }
        }
        
        // 每行的元素居中
        for row in rows {
            let rowWidthNum = row.reduce(0, { (eWidthNum, e) -> CGFloat in
                return eWidthNum + e.frame.size.width
            })
            
            print(rowWidthNum)
            
            let margin = (rect.size.width - rowWidthNum ) / CGFloat(row.count + 1)
            
            for (i, e) in row.enumerated() {
                if i == 0 {
                    e.frame.origin.x = margin
                }else {
                    let preE = row[i - 1]
                    e.frame.origin.x =  preE.frame.maxX + margin
                }
            }
        }
        
        return attributes
    }
    
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//
//    }
}







