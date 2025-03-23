<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.busbooking.dao.DBConnection" %>
<%@ page session="true" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp?error=Please login to book a bus.");
        return;
    }

    int busId = Integer.parseInt(request.getParameter("busId"));
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String busName = "", source = "", destination = "";
    int availableSeats = 0;
    Timestamp departureTime = null;

    try {
        conn = DBConnection.getConnection();
        ps = conn.prepareStatement("SELECT * FROM buses WHERE id = ?");
        ps.setInt(1, busId);
        rs = ps.executeQuery();

        if (rs.next()) {
            busName = rs.getString("bus_name");
            source = rs.getString("source");
            destination = rs.getString("destination");
            availableSeats = rs.getInt("available_seats");
            departureTime = rs.getTimestamp("departure_time");
        }
        rs.close();
        ps.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Select Your Seat</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url('https://source.unsplash.com/1600x900/?bus,travel'); /* Random bus-related image */
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
            width: 50%;
            padding: 20px;
            background: rgba(255, 255, 255, 0.9);
            box-shadow: 0px 0px 10px gray;
            border-radius: 10px;
            text-align: center;
        }
        .header {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .seat-layout {
            display: grid;
            grid-template-columns: repeat(5, 50px);
            gap: 10px;
            justify-content: center;
            margin-top: 20px;
        }
        .seat {
            width: 45px;
            height: 45px;
            border-radius: 5px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.2s;
        }
        .available { background-color: green; color: white; }
        .booked { background-color: red; color: white; cursor: not-allowed; }
        .selected { background-color: blue !important; color: white; }
        .confirm-btn {
            background: #28a745;
            color: white;
            padding: 12px 20px;
            font-size: 16px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            margin-top: 20px;
            transition: 0.3s;
        }
        .confirm-btn:disabled {
            background: gray;
            cursor: not-allowed;
        }
    </style>
    <script>
        function selectSeat(seatNumber) {
            let seat = document.getElementById("seat" + seatNumber);
            let inputField = document.getElementById("selectedSeat");

            if (seat.classList.contains("booked")) return;

            document.querySelectorAll(".seat").forEach(s => s.classList.remove("selected"));
            seat.classList.add("selected");
            inputField.value = seatNumber;
            
            document.getElementById("confirmButton").disabled = false;
        }
    </script>
</head>
<body>

    <div class="container">
        <div class="header">Select Your Seat for <%= busName %></div>

        <p><strong>From:</strong> <%= source %> → <strong>To:</strong> <%= destination %></p>
        <p><strong>Seats Available:</strong> <%= availableSeats %></p>
        <p><strong>Departure Time:</strong> <%= departureTime %></p>

        <h3>Select Your Seat</h3>
        <div class="seat-layout">
            <% 
                try {
                    conn = DBConnection.getConnection();
                    ps = conn.prepareStatement("SELECT seat_number FROM bookings WHERE bus_id = ? AND status = 'CONFIRMED'");
                    ps.setInt(1, busId);
                    rs = ps.executeQuery();

                    java.util.Set<Integer> bookedSeats = new java.util.HashSet<>();
                    while (rs.next()) {
                        bookedSeats.add(rs.getInt("seat_number"));
                    }
                    rs.close();
                    ps.close();

                    for (int i = 1; i <= 40; i++) {
                        boolean isBooked = bookedSeats.contains(i);
            %>
                        <div class="seat <%= isBooked ? "booked" : "available" %>" id="seat<%= i %>" onclick="selectSeat(<%= i %>)">
                            <%= i %>
                        </div>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (conn != null) conn.close();
                }
            %>
        </div>

        <form action="BookBusServlet" method="post">
            <input type="hidden" name="busId" value="<%= busId %>">
            <input type="hidden" name="seatNumber" id="selectedSeat" required>
            <button type="submit" class="confirm-btn" id="confirmButton" disabled>Confirm Booking</button>
        </form>
    </div>

</body>
</html>
