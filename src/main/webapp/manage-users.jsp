<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.busbooking.dao.DBConnection" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Users</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url('https://source.unsplash.com/1600x900/?people,technology');
            background-size: cover;
            background-position: center;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 90%;
            margin: auto;
            text-align: center;
            padding: 20px;
            background: rgba(255, 255, 255, 0.95);
            box-shadow: 0px 0px 10px gray;
            border-radius: 10px;
            margin-top: 30px;
        }
        .header {
            font-size: 26px;
            font-weight: bold;
            color: #333;
            text-align: center;
            padding: 20px;
            background: #007bff;
            color: white;
            border-radius: 8px 8px 0 0;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: white;
            border-radius: 5px;
            overflow: hidden;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }
        th {
            background: #007bff;
            color: white;
        }
        .block-btn, .unblock-btn {
            padding: 8px 14px;
            text-decoration: none;
            border-radius: 5px;
            display: inline-flex;
            align-items: center;
            font-size: 14px;
            transition: 0.3s;
        }
        .block-btn {
            background: #dc3545;
            color: white;
        }
        .block-btn:hover {
            background: #c82333;
            transform: scale(1.05);
        }
        .unblock-btn {
            background: #28a745;
            color: white;
        }
        .unblock-btn:hover {
            background: #218838;
            transform: scale(1.05);
        }
        .btn i {
            margin-right: 8px;
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container">
    <div class="header">Manage Users</div>
    <h2>List of Registered Users</h2>

    <table>
        <tr>
            <th>User ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Role</th>
            <th>Status</th>
            <th>Action</th>
        </tr>

        <%
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement("SELECT * FROM users ORDER BY role ASC");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int userId = rs.getInt("id");
                    String status = rs.getString("status");
        %>
                    <tr>
                        <td><%= userId %></td>
                        <td><%= rs.getString("name") %></td>
                        <td><%= rs.getString("email") %></td>
                        <td><%= rs.getString("role") %></td>
                        <td><%= status %></td>
                        <td>
                            <% if (status.equals("ACTIVE")) { %>
                                <a href="BlockUnblockUserServlet?userId=<%= userId %>&action=block" class="block-btn">❌ Block</a>
                            <% } else { %>
                                <a href="BlockUnblockUserServlet?userId=<%= userId %>&action=unblock" class="unblock-btn">✅ Unblock</a>
                            <% } %>
                        </td>
                    </tr>
        <%
                }
            }
        %>
    </table>
</div>

</body>
</html>
