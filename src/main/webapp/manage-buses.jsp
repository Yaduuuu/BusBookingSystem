<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.busbooking.dao.DBConnection" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Buses</title>
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
        .edit-btn {
            background: #ffc107;
            color: black;
            padding: 7px 12px;
            text-decoration: none;
            border-radius: 5px;
        }
        .edit-btn:hover {
            background: #e0a800;
        }
        .delete-btn {
            background: #dc3545;
            color: white;
            padding: 7px 12px;
            text-decoration: none;
            border-radius: 5px;
        }
        .delete-btn:hover {
            background: #c82333;
        }
        .add-bus-btn {
            background: #28a745;
            color: white;
            padding: 10px 15px;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
        }
        .add-bus-btn:hover {
            background: #218838;
        }
        .top-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>

    <!-- Header -->
    <jsp:include page="header.jsp" />

    <div class="header">
        Manage Buses
    </div>

    <div class="container">
        <div class="top-actions">
            <h2>List of All Buses</h2>
            <a href="add-bus.jsp" class="add-bus-btn">➕ Add New Bus</a>
        </div>

        <table>
            <tr>
                <th>Bus Name</th>
                <th>Source</th>
                <th>Destination</th>
                <th>Seats Available</th>
                <th>Departure Time</th>
                <th>Actions</th>
            </tr>

            <%
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                boolean busesFound = false;

                try {
                    conn = DBConnection.getConnection();
                    String query = "SELECT * FROM buses ORDER BY departure_time ASC";
                    ps = conn.prepareStatement(query);
                    rs = ps.executeQuery();

                    while (rs.next()) {
                        busesFound = true;
            %>
                        <tr>
                            <td><%= rs.getString("bus_name") %></td>
                            <td><%= rs.getString("source") %></td>
                            <td><%= rs.getString("destination") %></td>
                            <td><%= rs.getInt("available_seats") %></td>
                            <td><%= rs.getTimestamp("departure_time") %></td>
                            <td>
                                <a href="edit-bus.jsp?busId=<%= rs.getInt("id") %>" class="edit-btn">✏️ Edit</a>
                                <a href="DeleteBusServlet?busId=<%= rs.getInt("id") %>" class="delete-btn"
                                   onclick="return confirm('Are you sure you want to delete this bus?');">🗑 Delete</a>
                            </td>
                        </tr>
            <%
                    }
                    if (!busesFound) {
            %>
                        <tr>
                            <td colspan="6" style="color: red;">No buses found.</td>
                        </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
            %>
                <tr>
                    <td colspan="6" style="color: red;">Error fetching bus details.</td>
                </tr>
            <%
                } finally {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                }
            %>
        </table>
    </div>

</body>
</html>
