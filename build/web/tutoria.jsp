<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.Locale"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="Modelos.*"%>
<%@page import="Conexao.Verifica"%>
<%@page import="Conexao.Select"%>

<%@page contentType="text/html;" pageEncoding="UTF-8"%>
<!doctype html>
<html>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" content="text/html; charset=UTF-8">

    <link href="assets/css/bootstrap.min.css" rel="stylesheet" media="screen">
    <link href="assets/css/bootstrap-responsive.css" rel="stylesheet">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">

    <script src="assets/js/init.js"></script>

    <!------------- Instanciamentos -------------->

    <%
        String jdbcURL = getServletContext().getInitParameter("jdbcURL");
        String jdbcUsername = getServletContext().getInitParameter("jdbcUsername");
        String jdbcPassword = getServletContext().getInitParameter("jdbcPassword");

        HttpSession sessao = request.getSession();
        Verifica verifica = new Verifica(jdbcURL, jdbcUsername, jdbcPassword);
        final int idTutor = Integer.parseInt(sessao.getAttribute("id").toString());
        final int idTutorado = Integer.parseInt(request.getParameter("idTutorado"));

        if (verifica.tutorUsuario(idTutorado, idTutor)) {

            Gson gson = new Gson();
            Select select = new Select(jdbcURL, jdbcUsername, jdbcPassword);
            ArrayList<Usuario> tutorados = new ArrayList<>();
            ArrayList<Mes> meses = new ArrayList<>();
            MesesExtensos extenso = new MesesExtensos();
            Descricoes desc = new Descricoes();
            Transacao trans = new Transacao();
            Locale localeBR = new Locale("pt", "BR");
            NumberFormat monetario = NumberFormat.getCurrencyInstance(localeBR);
            String cor, json;
            final String nome = select.nomeTutorado(idTutorado);
            Calendar data = Calendar.getInstance();
            data.setTime(new Date());
            Integer idMes = -1;
            float saldo = select.saldo(idTutorado);
            int[] mesAno;
    %>

    <head>		
        <title><%= nome%></title>
    </head>

    <body style="background-color:#f5f5f5; font-size:larger">

        <!------------- Menu -------------->

        <nav class="navbar navbar-expand-lg navbar-dark cor">
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarTogglerDemo03" aria-controls="navbarTogglerDemo03" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>


            <div class="collapse navbar-collapse" id="navbarTogglerDemo03">
                <ul class="navbar-nav mr-auto mt-2 mt-lg-0"> 
                    <li class="nav-item dropdown">
                        <a class="navbar-brand" href="index.jsp" style="color:black;">Voltar ao Início</a>
                    </li>
                    <%
                        if (verifica.tutora(idTutor)) {
                            tutorados = select.tutorados(idTutor);
                    %>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbardropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="color:black;">Tutorados</a>
                        <div class="dropdown-menu" aria-labelledby="navbardropdown">
                            <% for (int i = 0; i < tutorados.size(); i++) {%>                    
                            <a class="dropdown-item" href="tutoria.jsp?idTutorado=<%= tutorados.get(i).getId()%>"><%= tutorados.get(i).getNome()%></a>
                            <% } %>
                        </div>
                    </li>
                    <% } %>
                </ul>
            </div>
                
            <a class="navbar-brand" href="configuracoes.jsp" style="color:black;">Configurações</a>
            <a class="navbar-brand" href="Encerrar" data-toggle="tooltip" data-placement="bottom" title="Sair" style="color:black;"><img src="assets/imagens/sair.png" width="25" height="25" alt=""></a>
        </nav>

        <!------------- Get Mês -------------->

        <div class="container-fluid">
            <div class="row">
                <div class="col-9">
                    <%
                        meses = select.meses(idTutorado);

                        if (meses != null) {
                    %>

                    <!------------- Corpo -------------->

                    <!------------- Transações -------------->
                    <h1 align="center" id="mesano">Mês/Ano</h1>  
                    <table class='table table-borderless table-striped table-hover'>
                        <thead>
                            <tr>
                                <th scope='col'>Descrição</th>
                                <th scope='col'>Valor</th>
                                <th scope='col' style='width: 5%;'></th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (request.getParameter("idmes") == null) {
                                    idMes = meses.get(meses.size() - 1).getId();
                                } else {
                                    idMes = Integer.parseInt(request.getParameter("idmes").toString());
                                }

                                mesAno = select.mesAno(idMes);

                                json = select.transacao(idMes);

                                trans = gson.fromJson(json, Transacao.class);

                                for (int i = 0; i < trans.getDesc().size(); i++) {
                                    cor = (trans.getValor().get(i) < 0) ? "red" : "blue";

                                    out.println("<tr>"
                                            + "   <td scope='row'>" + desc.get(trans.getDesc().get(i)) + "</td>"
                                            + "   <td scope='row' style='color:" + cor + "'>" + monetario.format(trans.getValor().get(i)) + "</td>"
                                            + "</tr>");
                                }
                            %>
                        </tbody>
                    </table>

                    <script> document.getElementById("mesano").innerHTML = "<%= extenso.get(mesAno[0] - 1)%>/<%= mesAno[1]%>";</script>
                    
                    <%
                        } else {
                            out.print("<h1 align='center'>Você não possuí transações cadastradas</h1>");
                        }
                    %>                        
                </div>

                <!------------- Meses -------------->

                <div class="col-3">
                    <div>

                        <% if (meses.size() > 0) { %>

                        <div class='accordion' id='ant'>
                            <div class='card'>
                                <div class='card-header' id='headingOne'>
                                    <button class='btn btn-block' type='button' data-toggle='collapse' data-target='#collapseOne' aria-expanded='true' aria-controls='collapseOne'>
                                        Meses Anteriores
                                    </button>
                                </div>
                                <div id='collapseOne' class='collapse' aria-labelledby='headingOne' data-parent='#ant'>
                                    <div class='card-body'>

                                        <%
                                            for (int i = 0; i < meses.size(); i++) {
                                                if (meses.get(i).getAno() < data.get(Calendar.YEAR) || (meses.get(i).getAno() == data.get(Calendar.YEAR) && meses.get(i).getMes() < data.get(Calendar.MONTH) + 1)) {
                                                    out.print("<a href='tutoria.jsp?idTutorado=" + idTutorado + "&idmes=" + meses.get(i).getId() + "'>" + extenso.get(meses.get(i).getMes() - 1) + "/" + meses.get(i).getAno() + "</a><br/>");
                                                }
                                            }
                                        %>

                                    </div>
                                </div>
                            </div>
                        </div>

                        <%
                            for (int i = 0; i < meses.size(); i++) {
                                if (meses.get(i).getAno() == data.get(Calendar.YEAR) && meses.get(i).getMes() == data.get(Calendar.MONTH) + 1) {
                        %>

                        <div class='accordion' id='atual'>
                            <div class='card'>
                                <div class='card-header' id='headingTwo'>
                                    <button class='btn  btn-block' type='button'>
                                        <% out.println("<a href='tutoria.jsp?idTutorado=" + idTutorado + "&idmes=" + meses.get(i).getId() + "'>" + extenso.get(meses.get(i).getMes() - 1) + "/" + meses.get(i).getAno() + "</a>"); %>
                                    </button>
                                </div>
                            </div>
                        </div>
                        <% }
                            } %>                                    


                        <div class='accordion' id='prox'>
                            <div class='card'>
                                <div class='card-header' id='headingTwo'>
                                    <button class='btn btn-block' type='button' data-toggle='collapse' data-target='#collapseTwo' aria-expanded='true' aria-controls='collapseTwo'>
                                        Meses Futuros
                                    </button>
                                </div>
                                <div id='collapseTwo' class='collapse' aria-labelledby='headingTwo' data-parent='#prox'>
                                    <div class='card-body'>
                                        <%
                                            for (int i = 0; i < meses.size(); i++) {
                                                if (meses.get(i).getAno() > data.get(Calendar.YEAR) || (meses.get(i).getAno() == data.get(Calendar.YEAR) && meses.get(i).getMes() > data.get(Calendar.MONTH) + 1)) {
                                                    out.print("<a href='tutoria.jsp?idTutorado=" + idTutorado + "&idmes=" + meses.get(i).getId() + "'>" + extenso.get(meses.get(i).getMes() - 1) + "/" + meses.get(i).getAno() + "</a><br/>");
                                                }
                                            }
                                        %>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <%
                            } else {
                                out.print("<h1 align='center'>Você não possuí meses cadastrados</h1>");
                            }
                        %>
                    </div>
                    <%
                        cor = (saldo < 0) ? "red" : "blue";

                        out.println("<div class='d-flex align-items-center p-3 my-3 rounded shadow-sm' style='background-color:" + cor + "; color:white'><b>Saldo: " + monetario.format(saldo) + "</b><br/></div>");
                    %>
                </div>
            </div>
        </div>
        <%
        } else {
        %>

    <head>		
        <title>Erro!</title>
    </head>
    <body style="background-color:#f5f5f5; font-size:larger">
        <h1 align="center">Página não encontrada</h1>
        <a class="navbar-brand" href="index.jsp"><h1>Voltar ao Início</h1></a>

        <% }%>

        <!------------- Scripts -------------->

        <script src="assets/js/script.js"></script>
        <script src="http://code.jquery.com/jquery-latest.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>
    </body>
</html>