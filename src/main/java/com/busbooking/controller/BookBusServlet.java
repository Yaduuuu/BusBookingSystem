package com.busbooking.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.busbooking.dao.DBConnection;
import com.busbooking.utils.EmailUtil;

@WebServlet("/BookBusServlet")
public class BookBusServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?error=Please login to book a bus.");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String userEmail = (String) session.getAttribute("userEmail");

        // ✅ Validate `busId` and `seatNumber`
        String busIdParam = request.getParameter("busId");
        String seatNumberParam = request.getParameter("seatNumber");

        if (busIdParam == null || busIdParam.trim().isEmpty() || seatNumberParam == null || seatNumberParam.trim().isEmpty()) {
            response.sendRedirect("bus-list.jsp?error=Invalid Bus ID or Seat Number.");
            return;
        }

        int busId = Integer.parseInt(busIdParam);
        int seatNumber = Integer.parseInt(seatNumberParam);

        Connection conn = null;
        PreparedStatement psCheckSeats = null, psBook = null, psUpdateSeats = null, psUpdateSeatStatus = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Check if the seat is still available
            String checkSeatQuery = "SELECT available_seats, bus_name, source, destination, departure_time FROM buses WHERE id=?";
            psCheckSeats = conn.prepareStatement(checkSeatQuery);
            psCheckSeats.setInt(1, busId);
            rs = psCheckSeats.executeQuery();

            if (rs.next() && rs.getInt("available_seats") > 0) {
                String busName = rs.getString("bus_name");
                String source = rs.getString("source");
                String destination = rs.getString("destination");
                Timestamp departureTime = rs.getTimestamp("departure_time");

                // Deduct one seat
                String updateSeatsQuery = "UPDATE buses SET available_seats = available_seats - 1 WHERE id=?";
                psUpdateSeats = conn.prepareStatement(updateSeatsQuery);
                psUpdateSeats.setInt(1, busId);
                psUpdateSeats.executeUpdate();

                // ✅ Mark seat as "BOOKED" in the `seats` table
                String updateSeatStatusQuery = "UPDATE seats SET status='BOOKED' WHERE bus_id=? AND seat_number=?";
                psUpdateSeatStatus = conn.prepareStatement(updateSeatStatusQuery);
                psUpdateSeatStatus.setInt(1, busId);
                psUpdateSeatStatus.setInt(2, seatNumber);
                psUpdateSeatStatus.executeUpdate();

                // Insert booking record with seat number
                String bookQuery = "INSERT INTO bookings (user_id, bus_id, seat_number, booking_time, status) VALUES (?, ?, ?, ?, 'CONFIRMED')";
                psBook = conn.prepareStatement(bookQuery);
                psBook.setInt(1, userId);
                psBook.setInt(2, busId);
                psBook.setInt(3, seatNumber);
                psBook.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
                psBook.executeUpdate();

                conn.commit();

                // Prepare email details with seat number
                String subject = "Bus Ticket Booking Confirmation";
                String messageBody = "Dear User,\n\nYour bus ticket has been successfully booked!\n\n" +
                        "Bus: " + busName + "\n" +
                        "From: " + source + "\n" +
                        "To: " + destination + "\n" +
                        "Seat Number: " + seatNumber + "\n" +
                        "Departure: " + departureTime + "\n\n" +
                        "Thank you for choosing our service!";

                // Send confirmation email if user email exists
                if (userEmail != null && !userEmail.isEmpty()) {
                    EmailUtil.sendEmail(userEmail, subject, messageBody);
                }

                response.sendRedirect("booking-history.jsp?message=Booking successful. Confirmation email sent!");
            } else {
                response.sendRedirect("bus-list.jsp?error=No seats available.");
            }
        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback();
            } catch (Exception ignored) {}
            e.printStackTrace();
            response.sendRedirect("bus-list.jsp?error=Error processing booking.");
        } finally {
            try {
                if (rs != null) rs.close();
                if (psCheckSeats != null) psCheckSeats.close();
                if (psBook != null) psBook.close();
                if (psUpdateSeats != null) psUpdateSeats.close();
                if (psUpdateSeatStatus != null) psUpdateSeatStatus.close();
                if (conn != null) conn.close();
            } catch (Exception ignored) {}
        }
    }
}

