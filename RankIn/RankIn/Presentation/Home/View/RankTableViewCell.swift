//
//  RankTableViewCell.swift
//  RankIn
//
//  Created by 조성민 on 5/22/24.
//

import UIKit

final class RankTableViewCell: UITableViewCell {
    
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .pretendard(type: .semiBold, size: 24)
        
        return label
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .pretendard(type: .bold, size: 15)
        
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .pretendard(type: .regular, size: 13)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        rankLabel.text = nil
        nickNameLabel.text = nil
        scoreLabel.text = nil
    }
    
    func setContents(contents: RankTableViewCellContents) {
        self.rankLabel.text = String(contents.rank)
        self.nickNameLabel.text = contents.nickName
        self.scoreLabel.text = String(format: "%.2f", contents.score)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 52, bottom: 4, right: 52))
        contentView.layer.masksToBounds = true
    }
    
}

private extension RankTableViewCell {
    
    func setUI() {
        self.backgroundColor = .systemGray6
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 10
        selectionStyle = .none
        
        setHierarchy()
        setConstraints()
    }
    
    func setHierarchy() {
        contentView.addSubview(rankLabel)
        contentView.addSubview(nickNameLabel)
        contentView.addSubview(scoreLabel)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            rankLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rankLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            rankLabel.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            nickNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nickNameLabel.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 22),
            nickNameLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            scoreLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scoreLabel.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
}
