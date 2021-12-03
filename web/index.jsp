<%@page import="Modelos.Descricoes"%>
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
        Gson gson = new Gson();
        Select select = new Select(jdbcURL, jdbcUsername, jdbcPassword);
        Verifica verifica = new Verifica(jdbcURL, jdbcUsername, jdbcPassword);
        MesesExtensos extenso = new MesesExtensos();
        Descricoes desc = new Descricoes();
        Transacao trans = new Transacao();
        ArrayList<Usuario> tutorados = new ArrayList<>();
        ArrayList<Mes> meses = new ArrayList<>();
        Locale localeBR = new Locale("pt", "BR");
        NumberFormat monetario = NumberFormat.getCurrencyInstance(localeBR);
        String cor, json;
        final String nome = sessao.getAttribute("nome").toString();
        Calendar data = Calendar.getInstance();
        data.setTime(new Date());
        int idMes = -1;
        boolean mesCad = true;
        final int id = Integer.parseInt(sessao.getAttribute("id").toString());
        float saldo = select.saldo(id);
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
                    <li class="nav-item">
                        <a class="nav-link active" data-toggle="modal" data-target="#modalAddVal" style="color:black;">Adicionar Transação</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" data-toggle="modal" data-target="#modalAddMes" style="color:black;">Adicionar Mês</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" data-toggle="modal" data-target="#modalExcMes" style="color:black;">Excluir Mês</a>
                    </li>

                    <% if (verifica.tutora(id)) {
                            tutorados = select.tutorados(id);
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
                        meses = select.meses(id);

                        if (!meses.isEmpty()) {
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
                                            + "   <td scope='row'><a class='navbar-brand' href='#' onClick='excluirTrans(" + i + ", " + idMes + ");' data-toggle='tooltip' data-placement='bottom' title='Deletar Valor'><img src='assets/imagens/del.png' width='25' height='25' alt=''></a></td>"
                                            + "</tr>");
                                }
                            %>
                        </tbody>
                    </table>

                    <script> document.getElementById("mesano").innerHTML = "<%= extenso.get(mesAno[0] - 1)%>/<%= mesAno[1]%>";</script>
                    
                    <%
                        } else {
                            out.print("<h1 align='center'>Você não possuí transações cadastradas</h1>");
                            mesCad = false;
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
                                                    out.print("<a href='index.jsp?idmes=" + meses.get(i).getId() + "'>" + extenso.get(meses.get(i).getMes() - 1) + "/" + meses.get(i).getAno() + "</a><br/>");
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
                                        <% out.println("<a href='index.jsp?idmes=" + meses.get(i).getId() + "'>" + extenso.get(meses.get(i).getMes() - 1) + "/" + meses.get(i).getAno() + "</a>"); %>
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
                                                    out.print("<a href='index.jsp?idmes=" + meses.get(i).getId() + "'>" + extenso.get(meses.get(i).getMes() - 1) + "/" + meses.get(i).getAno() + "</a><br/>");
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

        <!------------- Modal -------------->

        <!------------- Adicionar Transação -------------->

        <div class="modal fade" id="modalAddVal" tabindex="-1" role="dialog" aria-labelledby="modalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">                        
                        <h5 class="modal-title" id="modalLabel">Adicionar Transação</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Fechar">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>                    
                    <div class="modal-body">                        
                        <% if (mesCad) {%>
                        <form class="needs-validation" method="post" name="adicionar" action="Inserir">
                            <label for="val_id">Valor<br></label>
                            <input class="form-control" id="val_id" type ="number" name="valor" maxlength="10" step="0.01" required><br/>

                            <p>Tipo</p>
                            <div class="radio">
                                <table class="table table-borderless">
                                    <tr>
                                        <td>
                                            <input type="radio" id="desp" name="tipo" value="-1" onclick="mudaDesc('despesa');" required>
                                            <label for="desp">Despesa</label>
                                        </td>
                                        <td>
                                            <input type="radio" id="rec" name="tipo" value="1" onclick="mudaDesc('receita');" required>
                                            <label for="rec">Receita</label>
                                        </td>
                                    </tr>
                                </table>
                            </div>

                            <label for="desc_id">Descrição</label><br>
                            <select name="desc" id="desc_id" disabled required>
                                <option selected></option>                           
                            </select><br/><br/>                            

                            <input type="hidden" name="idmes" value="<%= idMes%>" />
                            <input type="hidden" name="pagina" value="addtrans" />

                            <div align="center">
                                <input class="btn btn-lg cor" id="botao_id" type="submit" value ="Salvar">
                                <input class="btn btn-lg cor" id="limpar" type="reset" value="Limpar" onclick="limpaDesc();">
                                <button type="button" class="btn btn-lg" data-dismiss="modal">Fechar</button>
                            </div>
                        </form>	
                        <%
                            } else {
                                out.println("<h1 align='center'>Você não possuí meses cadastrados. Cadastre ao menos um mês antes de cadastrar alguma transação.</h1>"
                                        + "<button type='button' class='btn btn-lg' data-dismiss='modal'>Fechar</button>");
                            }
                        %>
                    </div>  
                </div>
            </div>
        </div>


        <!------------- Adicionar Mês -------------->        

        <div class="modal fade" id="modalAddMes" tabindex="-1" role="dialog" aria-labelledby="modalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalLabel">Adicionar Mês</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Fechar">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <form class="needs-validation" method="post" name="adicionar" action="Inserir">
                            <label for="mes_id">Mês</label><br/>
                            <select name="mes" id="mes_id" required>
                                <option selected></option>
                                <option value="1">Janeiro</option>
                                <option value="2">Fevereiro</option>
                                <option value="3">Março</option>
                                <option value="4">Abril</option>
                                <option value="5">Maio</option>
                                <option value="6">Junho</option>
                                <option value="7">Julho</option>
                                <option value="8">Agosto</option>
                                <option value="9">Setembro</option>
                                <option value="10">Outubro</option>
                                <option value="11">Novembro</option>
                                <option value="12">Dezembro</option>
                            </select><br/>

                            <label for="ano_id">Ano<br/></label>
                            <input class="form-control" id="ano_id" type ="number" name="ano" maxlength="4" required><br/>

                            <input type="hidden" name="pagina" value="addmes" />

                            <div align="center">
                                <input class="btn btn-lg cor" id="botao_id" type="submit" value ="Salvar">
                                <input class="btn btn-lg cor" id="limpar" type="reset" value="Limpar">
                                <button type="button" class="btn btn-lg" data-dismiss="modal">Fechar</button>
                            </div>
                        </form>	
                    </div>
                </div>
            </div>
        </div>

        <!------------- Exclui Mês -------------->    

        <div class="modal fade" id="modalExcMes" tabindex="-1" role="dialog" aria-labelledby="modalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalLabel">Excluir Mês</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Fechar">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">

                        <% if (mesCad) { %>
                        <form class="needs-validation" method="post" name="excluir" id="excluirmes" action="Excluir">
                            <label for="mes_id">Mês</label><br/>
                            <select name="mes" id="mes_id" required>
                                <option selected></option>
                                <%
                                    for (int i = 0; i < meses.size(); i++) {
                                        out.println("<option value='" + meses.get(i).getId() + "'>" + extenso.get(meses.get(i).getMes() - 1) + "/" + meses.get(i).getAno() + "</option>");
                                    }
                                %>
                            </select><br/>

                            <input type="hidden" name="pagina" value="delmes" /><br/>

                            <div align="center">
                                <input class="btn btn-lg cor" id="botao_id" type="button" value ="Excluir" onClick="excluirMes();">
                                <input class="btn btn-lg cor" id="limpar" type="reset" value="Limpar">
                                <button type="button" class="btn btn-lg" data-dismiss="modal">Fechar</button>
                            </div>
                        </form>
                        <%
                            } else {
                                out.println("<h1 align='center'>Você não possuí meses cadastrados.</h1>"
                                        + "<button type='button' class='btn btn-lg' data-dismiss='modal'>Fechar</button>");
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>

        <!------------- Scripts -------------->

        <script src="assets/js/script.js"></script>
        <script src="http://code.jquery.com/jquery-latest.js"></script>
        <script src="assets/js/bootstrap.min.js"></script> 

    </body>
</html>