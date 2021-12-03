package Servlets;

import Conexao.Delete;
import Conexao.Select;
import Conexao.Update;
import Modelos.Transacao;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class Excluir extends HttpServlet {
    
    private Update update;
    private Select select;
    private Delete delete;
    
    @Override
    public void init() {
        String jdbcURL = getServletContext().getInitParameter("jdbcURL");
        String jdbcUsername = getServletContext().getInitParameter("jdbcUsername");
        String jdbcPassword = getServletContext().getInitParameter("jdbcPassword");

        update = new Update(jdbcURL, jdbcUsername, jdbcPassword);
        select = new Select(jdbcURL, jdbcUsername, jdbcPassword);
        delete = new Delete(jdbcURL, jdbcUsername, jdbcPassword);

    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sessao = request.getSession();

        String pagina = request.getParameter("pagina");
        PrintWriter out = response.getWriter();

        switch (pagina) {
            // <editor-fold desc="Transação">
            case "deltrans":
                Transacao trans;

                Gson gson = new Gson();
                String json;
                int idMes = Integer.parseInt(request.getParameter("idmes")),
                 idUs = Integer.parseInt(sessao.getAttribute("id").toString()),
                 index = Integer.parseInt(request.getParameter("index"));
                float valor;

                try {
                    json = select.transacao(idMes);

                    trans = gson.fromJson(json, Transacao.class);

                    valor = trans.getValor().get(index) * - 1;

                    trans.getDesc().remove(index);
                    trans.setTotal(valor);
                    trans.getValor().remove(index);

                    json = gson.toJson(trans);

                    update.transacao(idMes, idUs, json, valor);
                } catch (SQLException ex) {}

                out.println("<html><body><script type='text/javascript'>"
                        + "alert('Transação excluída com sucesso');"
                        + "location.href = document.referrer;"
                        + "</script></body></html>");

                break;
            // </editor-fold>
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sessao = request.getSession();

        String pagina = request.getParameter("pagina");
        PrintWriter out = response.getWriter();        
        
        int idUs = Integer.parseInt(sessao.getAttribute("id").toString());

        switch (pagina) {
            // <editor-fold desc="Mês">
            case "delmes":

                int idMes = Integer.parseInt(request.getParameter("mes"));                
                String json;
                Transacao trans;
                Gson gson = new Gson();

                try {
                    json = select.transacao(idMes);

                    trans = gson.fromJson(json, Transacao.class);

                    delete.mes(idMes, idUs, trans.getTotal());
                } catch (SQLException ex) {
                }

                out.println("<html><body><script type='text/javascript'>"
                        + "alert('Mês excluído com sucesso');"
                        + "location.href = document.referrer;"
                        + "</script></body></html>");
                break;
            // </editor-fold>

            // <editor-fold desc="Tutor">
            case "deltutor":
                int idTutor = Integer.parseInt(request.getParameter("idtutor"));

                try {
                    delete.tutor(idUs, idTutor);
                } catch (SQLException ex) {
                }

                out.println("<html><body><script type='text/javascript'>"
                        + "alert('Tutor excluído com sucesso');"
                        + "location.href = document.referrer;"
                        + "</script></body></html>");
                out.close();
                break;
            // </editor-fold>
        }
    }
}
