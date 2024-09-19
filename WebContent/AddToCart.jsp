<%@ page import="dao.CartDao"%>
<%@ page import="bean.Cartbean"%>
<%@ page import="dbconnection.DBConnection"%>
<%@ page import="java.util.List"%>

<%
	// Check if userId is present in the session
	Integer userId = (Integer) session.getAttribute("userId");
	if (userId == null) {
		// Redirect to login page if user is not logged in
		response.sendRedirect("login.jsp");
		return;
	}

	// Retrieve parameters safely
	String productIdParam = request.getParameter("productId");
	String quantityParam = request.getParameter("quantity");

	if (productIdParam == null || quantityParam == null) {
		out.println("Missing productId or quantity parameter.");
		return;
	}

	int productId;
	int quantity;

	try {
		productId = Integer.parseInt(productIdParam);
		quantity = Integer.parseInt(quantityParam);
	} catch (NumberFormatException e) {
		out.println("Invalid productId or quantity format.");
		return;
	}

	// Add product to cart
	CartDao cartDao = new CartDao();
	boolean success = cartDao.addProductToCart(userId, productId, quantity); // Ensure you handle product name and price

	if (success) {
		response.sendRedirect("Cart.jsp");
	} else {
		out.println("Failed to add product to cart.");
	}
%>

<!DOCTYPE html>
<html>
<head>
<title>Add to Cart</title>
</head>
<body>
	<h1>Add Product to Cart</h1>
	<form method="post">
		<label>Product ID:</label> <input type="text" name="productId"
			required /><br /> <label>Quantity:</label> <input type="number"
			name="quantity" min="1" required /><br /> <input type="submit"
			value="Add to Cart" />
	</form>
	<a href="Cart.jsp">Back to Cart</a>
</body>
</html>
