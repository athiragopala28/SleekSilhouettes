package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import bean.Cartbean;
import dbconnection.DBConnection;

public class CartDao {

	// Check if a product exists in the cart for a specific user
	public boolean isProductInCart(int userId, int productId) throws SQLException {
		String query = "SELECT COUNT(*) FROM cart WHERE user_id = ? AND product_id = ?";
		try (Connection connection = DBConnection.getConnection();
				PreparedStatement statement = connection.prepareStatement(query)) {

			statement.setInt(1, userId);
			statement.setInt(2, productId);

			try (ResultSet resultSet = statement.executeQuery()) {
				if (resultSet.next()) {
					return resultSet.getInt(1) > 0; // Return true if the product exists in the cart
				}
			}
		}
		return false; // Return false if the product is not in the cart
	}

	// Add a product to the cart
	public boolean addProductToCart(int userId, int productId, int quantity) throws SQLException {
		if (isProductInCart(userId, productId)) {
			return updateCartQuantity(userId, productId, quantity); // Update if product exists
		}

		String query = "INSERT INTO cart (user_id, product_id, quantity, added_at) VALUES (?, ?, ?, NOW())";

		try (Connection connection = DBConnection.getConnection();
				PreparedStatement statement = connection.prepareStatement(query)) {

			statement.setInt(1, userId);
			statement.setInt(2, productId);
			statement.setInt(3, quantity);

			int rowsAffected = statement.executeUpdate();
			return rowsAffected > 0; // Return true if the insert was successful
		}
	}

	// Update the quantity of a product in the cart
	public boolean updateCartQuantity(int userId, int productId, int quantity) throws SQLException {
		String query = "UPDATE cart SET quantity = ? WHERE user_id = ? AND product_id = ?";

		try (Connection connection = DBConnection.getConnection();
				PreparedStatement statement = connection.prepareStatement(query)) {

			statement.setInt(1, quantity);
			statement.setInt(2, userId);
			statement.setInt(3, productId);

			int rowsAffected = statement.executeUpdate();
			return rowsAffected > 0; // Return true if the update was successful
		}
	}

	public List<Cartbean> getCartItemsByUserId(int userId) throws SQLException {
	    String query = "SELECT * FROM cart WHERE user_id = ?";
	    List<Cartbean> cartItems = new ArrayList<>();

	    try (Connection connection = DBConnection.getConnection();
	         PreparedStatement statement = connection.prepareStatement(query)) {

	        statement.setInt(1, userId);

	        try (ResultSet resultSet = statement.executeQuery()) {
	            while (resultSet.next()) {
	                Cartbean cartItem = new Cartbean();
	                cartItem.setId(resultSet.getInt("id"));
	                cartItem.setUserId(resultSet.getInt("user_id"));
	                cartItem.setProductId(resultSet.getInt("product_id"));
	                cartItem.setQuantity(resultSet.getInt("quantity"));
	                cartItem.setAddedAt(resultSet.getTimestamp("added_at"));

	                cartItems.add(cartItem);
	            }
	        }
	    }
	    return cartItems;
	}


	// Remove a product from the cart
	public boolean removeProductFromCart(int userId, int productId) throws SQLException {
		String query = "DELETE FROM cart WHERE user_id = ? AND product_id = ?";

		try (Connection connection = DBConnection.getConnection();
				PreparedStatement statement = connection.prepareStatement(query)) {

			statement.setInt(1, userId);
			statement.setInt(2, productId);

			int rowsAffected = statement.executeUpdate();
			return rowsAffected > 0; // Return true if the delete was successful
		}
	}

	// Clear the cart for a specific user (e.g., after checkout)
	public boolean clearCartByUserId(int userId) throws SQLException {
		String query = "DELETE FROM cart WHERE user_id = ?";

		try (Connection connection = DBConnection.getConnection();
				PreparedStatement statement = connection.prepareStatement(query)) {

			statement.setInt(1, userId);

			int rowsAffected = statement.executeUpdate();
			return rowsAffected > 0; // Return true if the cart was cleared
		}
	}

	// Get the total number of items in the cart for a specific user
	public int getCartItemCount(int userId) throws SQLException {
		String query = "SELECT COUNT(*) FROM cart WHERE user_id = ?";

		try (Connection connection = DBConnection.getConnection();
				PreparedStatement statement = connection.prepareStatement(query)) {

			statement.setInt(1, userId);

			try (ResultSet resultSet = statement.executeQuery()) {
				if (resultSet.next()) {
					return resultSet.getInt(1); // Return the count of items in the cart
				}
			}
		}
		return 0; // Return 0 if no items found
	}
}
