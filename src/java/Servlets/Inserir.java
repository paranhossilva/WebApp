package Servlets;

import Conexao.Insert;
import Conexao.Select;
import Conexao.Update;
import Conexao.Verifica;
import Modelos.Transacao;
import Modelos.Usuario;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class Inserir extends HttpServlet {

    private Verifica verifica;
    private Insert insert;
    private Select select;
    private Update update;

    @Override
    public void init() {
        String jdbcURL = getServletContext().getInitParameter("jdbcURL");
        String jdbcUsername = getServletContext().getInitParameter("jdbcUsername");
        String jdbcPassword = getServletContext().getInitParameter("jdbcPassword");

        verifica = new Verifica(jdbcURL, jdbcUsername, jdbcPassword);
        insert = new Insert(jdbcURL, jdbcUsername, jdbcPassword);
        select = new Select(jdbcURL, jdbcUsername, jdbcPassword);
        update = new Update(jdbcURL, jdbcUsername, jdbcPassword);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession sessao = request.getSession();

        String pagina = request.getParameter("pagina"), alert;

        PrintWriter out = response.getWriter();

        switch (pagina) {
            // <editor-fold desc="Cadastro">
            case "cad":

                String nome = request.getParameter("nome"),
                 usuario = request.getParameter("usuario"),
                 senha = request.getParameter("senha"),
                 email = request.getParameter("email");

                try {
                    if (verifica.login(usuario)) {
                        out.println("<html><body><script type='text/javascript'>"
                                + "alert('Usuário já existe.');"
                                + "location='cadastro.jsp';"
                                + "</script></body></html>");
                    } else {
                        insert.usuario(nome, usuario, email, senha);

                        Usuario user = select.usuario(usuario, senha);

                        sessao = request.getSession(true);

                        sessao.setAttribute("id", user.getId());
                        sessao.setAttribute("nome", user.getNome());
                        sessao.setAttribute("email", user.getEmail());
                        sessao.setAttribute("ativo", true);

                        out.println("<script type=\"text/javascript\">");
                        out.println("location='index.jsp';");
                        out.println("</script>");
                        out.close();
                    }
                } catch (SQLException ex) {
                }
                break;
            // </editor-fold>

            // <editor-fold desc="Mês">
            case "addmes":

                int mes = Integer.parseInt(request.getParameter("mes")),
                 ano = Integer.parseInt(request.getParameter("ano")),
                 idUs = Integer.parseInt(sessao.getAttribute("id").toString());

                try {
                    if (verifica.mes(mes, ano, idUs)) {
                        out.println("<html><body><script type='text/javascript'>"
                                + "alert('O mês informado já existe.');"
                                + "location='index.jsp';"
                                + "</script></body></html>");
                    } else {
                        insert.mes(mes, ano, idUs);

                        out.println("<html><body><script type='text/javascript'>"
                                + "alert('Mês cadastrado com sucesso');"
                                + "location='index.jsp';"
                                + "</script></body></html>");
                    }

                } catch (SQLException ex) {
                }
                break;
            // </editor-fold>

            // <editor-fold desc="Transação">
            case "addtrans":

                Transacao trans;
                Gson gson = new Gson();
                int desc = Integer.parseInt(request.getParameter("desc"));
                String json;
                float valor = Float.parseFloat(request.getParameter("valor")) * Float.parseFloat(request.getParameter("tipo"));
                int idMes = Integer.parseInt(request.getParameter("idmes"));
                idUs = Integer.parseInt(sessao.getAttribute("id").toString());

                try {
                    json = select.transacao(idMes);

                    trans = gson.fromJson(json, Transacao.class);

                    trans.getDesc().add(desc);
                    trans.getValor().add(valor);
                    trans.setTotal(valor);

                    json = gson.toJson(trans);

                    update.transacao(idMes, idUs, json, valor);

                } catch (SQLException ex) {
                }

                out.println("<html><body><script type='text/javascript'>"
                        + "alert('Transação inserida com sucesso');"
                        + "location.href = document.referrer;"
                        + "</script></body></html>");

                break;
            // </editor-fold>

            // <editor-fold desc="Tutor">
            case "tutor":
                try {
                usuario = request.getParameter("usuario");

                int idTutor = verifica.tutor(usuario);

                if (idTutor > 0) {
                    idUs = Integer.parseInt(sessao.getAttribute("id").toString());

                    if (verifica.tutoria(idUs, idTutor)) {
                        insert.tutor(idUs, idTutor);

                        alert = "Tutor adicionado com sucesso.";
                    } else {
                        alert = "O usuário informado já é seu tutor.";
                    }

                } else {
                    alert = "O usuário informado não existe.";
                }

                out.println("<html><body><script type='text/javascript'>"
                        + "alert('" + alert + "');"
                        + "location.href = document.referrer;"
                        + "</script></body></html>");
                out.close();

            } catch (SQLException ex) {
            }

            break;
            // </editor-fold>
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
