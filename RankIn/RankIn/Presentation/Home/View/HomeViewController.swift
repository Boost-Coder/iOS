//
//  HomeViewController.swift
//  RankIn
//
//  Created by 조성민 on 3/21/24.
//

import UIKit
import RxRelay
import RxSwift

final class HomeViewController: UIViewController {
    
    // MARK: Input
    private let getRankTableCellContent = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    
    private lazy var rankTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RankTableViewCell.self, forCellReuseIdentifier: RankTableViewCell.identifier)
        tableView.rowHeight = 56
        tableView.backgroundColor = .systemGray6
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    private let myRankLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let myNicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let myScoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    enum Section {
        
        case rank
        
    }
    
    private lazy var dataSource = UITableViewDiffableDataSource<Section, RankTableViewCellContents>(
        tableView: rankTableView
    ) { (tableView, indexPath, contents) in
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RankTableViewCell.identifier,
            for: indexPath
        ) as? RankTableViewCell else {
            return RankTableViewCell()
        }
        
        cell.setContents(contents: contents)
        return cell
    }
    
    private let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .fullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bind()
        loadTableView()
    }

}

private extension HomeViewController {
    
    func setUI() {
        view.backgroundColor = .systemGray6
        navigationController?.navigationBar.barTintColor = .systemGray6
        navigationController?.navigationBar.isHidden = true
        
        setHierarchy()
        setConstraints()
    }
    
    func setHierarchy() {
        view.addSubview(rankTableView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            rankTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            rankTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            rankTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            rankTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ])
    }
    
    func bind() {
        let output = viewModel.transform(
            input: HomeViewModelInput(
                getRankTableCellContent: getRankTableCellContent
            )
        )
        
        output.fetchRankListComplete
            .subscribe { contents in
                self.generateData(contents: contents)
            } onError: { error in
                self.presentErrorToast(error: .clientError)
            }
            .disposed(by: disposeBag)
        
        output.errorPublisher
            .subscribe { error in
                self.presentErrorToast(error: .clientError)
            }
            .disposed(by: disposeBag)
    }
    
    func loadTableView() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, RankTableViewCellContents>()
        snapshot.appendSections([.rank])
        dataSource.apply(snapshot)
        
        getRankTableCellContent.accept(())
    }
    
    func generateData(contents: [RankTableViewCellContents]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.rank])
        snapshot.appendItems(contents)
        dataSource.apply(snapshot)
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let yOffset = scrollView.contentOffset.y
        let heightRemainBottomHeight = contentHeight - yOffset

        let frameHeight = scrollView.frame.size.height
        if heightRemainBottomHeight < frameHeight + 300 {
            self.getRankTableCellContent.accept(())
        }
    }
    
}
