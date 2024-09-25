<%@ page import="dao.FavoriteDAO"%>
<%@ page import="bean.FavoriteBean"%>
<%@ page import="bean.Product"%>
<%@ page import="dao.ProductDao"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.IOException"%>

<%
	HttpSession httpsession = request.getSession(false);
	String userEmail = null;

	if (httpsession != null) {
		userEmail = (String) httpsession.getAttribute("email");

		if (userEmail == null) {
			response.sendRedirect("login.jsp");
			return;
		}
	} else {
		response.sendRedirect("login.jsp");
		return;
	}

	String productId = request.getParameter("productId");

	// Validate product input
	if (productId == null) {
		out.print("<script>alert('Invalid product.'); window.location.href='index.jsp';</script>");
		return;
	}

	ProductDao productDao = new ProductDao();
	Product product = productDao.getProductById(Integer.parseInt(productId));

	if (product != null) {
		FavoriteDAO favoriteDao = new FavoriteDAO();
		FavoriteBean favoriteItem = new FavoriteBean();
		favoriteItem.setUserEmail(userEmail);
		favoriteItem.setProductId(Integer.parseInt(productId));
		favoriteItem.setItemName(product.getProductName()); // Set item name

		boolean added = favoriteDao.addFavorite(favoriteItem); // Add to favorites

		if (added) {
			out.print(
					"<script>alert('Product added to favorites successfully!'); window.location.href='favorites.jsp';</script>");
		} else {
			out.print(
					"<script>alert('Failed to add product to favorites.'); window.location.href='index.jsp';</script>");
		}
	} else {
		out.print("<script>alert('Product not found.'); window.location.href='index.jsp';</script>");
	}
%>
