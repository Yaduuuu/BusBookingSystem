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

@WebServlet("/DeleteBusServlet")
public class DeleteBusServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int busId = Integer.parseInt(request.getParameter("busId"));

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "DELETE FROM buses WHERE id=?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, busId);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                response.sendRedirect("manage-buses.jsp?message=Bus deleted successfully.");
            } else {
                response.sendRedirect("manage-buses.jsp?error=Failed to delete bus.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage-buses.jsp?error=Error occurred.");
        } finally {
            try { if (ps != null) ps.close(); if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
    }
}
