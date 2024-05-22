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
        
        return label
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        selectionStyle = .none
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
        self.scoreLabel.text = String(contents.score)
    }
    
}

private extension RankTableViewCell {
    
    func setUI() {
        // TODO: indexpath 홀수 짝수에 맞게 배경 변경
        
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
            rankLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            rankLabel.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            nickNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nickNameLabel.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 10),
            nickNameLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            scoreLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            scoreLabel.leadingAnchor.constraint(equalTo: nickNameLabel.trailingAnchor, constant: 10),
            scoreLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
}
