<%@ page import="dao.FavoriteDAO"%>
<%@ page import="javax.servlet.http.HttpSession"%>

<%
	HttpSession httpsession = request.getSession(false);
	String userEmail = null;
	String itemIdStr = request.getParameter("itemId");

	if (session != null) {
		userEmail = (String) session.getAttribute("email");

		if (userEmail == null) {
			response.sendRedirect("login.jsp");
			return;
		}
	} else {
		response.sendRedirect("login.jsp");
		return;
	}

	if (itemIdStr == null) {
		out.print("<script>alert('Invalid request.'); window.location.href='favorites.jsp';</script>");
		return;
	}

	int itemId = 0;
	try {
		itemId = Integer.parseInt(itemIdStr);
	} catch (NumberFormatException e) {
		out.print("<script>alert('Invalid item ID.'); window.location.href='favorites.jsp';</script>");
		return;
	}

	FavoriteDAO favoriteDAO = new FavoriteDAO();
	boolean isRemoved = favoriteDAO.removeFavorite(itemId, userEmail); // Implement this method in FavoriteDAO

	if (isRemoved) {
		out.print(
				"<script>alert('Product removed from favorites successfully!'); window.location.href='favorites.jsp';</script>");
	} else {
		out.print(
				"<script>alert('Failed to remove product from favorites.'); window.location.href='favorites.jsp';</script>");
	}
%>
