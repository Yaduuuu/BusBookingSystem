<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.busbooking.dao.DBConnection" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Available Buses</title>
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
        .book-btn {
            background: #28a745;
            color: white;
            padding: 7px 12px;
            text-decoration: none;
            border-radius: 5px;
        }
        .book-btn:hover {
            background: #218838;
        }
        .no-buses {
            color: red;
            font-size: 18px;
            margin-top: 20px;
        }
    </style>
</head>
<body>

    <!-- Include Header -->
    <jsp:include page="header.jsp" />

    <div class="header">
        Available Buses
    </div>

    <div class="container">
        <h2>List of Available Buses</h2>

        <table>
            <tr>
                <th>Bus Name</th>
                <th>Source</th>
                <th>Destination</th>
                <th>Seats Available</th>
                <th>Departure Time</th>
                <th>Action</th>
            </tr>

            <%
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                boolean busesFound = false;

                try {
                    conn = DBConnection.getConnection();
                    String query = "SELECT * FROM buses WHERE available_seats > 0 ORDER BY departure_time ASC";
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
                                <% if (rs.getInt("available_seats") > 0) { %>
                                    <a href="booking.jsp?busId=<%= rs.getInt("id") %>" class="book-btn">Book Now</a>
                                <% } else { %>
                                    <span style="color: red;">Fully Booked</span>
                                <% } %>
                            </td>
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

                if (!busesFound) {
            %>
                <tr>
                    <td colspan="6" class="no-buses">No buses available at the moment.</td>
                </tr>
            <%
                }
            %>
        </table>
    </div>

</body>
</html>
