<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<!DOCTYPE html>
<html>
    <fmt:bundle basename="messages">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><fmt:message key="menu_sistema" /></title>
        <style>
            body {
                background-color: #282a36;
                color: #f8f8f2;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                margin: 0;
                padding: 20px;
            }
        
            h1, h2 {
                font-weight: normal;
                font-size: 24px;
                text-align: center;
            }
        
            a {
                display: inline-block;
                padding: 10px 20px;
                background-color: #6272a4;
                color: #f8f8f2;
                text-decoration: none;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                transition: background-color 0.3s;
                margin: 10px 0px;
            }
        
            a:hover {
                background-color: #50fa7b;
            }
        
            table {
                width: 100%;
                border-collapse: collapse;
                background-color: #282a36;
                color: #f8f8f2;
            }
        
            th {
                background-color: #44475a;
                font-weight: bold;
                padding: 10px;
                text-align: left;
            }
        
            tr:nth-child(even) {
                background-color: #44475a;
            }
        
            tr:nth-child(odd) {
                background-color: #383a59;
            }
        
            tr:hover {
                background-color: #6272a4;
            }
        
            td {
                padding: 10px;
            }
        </style>

    </head>
    <body>
        <% System.out.println("PASSEI POR: WEB-INF/logado/usuario/index.jsp"); %>
        <h1><fmt:message key="pagina_usuario" /></h1>
        <p><fmt:message key="ola" /> ${sessionScope.usuarioLogado.nome}</p>
        <c:if test="${sessionScope.usuarioLogado.tipoUsuario == 'C'}">
            <h1><fmt:message key="logado_cliente" /></h1>
            <div class="links">
                <a href="${pageContext.request.contextPath}/locacoes/cadastro"><fmt:message key="cadastrar_locacao" /></a>
                <a href="${pageContext.request.contextPath}/logout.jsp"><fmt:message key="sair" /></a>
            </div>
            <h2><fmt:message key="lista_locacoes" /></h2>
            <div id="locacoesTableContainer" align="center">
                <table id="locacoesTable" border="1">
                    <tr>
                        <th><fmt:message key="nome" /></th>
                        <th><fmt:message key="cidade" /></th>
                        <th><fmt:message key="data" /></th>
                        <th><fmt:message key="horario" /></th>
                    </tr>
                    <!-- Tabela com as locações do cliente logado -->
                    <c:forEach var="locacao" items="${sessionScope.listaLocacoes}">
                        <c:if test="${locacao.cliente.email == sessionScope.usuarioLogado.email}">
                            <tr>
                                <td>${locacao.locadora.nome}</td>
                                <td>${locacao.locadora.cidade}</td>
                                <td>${locacao.dia}</td>
                                <td>${locacao.horario}</td>
                            </tr>
                        </c:if>
                    </c:forEach>
                </table>
            </div>
        </c:if>  
        <c:if test="${sessionScope.usuarioLogado.tipoUsuario == 'L'}">
            <h1><fmt:message key="logado_locadora" /></h1>
            <a href="${pageContext.request.contextPath}/logout.jsp"><fmt:message key="sair" /></a>
            <h2><fmt:message key="lista_locacoes" /></h2>
            <div id="locacoesTableContainer" align="center">
              
                <table id="locacoesTable" border="1">
                    <tr>
                        <th><fmt:message key="nome_cliente" /></th>
                        <th><fmt:message key="CPF_cliente" /></th>
                        <th><fmt:message key="data" /></th>
                        <th><fmt:message key="horario" /></th>
                    </tr>
                    <!-- Tabela com as locações da locadora logada -->
                    <c:forEach var="locacao" items="${sessionScope.listaLocacoes}">
                        <c:if test="${locacao.locadora.email == sessionScope.usuarioLogado.email}">
                            <tr>
                                <td>${locacao.cliente.nome}</td>
                                <td>${locacao.cliente.CPF}</td>
                                <td>${locacao.dia}</td>
                                <td>${locacao.horario}</td> 
                            </tr>
                        </c:if>
                    </c:forEach>
                </table>
            </div> 
        </c:if>
    </body>
</fmt:bundle>
</html>