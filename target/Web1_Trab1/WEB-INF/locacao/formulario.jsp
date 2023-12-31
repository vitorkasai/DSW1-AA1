<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<html>
    <fmt:bundle basename="messages">
    <head>
        <title><fmt:message key="gerenciamento_locacoes" /></title>
        
        <style>
            body {
                background-color: #282a36;
                color: #f8f8f2;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
    
            h1 {
                color: #bd93f9;
            }
    
            h2 a {
                color: #8be9fd;
                text-decoration: none;
            }
    
            h2 a:hover {
                color: #50fa7b;
            }
    
            div.form-container {
                margin: 50px auto;
                max-width: 600px;
                padding: 20px;
                background-color: #44475a;
                border-radius: 5px;
            }
    
            table {
                width: 100%;
                border-collapse: collapse;
                background-color: #282a36;
                color: #f8f8f2;
                border: 1px solid #6272a4;
            }
    
            caption {
                font-size: 18px;
                font-weight: bold;
                padding: 10px;
            }
    
            th {
                background-color: #44475a;
                font-weight: bold;
                padding: 10px;
                text-align: left;
                border-bottom: 1px solid #6272a4;
            }
    
            td {
                padding: 10px;
                border-bottom: 1px solid #6272a4;
            }
    
            label {
                color: #f8f8f2;
                font-weight: bold;
            }
    
            input[type="date"],
            input[type="time"],
            select {
                width: 100%;
                padding: 10px;
                margin-bottom: 10px;
                border: 1px solid #44475a;
                background-color: #282a36;
                color: #f8f8f2;
                border-radius: 5px;
            }
    
            input[type="submit"] {
                padding: 10px 20px;
                background-color: #50fa7b;
                color: #282a36;
                border: none;
                cursor: pointer;
                border-radius: 5px;
            }
    
            ul.erro {
                list-style-type: none;
                padding: 0;
                margin-top: 20px;
                background-color: #ff5555;
                color: #282a36;
                border-radius: 5px;
            }
    
            ul.erro li {
                padding: 10px;
            }
    
            
            .horarioUsado {
                border: 1px solid red;
            }
            
            .horarioUsado::after {
                content: "Horário indisponível!"
            }
        </style>
        
    </head>

    <body>
        <% System.out.println("PASSEI POR: WEB-INF/locacao/formulario.jsp"); %> 
        <div align="center">
            <h1><fmt:message key="nova_locacao" /></h1>
            <h2>
                <a href="lista"><fmt:message key="minha_lista_locacoes" /></a>
            </h2>
        </div>
        <div align="center">
            <form action="insercao" method="post" id="formulario">
                <table border="1">
                    <caption><fmt:message key="cadastro" /></caption>
                    <tr>
                        <td><label for="locadora"><fmt:message key="locadora" /></label></td>
                        <td>
                            <c:set var="listaLocadoras" value="${sessionScope.listaLocadoras}" />
                            <select id="locadoraSelect" name="locadoraId" required>
                                <option value="" selected disabled><fmt:message key="selecionar_locadora" /></option>
                                <c:forEach items="${listaLocadoras}" var="locadora">
                                    <option value="${locadora.id}">${locadora.nome}</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td><label for="dataLocacao"><fmt:message key="data" /></label></td>
                        <td><input type="date" id="dataLocacao" name="dataLocacao" required value="${locacao.dia}" /></td>
                    </tr>
                    
                    <tr>
                        <c:choose>
                            <c:when test="${erroLocacao != 'Horário indisponível'}">
                                <td><label for="hora"><fmt:message key="horario" /></label></td>
                                <td><input type="time" id="horario" name="horario" step="3600" required /></td>
                                <c:set var="erroLocacao" value="" scope="request" />
                            </c:when>
                            <c:otherwise>
                                <td><label for="hora"><fmt:message key="horario" /></label></td>
                                <td><input type="time" id="horario" class="horarioUsado" name="horario" step="3600" required /></td>
                            </c:otherwise>
                        </c:choose>
                        
                        
                    </tr>
                    
                    <tr>
                        <!-- Substituir o value depois por <fmt:message key="save" /> /> -->
                        <td colspan="2" align="center"><input type="submit" value=<fmt:message key="cadastrar" />></td>
                    </tr>
                </table>
            </form>
        </div>

        <c:if test="${!empty requestScope.mensagens}">
            <ul class="erro">
                <c:forEach items="${requestScope.mensagens}" var="mensagem">
                    <li>${mensagem}</li>
                </c:forEach>
            </ul>
        </c:if>

        <script>
            document.addEventListener('DOMContentLoaded', function() {
                // Armazena os valores dos campos em variáveis
                var locadoraSelectValue = document.getElementById('locadoraSelect').value;
                var dataLocacaoValue = document.getElementById('dataLocacao').value;
                var horarioValue = document.getElementById('horario').value;
              
                // Verifica se eu já escolhi uma locadora para retirar a opção inválida  
                document.getElementById('locadoraSelect').addEventListener('change', function() {
                  var locadoraSelect = document.getElementById('locadoraSelect');
              
                  // Remover a opção "Escolha uma locadora" quando uma opção válida for selecionada
                  if (locadoraSelect.value !== '') {
                    var escolhaOption = document.querySelector('#locadoraSelect option[value=""]');
                    escolhaOption.style.display = 'none';
                  }
                });
              
                // Recoloca os valores nos campos do formulário após submissão mal sucedida
                document.getElementById('locadoraSelect').value = locadoraSelectValue;
                document.getElementById('dataLocacao').value = dataLocacaoValue;
                document.getElementById('horario').value = horarioValue;
              
                // Obter o elemento de data
                const dataInput = document.getElementById('dataLocacao');
              
                // Obter o elemento de hora
                const horaInput = document.getElementById('horario');
              
                // Definir a data mínima do input de data
                dataInput.min = new Date().toISOString().split('T')[0];
                // Atualizar os valores permitidos do input de hora ao alterar a data
                dataInput.addEventListener('change', () => {
                  const dataSelecionada = new Date(dataInput.value).toISOString().split('T')[0];
                  console.log(dataSelecionada);
              
                  if (dataSelecionada == dataInput.min) {
                    const horaAtual = new Date().getHours();
                    horaInput.min = (horaAtual + 1).toString().padStart(2, '0') + ':00';
                  } else {
                    horaInput.min = '00:00';
                  }
                });
              });
        </script>
        
    </body>
    </fmt:bundle>
</html>
