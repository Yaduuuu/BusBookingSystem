<%@ page import="java.sql.*, com.busbooking.dao.DBConnection" %>
<%@ page session="true" %>

<%
    int busId = Integer.parseInt(request.getParameter("busId"));
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    int totalSeats = 40; // Change based on bus type

    boolean[] bookedSeats = new boolean[totalSeats + 1]; // Array to track booked seats

    try {
        conn = DBConnection.getConnection();
        String query = "SELECT seat_number FROM bookings WHERE bus_id=?";
        ps = conn.prepareStatement(query);
        ps.setInt(1, busId);
        rs = ps.executeQuery();

        while (rs.next()) {
            bookedSeats[rs.getInt("seat_number")] = true; // Mark booked seats
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Select Seat</title>
    <style>
        .seat {
            width: 40px;
            height: 40px;
            margin: 5px;
            display: inline-block;
            text-align: center;
            line-height: 40px;
            font-weight: bold;
            border-radius: 5px;
            cursor: pointer;
        }
        .available { background-color: green; color: white; }
        .booked { background-color: red; color: white; cursor: not-allowed; }
        .selected { background-color: blue; color: white; }
    </style>
    <script>
        function selectSeat(seat) {
            if (seat.classList.contains("booked")) return;
            document.getElementById("seatInput").value = seat.innerText;
            document.querySelectorAll(".seat").forEach(s => s.classList.remove("selected"));
            seat.classList.add("selected");
        }
    </script>
</head>
<body>

<h2>Select a Seat</h2>
<form action="BookBusServlet" method="post">
    <input type="hidden" name="busId" value="<%= busId %>">
    <input type="hidden" id="seatInput" name="seatNumber" required>

    <div>
        <% for (int i = 1; i <= totalSeats; i++) { %>
            <div class="seat <%= bookedSeats[i] ? "booked" : "available" %>" onclick="selectSeat(this)">
                <%= i %>
            </div>
            <% if (i % 4 == 0) { %> <br> <% } // New row every 4 seats %>
        <% } %>
    </div>

    <button type="submit">Confirm Booking</button>
</form>

</body>
</html>
