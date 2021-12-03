<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html;" pageEncoding="UTF-8"%>

<!doctype html>
<html>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" charset="UTF-8">

    <link href="assets/css/bootstrap.min.css" rel="stylesheet" media="screen">
    <link href="assets/css/bootstrap-responsive.css" rel="stylesheet">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">

    <head>		
        <title>Cadastro</title> 
    </head>

    <body style="background-color:#f5f5f5">

        <!------------- Corpo -------------->

        <div class="jumbotron vertical-center"> 
            <div class="container">
                <div class="row-fulid">
                    <h1>Cadastre-se</h1>
                    <form class="needs-validation" method="post" name="cadastro" action="Inserir">
                        <label for="nome_id">Nome</label><br>
                        <input class="form-control" id="nome_id" type ="text" name="nome" align="center" maxlength="40" required><br/>                        
                        
                        <label for="nome_id">E-mail</label><br>
                        <input class="form-control" id="email_id" type ="email" name="email" align="center" maxlength="40" required><br/>

                        <label for="user_id">Usuário<br></label>
                        <input class="form-control" id="user_id" type ="text" name="usuario" maxlength="20" required><br/>

                        <label for="senha_id">Senha</label><br>	
                        <input class="form-control" id="senha_id" type="password" name="senha" required><br/>
                        
                        <input type="hidden" name="pagina" value="cad">

                        <input class="btn btn-lg btn-block cor" id="botao_id" type="submit" value ="Enviar">
                        <input class="btn btn-lg btn-block cor" id="limpar" type="reset" value="Limpar">
                    </form>					
                </div>
            </div>
        </div>

        <!------------- Scripts -------------->

        <script src="http://code.jquery.com/jquery-latest.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>
    </body>
</html>