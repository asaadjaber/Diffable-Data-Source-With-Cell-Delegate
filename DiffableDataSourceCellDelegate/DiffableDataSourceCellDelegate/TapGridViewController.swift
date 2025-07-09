//
//  ViewController.swift
//  DiffableDataSourceCellDelegate
//
//  Created by Asaad Jaber on 08/07/2025.
//

import UIKit

class TapGridViewController: UIViewController {

    @IBOutlet weak var tapGridCollectionView: UICollectionView!
    
    enum Section: Int {
        case main
    }
    
    struct CellItem: Hashable {
        var numberOfTaps: Int
        
        mutating func incrementLabelCount() {
            numberOfTaps += 1
        }
        
        var uuid = UUID()
    }
        
    var cellItems = [CellItem(numberOfTaps: 0)]
    
    var dataSource: UICollectionViewDiffableDataSource<Section, CellItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tapGridCollectionView.collectionViewLayout = createLayout()
        
        configureDataSource()
        
        applySnapshot()
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/3))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<TapLabelCollectionViewCell, CellItem>(handler: { (cell: TapLabelCollectionViewCell, indexPath: IndexPath, item: CellItem) in
            
            cell.delegate = self
            
            cell.index = indexPath.row
            
            cell.numberOfTapsLabel.text = String(item.numberOfTaps)
        })
        
        dataSource = UICollectionViewDiffableDataSource<Section, CellItem>(collectionView: tapGridCollectionView, cellProvider: { (collectionView: UICollectionView, indexPath: IndexPath, item: CellItem) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            
            return cell
            
        })
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CellItem>()
        
        snapshot.appendSections([.main])
        
        snapshot.appendItems(cellItems)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension TapGridViewController: TapLabelCollectionViewCellDelegate {
    func incrementNumberOfTaps(index: Int) {
        
        cellItems[index].incrementLabelCount()
        
        cellItems.append(CellItem(numberOfTaps: 0))
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, CellItem>()
         
        snapshot.appendSections([.main])
        
        snapshot.appendItems(cellItems)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension TapGridViewController.CellItem: Equatable {
    
    static func ==(lhs: TapGridViewController.CellItem, rhs: TapGridViewController.CellItem) -> Bool {
        return lhs.numberOfTaps == rhs.numberOfTaps && lhs.uuid == rhs.uuid
    }
}
