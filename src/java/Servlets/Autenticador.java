package Servlets;

import Conexao.Select;
import Modelos.Usuario;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class Autenticador extends HttpServlet {

    private Select select;
    
    @Override
    public void init() {
        String jdbcURL = getServletContext().getInitParameter("jdbcURL");
        String jdbcUsername = getServletContext().getInitParameter("jdbcUsername");
        String jdbcPassword = getServletContext().getInitParameter("jdbcPassword");

        select = new Select(jdbcURL, jdbcUsername, jdbcPassword);

    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            HttpSession sessao = request.getSession(true);
            sessao.invalidate();
            response.sendRedirect("index.jsp");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();

        String login = request.getParameter("usuario"), senha = request.getParameter("senha");
        
        try {        
            Usuario usuario = select.usuario(login, senha);
            
            if (usuario != null) {
                
                HttpSession sessao = request.getSession(true);

                sessao.setAttribute("id", usuario.getId());
                sessao.setAttribute("nome", usuario.getNome());
                sessao.setAttribute("email", usuario.getEmail());
                sessao.setAttribute("ativo", true);

                out.println("<script type=\"text/javascript\">");
                out.println("location='index.jsp';");
                out.println("</script>");
                out.close();

            } else {
                out.println("<script type=\"text/javascript\">");
                out.println("alert('Usuário ou senha incorretos!');");
                out.println("location='login.jsp';");
                out.println("</script>");
                out.close();
            }
        } catch (SQLException ex) {}
    }    
}
