<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .header {
            background: #007bff;
            color: white;
            padding: 15px;
            text-align: center;
            font-size: 24px;
        }
        .container {
            width: 80%;
            margin: auto;
            text-align: center;
            padding: 20px;
            background: white;
            box-shadow: 0px 0px 10px gray;
            border-radius: 8px;
            margin-top: 50px;
        }
        .dashboard-buttons {
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
            margin-top: 20px;
        }
        .btn {
            padding: 15px 25px;
            font-size: 18px;
            text-decoration: none;
            color: white;
            background: #007bff;
            border-radius: 5px;
            margin: 10px;
            display: inline-block;
        }
        .btn:hover {
            background: #0056b3;
        }
        .logout-btn {
            background: #dc3545;
        }
        .logout-btn:hover {
            background: #c82333;
        }
    </style>
</head>
<body>

    <!-- Include Header for Navigation -->
    <jsp:include page="header.jsp" />
<%
    String userRole = (String) session.getAttribute("userRole");
    if (userRole == null || !userRole.equalsIgnoreCase("ADMIN")) {
        response.sendRedirect("login.jsp?error=Access Denied! Admins Only.");
        return;
    }
%>
    <div class="header">
        Admin Dashboard
    </div>

    <div class="container">
        <h2>Welcome, Admin</h2>

        <div class="dashboard-buttons">
            <a href="manage-buses.jsp" class="btn">🚌 Manage Buses</a>
            <a href="manage-users.jsp" class="btn">👥 Manage Users</a>
            <a href="manage-bookings.jsp" class="btn">📅 Manage Bookings</a>
            <a href="LogoutServlet" class="btn logout-btn">🚪 Logout</a>
        </div>
    </div>

</body>
</html>
