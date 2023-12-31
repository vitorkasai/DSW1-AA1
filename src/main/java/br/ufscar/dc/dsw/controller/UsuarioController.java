package br.ufscar.dc.dsw.controller;

import java.io.IOException;
import java.util.Calendar;
import java.sql.Time;
import java.text.SimpleDateFormat;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import br.ufscar.dc.dsw.domain.Usuario;
import br.ufscar.dc.dsw.util.Erro;


@WebServlet(urlPatterns = { "/usuario/*" })
public class UsuarioController extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("PASSEI POR: UsuarioController");
		
		java.sql.Date dataAtualSistema = new java.sql.Date(System.currentTimeMillis());

		Calendar calendar = Calendar.getInstance();
		int hour = calendar.get(Calendar.HOUR_OF_DAY);
		Time horaAtualSistema = new Time(hour, 0, 0);

		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		String dataAtualSistemaString = dateFormat.format(dataAtualSistema);
		request.setAttribute("horaAtualSistema", horaAtualSistema);
		request.setAttribute("dataAtualSistemaString", dataAtualSistemaString);
			

		Usuario usuario = (Usuario) request.getSession().getAttribute("usuarioLogado");
		Erro erros = new Erro();
		if (usuario == null) {
			response.sendRedirect(request.getContextPath());
		} else if (usuario.getAdministrador().equals("0")) {

			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/logado/usuario/index.jsp");
			dispatcher.forward(request, response);

		} else {
			erros.add("acesso_negado_usuario");
			request.setAttribute("mensagens", erros);
			RequestDispatcher rd = request.getRequestDispatcher("/noAuth.jsp");
			rd.forward(request, response);
		}
	}
}
