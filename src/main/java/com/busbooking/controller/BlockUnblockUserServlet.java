package com.busbooking.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.busbooking.dao.DBConnection;

@WebServlet("/BlockUnblockUserServlet")
public class BlockUnblockUserServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int userId = Integer.parseInt(request.getParameter("userId"));
        String action = request.getParameter("action"); // block or unblock

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            String query = "UPDATE users SET status = ? WHERE id = ?";
            ps = conn.prepareStatement(query);
            ps.setString(1, action.equals("block") ? "BLOCKED" : "ACTIVE");
            ps.setInt(2, userId);
            ps.executeUpdate();

            response.sendRedirect("manage-users.jsp?message=User " + action + "ed successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage-users.jsp?error=Error updating user status.");
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception ignored) {}
        }
    }
}
