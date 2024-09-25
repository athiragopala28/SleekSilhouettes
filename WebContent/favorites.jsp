<%@ page import="java.util.List"%>
<%@ page import="bean.Product"%>
<%@ page import="dao.ProductDao"%>
<%@ page import="dao.FavoriteDAO"%>

<%
	HttpSession httpsession = request.getSession(false);
	String userEmail = (String) session.getAttribute("email");

	if (session == null || userEmail == null) {
		response.sendRedirect("login.jsp");
		return;
	}

	ProductDao productDao = new ProductDao();
	FavoriteDAO favoriteDao = new FavoriteDAO();

	// Fetch all products
	List<Product> products = productDao.getAllProducts();

	// Fetch the user's favorite products
	List<Integer> favoriteProductIds = favoriteDao.getFavoriteProductIds(userEmail);
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Favorites</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
<style>
.card-custom {
	margin-bottom: 20px;
}

.btn-custom {
	width: 45px;
	height: 45px;
	display: flex;
	justify-content: center;
	align-items: center;
	margin-right: 5px;
}

.card-body {
	text-align: center;
}
</style>
</head>
<body>
	<div class="container mt-4">
		<h2 class="text-center">Your Favorite Products</h2>
		<div class="row">
			<%
				if (products == null || products.isEmpty()) {
			%>
			<p class="text-center">No products available at the moment.</p>
			<%
				} else {
			%>
			<%
				for (Product product : products) {
			%>
			<div class="col-md-4">
				<div class="card card-custom">
					<img src="<%=product.getImageUrl()%>" class="card-img-top"
						alt="Product Image" height="400px">
					<div class="card-body">
						<h5 class="card-title"><%=product.getProductName()%></h5>
						<p class="card-text">
							&#x20B9;
							<%=product.getPrice()%></p>
						<div class="d-flex justify-content-center">
							<form action="AddToFavorites.jsp" method="post"
								style="display: inline;">
								<input type="hidden" name="productId"
									value="<%=product.getId()%>">
								<%
									if (favoriteProductIds.contains(product.getId())) {
								%>
								<button type="submit" class="btn btn-danger btn-custom" disabled>
									<i class="fas fa-heart"></i>
								</button>
								<%
									} else {
								%>
								<button type="submit" class="btn btn-outline-danger btn-custom">
									<i class="fas fa-heart"></i>
								</button>
								<%
									}
								%>
							</form>
							<form action="AddToCart.jsp" method="post"
								style="display: inline;">
								<input type="hidden" name="productId"
									value="<%=product.getId()%>">
								<button type="submit" class="btn btn-outline-primary btn-custom">
									<i class="fas fa-shopping-cart"></i>
								</button>
							</form>
						</div>
					</div>
				</div>
			</div>
			<%
				}
			%>
			<%
				}
			%>
		</div>
	</div>

	<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.2/dist/umd/popper.min.js"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
