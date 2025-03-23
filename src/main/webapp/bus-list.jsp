<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.busbooking.dao.DBConnection" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Available Buses</title>
    <style>
        /* General Styling */
        body {
            font-family: Arial, sans-serif;
            background-image: url('https://source.unsplash.com/1600x900/?bus,travel'); /* Background Image */
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            margin: 0;
            padding: 0;
        }

        /* Navbar */
        .navbar {
            background: #007bff;
            padding: 15px;
            text-align: center;
            color: white;
            font-size: 22px;
            font-weight: bold;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 50px;
        }
        .nav-links {
            display: flex;
            gap: 20px;
        }
        .nav-links a {
            color: white;
            text-decoration: none;
            font-size: 18px;
            padding: 8px 15px;
            border-radius: 5px;
            transition: 0.3s;
        }
        .nav-links a:hover {
            background: rgba(255, 255, 255, 0.2);
        }
        .logout-btn {
            background: #dc3545;
            padding: 8px 15px;
            border-radius: 5px;
        }
        .logout-btn:hover {
            background: #c82333;
        }

        /* Main Container */
        .container {
            width: 90%;
            margin: auto;
            text-align: center;
            padding: 30px;
            background: rgba(255, 255, 255, 0.95);
            box-shadow: 0px 4px 20px rgba(0, 0, 0, 0.3);
            border-radius: 10px;
            margin-top: 40px;
        }

        /* Table Styling */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: white;
            border-radius: 10px;
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
            font-size: 18px;
        }
        tr:nth-child(even) {
            background: #f8f9fa;
        }
        tr:hover {
            background: #e9ecef;
        }

        /* Book Now Button */
        .book-btn {
            background: #28a745;
            color: white;
            padding: 8px 15px;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: bold;
            transition: 0.3s;
            border: none;
        }
        .book-btn:hover {
            background: #218838;
            transform: scale(1.05);
        }
        .no-buses {
            color: red;
            font-size: 18px;
            margin-top: 20px;
        }
    </style>
</head>
<body>

    <!-- Navbar -->
    <div class="navbar">
        <span>🚍 Bus Booking System</span>
        <div class="nav-links">
            <a href="index.jsp">🏠 Home</a>
            <a href="bus-list.jsp">🚆 View Buses</a>
            <a href="booking-history.jsp">📜 Booking History</a>
            <a href="LogoutServlet" class="logout-btn">🚪 Logout</a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container">
        <h2>🚌 List of Available Buses</h2>

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
                                    <a href="booking.jsp?busId=<%= rs.getInt("id") %>" class="book-btn">✅ Book Now</a>
                                <% } else { %>
                                    <span style="color: red; font-weight: bold;">❌ Fully Booked</span>
                                <% } %>
                            </td>
                        </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
            %>
                <tr>
                    <td colspan="6" style="color: red;">❌ Error fetching bus details.</td>
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
                    <td colspan="6" class="no-buses">❌ No buses available at the moment.</td>
                </tr>
            <%
                }
            %>
        </table>
    </div>

</body>
</html>
