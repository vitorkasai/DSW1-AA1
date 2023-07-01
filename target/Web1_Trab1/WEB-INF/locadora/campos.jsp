<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<% System.out.println("PASSEI POR: WEB-INF/locadora/campos.jsp"); %> 

<table border="1">
	<caption>
   		<c:choose>
   			<c:when test="${locadora != null}">
				Edição
            </c:when>
   			<c:otherwise>
				Cadastro
            </c:otherwise>
   		</c:choose>
	</caption>
 	<c:if test="${locadora != null}">
   		<input type="hidden" name="id" value="${locadora.id}" />
   	</c:if>
   	<tr>
   		<td><label for="email">Email</label></td>
   		<td><input type="email" id="email" name="email" size="45"
   			required value="${locadora.email}" maxlength="256"/></td>
   	</tr>
   	<tr>
   		<td><label for="senha">Senha</label></td>
   		<td><input type="text" id="senha" name="senha" size="45" required
   			value="${locadora.senha}" maxlength="256" /></td>
   	</tr>
	<tr>
		<td><label for="nome">Nome</label></td>
		<td><input type="text" id="nome" name="nome" size="45" required
			value="${locadora.nome}" maxlength="256" /></td>
	</tr>
	<tr>
		<td><label for="cnpj">CNPJ</label></td>
		<td><input type="text" id="cnpj" name="cnpj" size="45" required
			value="${locadora.CNPJ}" maxlength="14" /></td>
	</tr>
	<tr>
		<td><label for="cidade">Cidade</label></td>
		<td>
			<select id="cidade" name="cidade" required>
			</select>
		</td>
	</tr>
	<tr>
		<td>
			<c:choose>
				<c:when test="${locadora.administrador == '1'}">
					<input type="checkbox" name="administrador" id="administrador" value="1" checked>
					<label for="administrador">Administrador</label>
				</c:when>
				<c:otherwise>
					<input type="checkbox" name="administrador" id="administrador" value="1">
					<label for="administrador">Administrador</label>
				</c:otherwise>
			</c:choose>		
		</td>
	</tr>
	<script>
		window.addEventListener('DOMContentLoaded', function() {
			loadCidades();
		});
	
		function loadCidades() {
			var cidadeSelect = document.getElementById('cidade');
			var xhr = new XMLHttpRequest();
			xhr.open('GET', '${pageContext.request.contextPath}/documentos/cidades.txt', true); // Substitua 'cidades.txt' pelo caminho correto do seu arquivo .txt de cidades
			xhr.onreadystatechange = function() {
				if (xhr.readyState === 4 && xhr.status === 200) {
					var cidades = xhr.responseText.split('\n');
					for (var i = 0; i < cidades.length; i++) {
						var option = document.createElement('option');
						option.text = cidades[i];
						cidadeSelect.add(option);
					}
				}
			};
			xhr.send();
		}
	</script>
   	<tr>
		<!-- Substituir value depois por <fmt:message key="save" /> / -->
   		<td colspan="2" align="center"><input type="submit" value="Salvar"></td>
   	</tr>
</table>

