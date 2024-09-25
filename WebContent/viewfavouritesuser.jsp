<%@ page import="java.util.List"%>
<%@ page import="bean.FavoriteBean"%>
<%@ page import="bean.Product"%>
<%@ page import="dao.FavoriteDAO"%>
<%@ page import="dao.ProductDao"%>
<%@ page import="javax.servlet.http.HttpSession"%>

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

	// Fetch the favorite items for the user
	FavoriteDAO favoriteDAO = new FavoriteDAO();
	List<FavoriteBean> favorites = favoriteDAO.getFavoritesByUser(userEmail);
	ProductDao productDao = new ProductDao();
%>

<!-- View Favorite User Section Start -->
<div class="container mt-4 text-center">
	<h2 class="mb-4">Your Favorite Products</h2>
	<div class="table-responsive">
		<table class="table table-bordered table-hover">
			<thead class="table-light">
				<tr>
					<th>Image</th>
					<th>Product Name</th>
					<th>Price</th>
					<th>Actions</th>
				</tr>
			</thead>
			<tbody>
				<%
					if (favorites.isEmpty()) {
				%>
				<tr>
					<td colspan="4" class="text-center">You have no favorite
						products yet.</td>
				</tr>
				<%
					} else {
						for (FavoriteBean favorite : favorites) {
							Product product = productDao.getProductById(favorite.getProductId());
							if (product != null) {
				%>
				<tr>
					<td><img src="<%=product.getImageUrl()%>" alt="Product Image"
						class="img-fluid"
						style="max-height: 100px; max-width: 100px; object-fit: cover;">
					</td>
					<td><%=product.getProductName()%></td>
					<td>&#x20B9; <%=String.format("%.2f", (double) product.getPrice())%></td>
					<td><a
						href="AddToCart.jsp?productId=<%=product.getId()%>&quantity=1"
						class="btn btn-light-blue btn-sm"> <i
							class="fas fa-shopping-cart"></i> Add to Cart
					</a> <a href="removeFavorite.jsp?itemId=<%=favorite.getItemId()%>"
						class="btn btn-light-blue btn-sm"> <i class="fas fa-trash"></i>
							Remove
					</a></td>
				</tr>
				<%
					}
						}
					}
				%>
			</tbody>
		</table>
	</div>
</div>
<!-- View Favorite User Section End -->

<style>
body {
	background-color: #f8f9fa; /* Light background color */
}

.container {
	max-width: 1200px; /* Maximum width for the container */
	margin: auto; /* Center the container */
}

.table {
	background-color: white; /* Background for the table */
	width: 100%; /* Full width */
}

.table th, .table td {
	vertical-align: middle; /* Center align text vertically */
	padding: 15px; /* Increased padding for height */
}

.table-light {
	background-color: #f8f9fa; /* Light background for table header */
}

.text-center {
	margin-bottom: 20px; /* Space below the heading */
}

.table-responsive {
	overflow-x: auto; /* Allow horizontal scrolling on smaller screens */
}

/* Light blue button styles */
.btn-light-blue {
	background-color: #add8e6; /* Light blue background */
	color: #000; /* Dark text color */
	border: none; /* No border */
}

.btn-light-blue:hover {
	background-color: #87ceeb; /* Lighter blue on hover */
	color: #fff; /* White text on hover */
}
</style>
