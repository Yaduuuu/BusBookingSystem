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
        int busId = Integer.parseInt(request.getParameter("busId"));

        Connection conn = null;
        PreparedStatement psCheckStatus = null, psCheckSeats = null, psBook = null, psUpdateSeats = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            // Check if the user is BLOCKED
            String checkStatusQuery = "SELECT status FROM users WHERE id=?";
            psCheckStatus = conn.prepareStatement(checkStatusQuery);
            psCheckStatus.setInt(1, userId);
            rs = psCheckStatus.executeQuery();

            if (rs.next() && rs.getString("status").equals("BLOCKED")) {
                response.sendRedirect("bus-list.jsp?error=You are blocked from booking buses.");
                return;
            }

            conn.setAutoCommit(false); // Start transaction

            // Check if seats are available
            String checkSeatsQuery = "SELECT available_seats FROM buses WHERE id=?";
            psCheckSeats = conn.prepareStatement(checkSeatsQuery);
            psCheckSeats.setInt(1, busId);
            rs = psCheckSeats.executeQuery();

            if (rs.next() && rs.getInt("available_seats") > 0) {
                // Deduct seat from available_seats
                String updateSeatsQuery = "UPDATE buses SET available_seats = available_seats - 1 WHERE id=?";
                psUpdateSeats = conn.prepareStatement(updateSeatsQuery);
                psUpdateSeats.setInt(1, busId);
                psUpdateSeats.executeUpdate();

                // Insert booking details (each booking is recorded separately)
                String bookQuery = "INSERT INTO bookings (user_id, bus_id, booking_time) VALUES (?, ?, ?)";
                psBook = conn.prepareStatement(bookQuery);
                psBook.setInt(1, userId);
                psBook.setInt(2, busId);
                psBook.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
                psBook.executeUpdate();

                conn.commit(); // Commit transaction
                response.sendRedirect("booking-history.jsp?message=Booking successful.");
            } else {
                response.sendRedirect("bus-list.jsp?error=No seats available.");
            }
        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback(); // Rollback on error
            } catch (Exception ignored) {}
            e.printStackTrace();
            response.sendRedirect("bus-list.jsp?error=Error processing booking.");
        } finally {
            try {
                if (rs != null) rs.close();
                if (psCheckStatus != null) psCheckStatus.close();
                if (psCheckSeats != null) psCheckSeats.close();
                if (psBook != null) psBook.close();
                if (psUpdateSeats != null) psUpdateSeats.close();
                if (conn != null) conn.close();
            } catch (Exception ignored) {}
        }
    }
}
