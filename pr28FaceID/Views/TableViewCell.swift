//
//  TableViewCell.swift
//  pr28FaceID
//
//  Created by Никита Попов on 29.09.23.
//

import UIKit

class TableViewCell: UITableViewCell {
    var titleLabel: UILabel!
    var dateLabel: UILabel!
    var descriptionLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        createTitleLabel()
        createDateLabel()
        createDescrLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createTitleLabel(){
        titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7)
        ])
        
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1
        titleLabel.font = .systemFont(ofSize: 20, weight: .medium)

    }
    
    private func createDescrLabel(){
        descriptionLabel = UILabel()
        contentView.addSubview(descriptionLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
        
        descriptionLabel.numberOfLines = 3
        
    }
    
    private func createDateLabel(){
        dateLabel = UILabel()
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 5),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            dateLabel.heightAnchor.constraint(equalTo: titleLabel.heightAnchor)
        ])
        
        dateLabel.textAlignment = .right
    }
    
    
    func setData(node: NodeDataModel){
        self.titleLabel.text = node.title
        self.dateLabel.text = node.date
        self.descriptionLabel.text = node.falseBody
    }
    
}
