package dao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import bean.Order;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import dbconnection.DBConnection;
import bean.*;


public class OrderDao {
    public boolean saveOrder(Order order) {
        boolean isSaved = false;
        String query = "INSERT INTO orders (paymentId, userEmail, totalAmount, status) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, order.getPaymentId());
            pstmt.setString(2, order.getUserEmail());
            pstmt.setDouble(3, order.getTotalAmount());
            pstmt.setString(4, order.getStatus());

            int rowsAffected = pstmt.executeUpdate();
            isSaved = rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return isSaved;
    }
  
        // Your existing code...

        public int getOrderCount() throws SQLException {
            int orderCount = 0;
            String query = "SELECT COUNT(*) FROM orders"; // Replace 'orders' with your actual orders table name

            // Ensure you have a method to get a connection to your database
            try (Connection conn = DBConnection.getConnection();
                    PreparedStatement pstmt = conn.prepareStatement(query);
                 ResultSet rs = pstmt.executeQuery()) {

                if (rs.next()) {
                    orderCount = rs.getInt(1);
                }
            } catch (SQLException e) {
                e.printStackTrace();
                throw e; // Re-throw to handle it at the JSP level if necessary
            }
            return orderCount;
        }
    }


