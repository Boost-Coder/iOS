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
    private let getMyInformation = PublishRelay<Void>()
    private let cellSelected = PublishRelay<Int>()
    
    private let disposeBag = DisposeBag()
    
    private lazy var myRankView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.sejongPrimary.cgColor
        view.layer.borderWidth = 1
        
        return view
    }()
    
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
        label.textColor = .black
        label.font = .pretendard(type: .semiBold, size: 24)
        
        return label
    }()
    
    private let myNicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .pretendard(type: .bold, size: 15)
        
        return label
    }()
    
    private let myScoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .pretendard(type: .regular, size: 13)
        
        return label
    }()
    
    private let divideView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        
        return view
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        view.addSubview(myRankView)
        view.addSubview(divideView)
        myRankView.addSubview(myRankLabel)
        myRankView.addSubview(myNicknameLabel)
        myRankView.addSubview(myScoreLabel)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            myRankView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            myRankView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myRankView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 52),
            myRankView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -52),
            myRankView.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        NSLayoutConstraint.activate([
            myRankLabel.centerYAnchor.constraint(equalTo: myRankView.centerYAnchor),
            myRankLabel.leadingAnchor.constraint(equalTo: myRankView.leadingAnchor, constant: 14),
            myRankLabel.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            myNicknameLabel.centerYAnchor.constraint(equalTo: myRankView.centerYAnchor),
            myNicknameLabel.leadingAnchor.constraint(equalTo: myRankLabel.trailingAnchor, constant: 22),
            myNicknameLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            myScoreLabel.centerYAnchor.constraint(equalTo: myRankView.centerYAnchor),
            myScoreLabel.trailingAnchor.constraint(equalTo: myRankView.trailingAnchor),
            myScoreLabel.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            divideView.topAnchor.constraint(equalTo: myRankView.bottomAnchor, constant: 20),
            divideView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            divideView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            divideView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        NSLayoutConstraint.activate([
            rankTableView.topAnchor.constraint(equalTo: divideView.bottomAnchor),
            rankTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            rankTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            rankTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ])
    }
    
    func bind() {
        let output = viewModel.transform(
            input: HomeViewModelInput(
                getRankTableCellContent: getRankTableCellContent,
                getMyInformation: getMyInformation, 
                cellSelected: cellSelected
            )
        )
        
        output.fetchRankListComplete
            .subscribe { contents in
                self.generateData(contents: contents)
            } onError: { error in
                self.presentErrorToast(error: .clientError)
            }
            .disposed(by: disposeBag)
        
        output.getMyRank
            .subscribe { rank in
                self.myRankLabel.text = rank.total
                self.myNicknameLabel.text = rank.nickname
                self.myScoreLabel.text = rank.totalScore
            } onError: { error in
                self.presentErrorToast(error: .clientError)
            }
            .disposed(by: disposeBag)
        
        output.versusRank
            .subscribe { content in
                let compareViewController = CompareViewController(content: content)
                self.present(compareViewController, animated: false)
                dump(content)
            } onError: { error in
                dump(error)
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
        dataSource.apply(snapshot, animatingDifferences: false)
        
        getRankTableCellContent.accept(())
        getMyInformation.accept(())
    }
    
    func generateData(contents: [RankTableViewCellContents]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.rank])
        snapshot.appendItems(contents)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let yOffset = scrollView.contentOffset.y
        let heightRemainBottomHeight = contentHeight - yOffset

        let frameHeight = scrollView.frame.size.height
        if heightRemainBottomHeight < frameHeight + 500 {
            self.getRankTableCellContent.accept(())
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.cellSelected.accept(indexPath.row)
    }
    
}
