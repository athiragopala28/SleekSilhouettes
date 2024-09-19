<%@ page import="dao.CartDao" %>
<%@ page import="bean.Cartbean" %>
<%@ page import="dbconnection.DBConnection" %>
<%@ page import="java.util.List" %>


<%
    // Check if userId is present in the session
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        // Redirect to login page if user is not logged in
        response.sendRedirect("login.jsp");
        return;
    }

    CartDao cartDao = new CartDao();
    List<Cartbean> cartItems = cartDao.getCartItemsByUserId(userId);
%>
<%
	HttpSession httpsession = request.getSession(false);
	if (session != null) {
		String userEmail = (String) session.getAttribute("email");
		String userRole = (String) session.getAttribute("role");

		if (userEmail != null && userRole != null) {
			// Set the content type of the response
			/*  response.setContentType("text/html");
			
			 // Write the response content
			 response.getWriter().println("<html><body>");
			 response.getWriter().println("<h1>Welcome to the Dashboard</h1>");
			 response.getWriter().println("<p>Email: " + userEmail + "</p>");
			 response.getWriter().println("<p>Role: " + userRole + "</p>");
			 response.getWriter().println("</body></html>"); */
		} else {
			// Redirect to login page if user is not logged in
			response.sendRedirect("login.jsp");
		}
	} else {
		// Redirect to login page if session is null
		response.sendRedirect("login.jsp");
	}
%>
<!DOCTYPE html>
<html>
<head>
    <title>Cart</title>
</head>
<body>
    <h1>Your Cart</h1>
    <table border="1">
        <thead>
            <tr>
                <th>Product Name</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Total</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <% if (cartItems != null && !cartItems.isEmpty()) { %>
                <% for (Cartbean item : cartItems) { %>
                    <tr>
                        <td><%= item.getId() %></td>
                        <td><%= item.getProductId() %></td>
                        <td><%= item.getQuantity() %></td>
                        <td><%= item.getUserId() * item.getQuantity() %></td>
                        <td>
                            <a href="UpdateCart.jsp?productId=<%= item.getProductId() %>">Update</a>
                            <a href="DeleteCart.jsp?productId=<%= item.getProductId() %>">Remove</a>
                        </td>
                    </tr>
                <% } %>
            <% } else { %>
                <tr>
                    <td colspan="5">Your cart is empty.</td>
                </tr>
            <% } %>
        </tbody>
    </table>
    <a href="userdashboard.jsp">Back to Dashboard</a>
</body>
</html>
