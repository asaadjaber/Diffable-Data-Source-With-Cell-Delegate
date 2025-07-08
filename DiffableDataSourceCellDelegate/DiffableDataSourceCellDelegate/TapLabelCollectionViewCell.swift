//
//  TapLabelCollectionViewCell.swift
//  DiffableDataSourceCellDelegate
//
//  Created by Asaad Jaber on 08/07/2025.
//

import UIKit

protocol TapLabelCollectionViewCellDelegate: AnyObject {
    func incrementNumberOfTaps(index: Int)
}

class TapLabelCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var numberOfTapsLabel: UILabel!
    
    var delegate: TapLabelCollectionViewCellDelegate?
    
    var index: Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpTapGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(incrementNumberOfTaps))
        print("numberOfTapsLabel", numberOfTapsLabel)
        numberOfTapsLabel.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func incrementNumberOfTaps() {
        delegate?.incrementNumberOfTaps(index: index)
    }
    
}
