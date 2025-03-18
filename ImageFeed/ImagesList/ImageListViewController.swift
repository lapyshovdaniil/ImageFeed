//
//  ViewController.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 20.12.2024.
//

import UIKit
import Kingfisher

final class ImageListViewController: UIViewController {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    
    private let imagesListService = ImagesListService.shared
    private var ImagesListServiceObserver: NSObjectProtocol?
    
    @IBOutlet private var tableView: UITableView!
    
    var photos: [Photo] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.dateFormat = "dd MMMM y"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(
            top: 12, left: 0, bottom: 12, right: 0)
        ImagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification, object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            self.updateTableViewAnimated()
        }
        imagesListService.fetchPhotosNextPage()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination
                    as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            let imageURL = photos[indexPath.row].largeImageURL
            viewController.imageURL = imageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func updateTableViewAnimated(){
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        print("\(photos)Фоток")
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

extension ImageListViewController {
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath)
    {
        guard indexPath.row < photos.count else {
            return
        }
        let photo = photos[indexPath.row]
        if let imageURL = URL(string: photo.thumbImageURL) {
            cell.imageCell.kf.indicatorType = .activity
            cell.imageCell.kf.setImage(with: imageURL, placeholder: UIImage(named: "Stub_placeholder")) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let value):
                    if cell.imageCell.image != value.image {
                        cell.imageCell.image = value.image
                        DispatchQueue.main.async {
                            self.tableView.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                case .failure(let error):
                    print("Error loading image: \(error)")
                }
            }
        } else {
            cell.imageCell.image = UIImage(named: "placeholder")
        }
        cell.dateLabel.text = photo.createdAt.map { dateFormatter.string(from: $0) } ?? ""
        cell.isLiked = photo.isLiked
    }
}
extension ImageListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        performSegue(
            withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    
    func tableView(
        _ tableView: UITableView, heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        let photo = photos[indexPath.row]
        let imageWidth = photo.size.width
        let imageHeight = photo.size.height
        guard imageWidth > 0 && imageHeight > 0 else {
            return 100
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageHeight * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
    -> Int
    {
        print(photos.count)
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        imageListCell.delegate = self
        return imageListCell
    }
}
extension ImageListViewController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            imagesListService.fetchPhotosNextPage()
        }
    }
}
extension ImageListViewController: ImageListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        print("Текущее состояние лайка у фото \(photo.id): \(photo.isLiked)")
        let newLikeState = !photo.isLiked
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: newLikeState) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.photos = self.imagesListService.photos
                    cell.setIsLike(isLiked: self.photos[indexPath.row].isLiked)
                    UIBlockingProgressHUD.dismiss()
                    // Обновляем UI
                case .failure(let error):
                    UIBlockingProgressHUD.dismiss()
                    print("Ошибка изменения лайка: \(error)")
                }
            }
        }
    }
}
