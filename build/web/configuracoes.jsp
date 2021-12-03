<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Modelos.Usuario"%>
<%@page import="Conexao.Select"%>
<%@page import="Conexao.Verifica"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" content="text/html; charset=UTF-8">

    <link href="assets/css/bootstrap.min.css" rel="stylesheet" media="screen">
    <link href="assets/css/bootstrap-responsive.css" rel="stylesheet">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">

    <script src="assets/js/init.js"></script>

    <%
        String jdbcURL = getServletContext().getInitParameter("jdbcURL");
        String jdbcUsername = getServletContext().getInitParameter("jdbcUsername");
        String jdbcPassword = getServletContext().getInitParameter("jdbcPassword");
        
        HttpSession sessao = request.getSession();
        Verifica verifica = new Verifica(jdbcURL, jdbcUsername, jdbcPassword);
        Select select = new Select(jdbcURL, jdbcUsername, jdbcPassword);
        final int id = Integer.parseInt(sessao.getAttribute("id").toString());
        ArrayList<Usuario> tutores = new ArrayList<>();
    %>

    <head>
        <title>Configurações</title>
    </head>
    <body style="background-color:#f5f5f5; font-size:larger">

        <!------------- Menu -------------->

        <nav class="navbar navbar-expand-lg navbar-dark cor">  
            
            <div class="collapse navbar-collapse" id="navbarTogglerDemo03">
                <ul class="navbar-nav mr-auto mt-2 mt-lg-0"> 
                    <li class="nav-item dropdown">
                        <a class="navbar-brand" href="index.jsp" style="color:black;">Voltar ao Início</a>
                    </li>
                </ul>

            <a class="navbar-brand" href="Encerrar" data-toggle="tooltip" data-placement="bottom" title="Sair" style="color:black;"><img src="assets/imagens/sair.png" width="25" height="25" alt=""></a>
        </nav>

        <!------------- Corpo -------------->

        <div class="jumbotron vertical-center"> 
            <h1 align="center">Configurações</h1><br/>
            
            <div id="accordion">

                <!------------- Alterar Dados -------------->

                <div class="card-header" id="headingOne">
                    <h5 class="mb-0">
                        <button class="btn btn-link" data-toggle="collapse" data-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                            Alterar Dados
                        </button>
                    </h5>
                </div>

                <div id="collapseOne" class="collapse" aria-labelledby="headingOne" data-parent="#accordion">
                    <div class="card-body"  style="background-color:#f5f5f5; font-size:larger">
                        <form class="form-signin" method="post" action = "Alterar">
                            <label for="nome_id">Nome</label><br>
                            <input class="form-control" id="nome_id" type ="text" name="nome" align="center" maxlength="40" value="<%= sessao.getAttribute("nome").toString()%>"required><br/>                        

                            <label for="nome_id">E-mail</label><br>
                            <input class="form-control" id="email_id" type ="email" name="email" align="center" maxlength="40" value="<%= sessao.getAttribute("email").toString()%>" required><br/>

                            <input type="hidden" name="pagina" value="dados" />

                            <input class="btn btn-lg btn-block cor" id="botao_id" type="submit" value ="Enviar">                        
                        </form>
                    </div>
                </div>
            </div>                                

            <!------------- Alterar senha -------------->

            <div class="card-header" id="headingTwo">
                <h5 class="mb-0">
                    <button class="btn btn-link" data-toggle="collapse" data-target="#collapseTwo" aria-expanded="true" aria-controls="collapseTwo">
                        Alterar Senha
                    </button>
                </h5>
            </div>

            <div id="collapseTwo" class="collapse" aria-labelledby="headingTwo" data-parent="#accordion">
                <div class="card-body"  style="background-color:#f5f5f5; font-size:larger">
                    <form class="form-signin" method="post" action = "Alterar">
                        <label for="senha_id">Senha</label><br>	
                        <input class="form-control" id="senha_id" type="password" name="senha" required><br/>

                        <input type="hidden" name="pagina" value="senha" />

                        <input class="btn btn-lg btn-block cor" id="botao_id" type="submit" value ="Enviar">                       
                    </form>
                </div>
            </div>

            <!------------- Adicionar Tutor -------------->

            <div class="card-header" id="headingThree">
                <h5 class="mb-0">
                    <button class="btn btn-link" data-toggle="collapse" data-target="#collapseThree" aria-expanded="true" aria-controls="collapseThree">
                        Adicionar Tutor
                    </button>
                </h5>
            </div>

            <div id="collapseThree" class="collapse" aria-labelledby="headingThree" data-parent="#accordion">
                <div class="card-body"  style="background-color:#f5f5f5; font-size:larger">
                    <form class="form-signin" method="post" action = "Inserir">
                        <label for="user_id">Usuário<br></label>
                        <input class="form-control" id="user_id" type ="text" name="usuario" maxlength="20" required><br/>

                        <input type="hidden" name="pagina" value="tutor" />

                        <input class="btn btn-lg btn-block cor" id="botao_id" type="submit" value ="Enviar">                         
                    </form>
                </div>
            </div>

            <!------------- Excluir Tutor -------------->

            <%
                if (verifica.tutorado(id)) {
                    tutores = select.tutor(id);
            %>
            <div class="card-header" id="headingFour">
                <h5 class="mb-0">
                    <button class="btn btn-link" data-toggle="collapse" data-target="#collapseFour" aria-expanded="true" aria-controls="collapseFour">
                        Excluir Tutor
                    </button>
                </h5>
            </div>

            <div id="collapseFour" class="collapse" aria-labelledby="headingFour" data-parent="#accordion">
                <div class="card-body"  style="background-color:#f5f5f5; font-size:larger">
                    <table class='table table-borderless table-striped table-hover'>
                        <% for (int i = 0; i < tutores.size(); i++) {%>
                        <form class="needs-validation" method="post" name="adicionar" action="Excluir">
                            <input type="hidden" name="idtutor" value="<%= tutores.get(i).getId() %>" />
                            <input type="hidden" name="pagina" value="deltutor" />

                            <tr>
                                <td scope='col'><%= tutores.get(i).getNome() %></td>
                                <th scope='col' style='width: 25%;' align="center"><input class="btn btn-lg cor" id="botao_id" type="submit" value ="Excluir Tutor"></th>
                            </tr>                            
                        </form>
                        <% } %>
                    </table>
                </div>
            </div>
        </div>
        <% }%>
    </div>
</div>

<!------------- Scripts -------------->

<script src="http://code.jquery.com/jquery-latest.js"></script>
<script src="assets/js/bootstrap.min.js"></script>
</body>
</html>