//
//  FilterCollectionViewCell.swift
//  Book Share
//
//  Created by Korlan Omarova on 07.03.2021.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.orange
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.layer.masksToBounds = true
        label.sizeToFit()
        return label
    }()
    override var isSelected: Bool {
        didSet{
            if self.isSelected {
                UIView.animate(withDuration: 0.3) { 
                    self.backgroundColor = Constants.orange
                    self.layer.borderColor = Constants.orange.cgColor
                    self.textLabel.textColor = .white
                }
            }
            else {
                UIView.animate(withDuration: 0.3) {
                    self.backgroundColor = Constants.gray
                    self.layer.borderColor = Constants.gray?.cgColor
                    self.textLabel.textColor = Constants.orange
                }
            }
        }
    }
        
    override init(frame: CGRect  = .zero) {
        super .init(frame: frame)
        setupViews()
        setStyles()
        
    }
    
    private func setStyles(){
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = Constants.gray?.cgColor
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setText(text: String){
        self.textLabel.text = text
    }
    
    private func setupViews() {
        self.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
      
    }
}
