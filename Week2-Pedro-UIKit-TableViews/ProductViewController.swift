//
//  ViewController.swift
//  Week2-Pedro-UIKit-TableViews
//
//  Created by Christian Leovido on 11/10/2020.
//

import UIKit
import SwiftUI

// SwiftUI -> UIKit through the UIHostingController
//struct NewProductView: View {
//
//	let models = ["One", "two"]()
//
//	var body: some View {
//		VStack {
//			List(models) { model in
//				Text(model.text)
//			}
//			Button()
//		}
//		.onAppear {
//			// fetch all models....
//		}
//	}
//
//}

protocol Quantifiable {
	var quantity: Int { get }
	// this makes the property immutable with a getter only.
}

struct Product: Quantifiable {
	let quantity: Int
}

// Two options:
/// 		1. UIViewController - doesn't have a `tableView`
///			2. UITableViewController - has a default `tableView`

final class ProductViewController: UIViewController {

	var dataSource: [Product] = []

	var tableView: UITableView!

	// ... here you declare the other views that you want.
	// some label
	// some buttons
	// etc.

	override func viewDidLoad() {
		super.viewDidLoad()

		// 1. Set the tableView
		tableView = UITableView()

		// 2. Register a custom UITableViewCell
		tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.id) // <---- VERY IMPORTANT

		// 3. add the tableView to the subView
		view.addSubview(tableView)

		// 4. Do the setup for the tableView
		setupTableView()

		// 5.
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
			tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
		])

		// 6. Set the delegate and dataSource to self
		tableView.delegate = self
		tableView.dataSource = self

	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		fetchDataSource(completion: { products in
			self.dataSource = products
			self.tableView.reloadData()
		})

	}

	func setupTableView() {
		tableView.backgroundColor = .blue
		tableView.translatesAutoresizingMaskIntoConstraints = false
	}

	func fetchDataSource(completion: ([Product]) -> Void) {

		completion([Product(quantity: Int.random(in: 1...1_000))])

	}
}


// these extensions are required to make the UITableView work.
extension ProductViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		dataSource.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.id, for: indexPath) as? ProductCell else {
			fatalError("ProductCell not implemented")
		}

		cell.configureCell(product: dataSource[indexPath.row])

		return cell

	}

}

extension ProductViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

	}

}

final class ProductCell: UITableViewCell {

	static let id = "ProductCell"

	private var quantityLabel: UILabel!

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		// 1. Instantiate the UILabel
		quantityLabel = UILabel()
		addSubview(quantityLabel)

		// 2. setup the properties for the UILabel
		quantityLabel.backgroundColor = .red
		quantityLabel.translatesAutoresizingMaskIntoConstraints = false // <--- VERY IMPORTANT

		// 3. Activate the constraints.
		NSLayoutConstraint.activate([
			quantityLabel.topAnchor.constraint(equalTo: topAnchor),
			quantityLabel.leftAnchor.constraint(equalTo: leftAnchor),
			quantityLabel.rightAnchor.constraint(equalTo: rightAnchor),
			quantityLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
			quantityLabel.widthAnchor.constraint(equalToConstant: 200),
			quantityLabel.heightAnchor.constraint(equalToConstant: 60)
		])

	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configureCell(product: Product) {
		quantityLabel.text = product.quantity.description
	}

}
