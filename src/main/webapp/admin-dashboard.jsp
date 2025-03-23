<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url('https://source.unsplash.com/1600x900/?office,technology');
            background-size: cover;
            background-position: center;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            width: 60%;
            padding: 20px;
            background: rgba(255, 255, 255, 0.9);
            box-shadow: 0px 0px 10px gray;
            border-radius: 10px;
            text-align: center;
        }
        .header {
            font-size: 26px;
            font-weight: bold;
            margin-bottom: 15px;
            color: #333;
        }
        .dashboard-buttons {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            margin-top: 20px;
        }
        .btn {
            padding: 15px 30px;
            font-size: 18px;
            text-decoration: none;
            color: white;
            background: #007bff;
            border-radius: 5px;
            margin: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 200px;
            transition: 0.3s;
            box-shadow: 2px 2px 5px rgba(0,0,0,0.2);
        }
        .btn:hover {
            background: #0056b3;
            transform: scale(1.05);
        }
        .logout-btn {
            background: #dc3545;
        }
        .logout-btn:hover {
            background: #c82333;
        }
        .btn i {
            margin-right: 10px;
            font-size: 20px;
        }
    </style>
</head>
<body>

<%
    String userRole = (String) session.getAttribute("userRole");
    if (userRole == null || !userRole.equalsIgnoreCase("ADMIN")) {
        response.sendRedirect("login.jsp?error=Access Denied! Admins Only.");
        return;
    }
%>

    <div class="container">
        <div class="header">Admin Dashboard</div>
        <h3>Welcome, Admin</h3>

        <div class="dashboard-buttons">
            <a href="manage-buses.jsp" class="btn">🚌 Manage Buses</a>
            <a href="manage-users.jsp" class="btn">👥 Manage Users</a>
            <a href="manage-bookings.jsp" class="btn">📅 Manage Bookings</a>
            <a href="LogoutServlet" class="btn logout-btn">🚪 Logout</a>
        </div>
    </div>

</body>
</html>
