package dao;

import bean.FavoriteBean;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import dbconnection.DBConnection;

public class FavoriteDAO {

	// Method to add a favorite item
	public boolean addFavorite(FavoriteBean favorite) {
		boolean isAdded = false;
		String query = "INSERT INTO favorite_items (userEmail, productId, itemName) VALUES (?, ?, ?)";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(query)) {
			pstmt.setString(1, favorite.getUserEmail());
			pstmt.setInt(2, favorite.getProductId());
			pstmt.setString(3, favorite.getItemName()); // Ensure this is set in FavoriteBean

			int rowsAffected = pstmt.executeUpdate();
			isAdded = rowsAffected > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return isAdded;
	}

	// Method to remove a favorite item
	public boolean removeFavorite(int itemId, String userEmail) {
		boolean result = false;
		String query = "DELETE FROM favorite_items WHERE itemId = ? AND userEmail = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(query)) {
			pstmt.setInt(1, itemId);
			pstmt.setString(2, userEmail);
			int rowsAffected = pstmt.executeUpdate();
			result = (rowsAffected > 0);
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return result;
	}

	// Method to get a list of favorite items for a user
	public List<FavoriteBean> getFavoritesByUser(String userEmail) {
		List<FavoriteBean> favorites = new ArrayList<>();
		String query = "SELECT * FROM favorite_items WHERE userEmail = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(query)) {
			pstmt.setString(1, userEmail);

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					FavoriteBean favorite = new FavoriteBean();
					favorite.setItemId(rs.getInt("itemId"));
					favorite.setUserEmail(rs.getString("userEmail"));
					favorite.setItemName(rs.getString("itemName"));
					favorite.setProductId(rs.getInt("productId"));

					favorites.add(favorite);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return favorites;
	}

	public List<Integer> getFavoriteProductIds(String userEmail) {
		List<Integer> favoriteProductIds = new ArrayList<>();
		String query = "SELECT productId FROM favorite_items WHERE userEmail = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(query)) {

			pstmt.setString(1, userEmail);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				int productId = rs.getInt("productId");
				favoriteProductIds.add(productId);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return favoriteProductIds;
	}

	public boolean isFavorite(FavoriteBean favorite) {
		boolean exists = false;
		String query = "SELECT COUNT(*) FROM favorite_items WHERE userEmail = ? AND productId = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(query)) {
			pstmt.setString(1, favorite.getUserEmail());
			pstmt.setInt(2, favorite.getProductId());

			ResultSet rs = pstmt.executeQuery();
			if (rs.next()) {
				exists = rs.getInt(1) > 0;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return exists;
	}
}
