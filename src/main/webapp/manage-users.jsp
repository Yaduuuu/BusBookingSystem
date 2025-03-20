<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.busbooking.dao.DBConnection" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Users</title>
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
            width: 90%;
            margin: auto;
            text-align: center;
            padding: 20px;
            background: white;
            box-shadow: 0px 0px 10px gray;
            border-radius: 8px;
            margin-top: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: white;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ccc;
            text-align: center;
        }
        th {
            background: #007bff;
            color: white;
        }
        .block-btn {
            background: #dc3545;
            color: white;
            padding: 7px 12px;
            text-decoration: none;
            border-radius: 5px;
        }
        .block-btn:hover {
            background: #c82333;
        }
        .unblock-btn {
            background: #28a745;
            color: white;
            padding: 7px 12px;
            text-decoration: none;
            border-radius: 5px;
        }
        .unblock-btn:hover {
            background: #218838;
        }
    </style>
</head>
<body>
<jsp:include page="header.jsp" />
    <!-- Header -->
    <div class="header">
        Manage Users
    </div>

    <div class="container">
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
                                <% if (rs.getString("status").equals("ACTIVE")) { %>
                                    <a href="BlockUnblockUserServlet?userId=<%= rs.getInt("id") %>&action=block" class="block-btn">Block</a>
                                <% } else { %>
                                    <a href="BlockUnblockUserServlet?userId=<%= rs.getInt("id") %>&action=unblock" class="unblock-btn">Unblock</a>
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
