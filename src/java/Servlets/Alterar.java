package Servlets;

import Conexao.Update;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class Alterar extends HttpServlet{
    
    private Update update;
    
    @Override
    public void init() {
        String jdbcURL = getServletContext().getInitParameter("jdbcURL");
        String jdbcUsername = getServletContext().getInitParameter("jdbcUsername");
        String jdbcPassword = getServletContext().getInitParameter("jdbcPassword");

        update = new Update(jdbcURL, jdbcUsername, jdbcPassword);

    }    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession sessao = request.getSession();

        String pagina = request.getParameter("pagina");
        
        PrintWriter out = response.getWriter();
        
        int id = Integer.parseInt(sessao.getAttribute("id").toString());
         
        switch (pagina) {
            // <editor-fold desc="Dados">
            case "dados":
                String nome = request.getParameter("nome"), email = request.getParameter("email");

                try {
                    update.dados(id, nome,email);
                    
                    sessao.setAttribute("nome", nome);

                        out.println("<html><body><script type='text/javascript'>"
                                + "alert('Dados alterados com sucesso');"
                                + "location='configuracoes.jsp';"
                                + "</script></body></html>");
                        out.close();
                } catch (SQLException ex) {}
                
                break;
            //</editor-fold>
                
            // <editor-fold desc="Senha">
            case "senha":
                String senha = request.getParameter("senha");    
                
                try {
                    update.senha(id, senha);

                        out.println("<html><body><script type='text/javascript'>"
                                + "alert('Senha alterada com sucesso');"
                                + "location='configuracoes.jsp';"
                                + "</script></body></html>");
                        out.close();
                } catch (SQLException ex) {}
            
                break;
            // </editor-fold>
        }
    }
}
