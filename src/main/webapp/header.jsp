<%@ page session="true" %>
<%
    String userRole = (String) session.getAttribute("userRole");
%>
<!DOCTYPE html>
<html>
<head>
    <style>
        .navbar {
            background: #007bff;
            padding: 10px;
            text-align: center;
        }
        .navbar a {
            color: white;
            text-decoration: none;
            padding: 10px 15px;
            font-size: 18px;
            margin: 5px;
            display: inline-block;
        }
        .navbar a:hover {
            background: #0056b3;
            border-radius: 5px;
        }
        .logout-btn {
            background: #dc3545;
            border-radius: 5px;
        }
        .logout-btn:hover {
            background: #c82333;
        }
    </style>
</head>
<body>
<div class="navbar">
    <a href="index.jsp">Home</a>
    <a href="bus-list.jsp">View Buses</a>
    <a href="booking-history.jsp">Booking History</a>

    <% if (userRole != null && userRole.equals("ADMIN")) { %>
        <a href="admin-dashboard.jsp">Admin Dashboard</a>
    <% } %>

    <a href="LogoutServlet" class="logout-btn">Logout</a>
</div>

</body>
</html>
