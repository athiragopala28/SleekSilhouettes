<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="dao.*"%>
<%@ page import="bean.*"%>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>
<%@ page import="javax.servlet.http.HttpSession"%>

<%
	// Retrieving parameters from the request
	String email = request.getParameter("email");
	String password = request.getParameter("password");

	// Message variable for alerts
	String message = "";
	HttpSession httpsession = null; // Declare session

	if (email != null && password != null) {
		try {
			// Initialize UserDao and retrieve the user by email
			UserDao userDao = new UserDao();
			User user = userDao.getUserByEmail(email);

			// Check if it's admin login
			if ("admin@gmail.com".equals(email) && "Admin123@".equals(password)) {
				httpsession = request.getSession(); // Initialize session
				httpsession.setAttribute("email", email);
				httpsession.setAttribute("role", "admin");

				// Success alert and redirect to admin dashboard
				out.print("<script type='text/javascript'>");
				out.print("alert('Successfully logged in as admin');");
				out.print("window.location.href = 'admindashboard.jsp';");
				out.print("</script>");
			}
			// If user is found and password matches
			else if (user != null && BCrypt.checkpw(password, user.getPassword())) {
				httpsession = request.getSession(); // Initialize session
				httpsession.setAttribute("email", email);
				httpsession.setAttribute("role", "user");

				// Success alert and redirect to user dashboard
				out.print("<script type='text/javascript'>");
				out.print("alert('Successfully logged in as user');");
				out.print("window.location.href = 'userdashboard.jsp';");
				out.print("</script>");
			}
			// If login fails
			else {
				message = "Incorrect details | User not registered";
				out.print("<script type='text/javascript'>");
				out.print("alert('" + message + "');");
				out.print("window.location.href = 'register.jsp';");
				out.print("</script>");
			}
		} catch (Exception e) {
			e.printStackTrace(); // For debugging
			out.print("<script type='text/javascript'>");
			out.print("alert('An error occurred. Please try again.');");
			out.print("window.location.href = 'login.jsp';");
			out.print("</script>");
		}
	} else {
		// Handling case where email or password is missing
		out.print("<script type='text/javascript'>");
		out.print("alert('Email and Password are required.');");
		out.print("window.location.href = 'login.jsp';");
		out.print("</script>");
	}
%>
