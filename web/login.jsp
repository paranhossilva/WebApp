<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html;" pageEncoding="UTF-8"%>

<!doctype html>
<html>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" charset="UTF-8">

    <link href="assets/css/bootstrap.min.css" rel="stylesheet" media="screen">
    <link href="assets/css/bootstrap-responsive.css" rel="stylesheet">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
    <script src="assets/js/init.js"></script>

    <head>		
        <title>Login</title>
    </head>
    <body style="background-color:#f5f5f5">

        <!------------- corpo -------------->

        <div class="jumbotron vertical-center">        
            <div class="container">

                <form class="form-signin" method="post" action = "Home">
                    <h1 class="form-signin-heading">Logar</h1>
                    <input class="form-control" type="text" placeholder="Usuário" name = "usuario"></br>
                    <input class="form-control" type="password" placeholder="Senha" name = "senha"></br></br>
                    <button class="btn btn-lg btn-block" type="submit" >Logar</button></br></br>

                    <p align="center">Você não tem cadastro? Então <a href="cadastro.jsp">clique aqui</a> para se cadastrar.</p>
                </form>
            </div>
        </div>

        <!------------- Scripts -------------->
        
        <script src="http://code.jquery.com/jquery-latest.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>
    </body>
</html>