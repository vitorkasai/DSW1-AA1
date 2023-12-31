package br.ufscar.dc.dsw.controller;

import br.ufscar.dc.dsw.dao.LocadoraDAO;
import br.ufscar.dc.dsw.dao.ClienteDAO;
import br.ufscar.dc.dsw.dao.LocacaoDAO;
import br.ufscar.dc.dsw.domain.Locadora;
import br.ufscar.dc.dsw.domain.Usuario;
import br.ufscar.dc.dsw.domain.Locacao;
import java.io.IOException;
import java.sql.Time;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet(urlPatterns = { "/locacoes/*" })
public class LocacaoController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private ClienteDAO daoCliente;
    private LocadoraDAO daoLocadora;
    private LocacaoDAO daoLocacao;

    @Override
    public void init() {
        daoCliente = new ClienteDAO();
        daoLocadora = new LocadoraDAO();
        daoLocacao = new LocacaoDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("PASSEI POR: LocacaoController");
        
        java.sql.Date dataAtualSistema = new java.sql.Date(System.currentTimeMillis());

		Calendar calendar = Calendar.getInstance();
		int hour = calendar.get(Calendar.HOUR_OF_DAY);
		Time horaAtualSistema = new Time(hour, 0, 0);

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		String dataAtualSistemaString = dateFormat.format(dataAtualSistema);
		request.setAttribute("horaAtualSistema", horaAtualSistema);
		request.setAttribute("dataAtualSistemaString", dataAtualSistemaString);
        
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuarioLogado");

        if (usuario == null || usuario.getTipoUsuario().equals("L")) {
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin");
            dispatcher.forward(request, response);
            return;
        }
        String action = request.getPathInfo();
        System.out.println("ACTION -> " + request.getPathInfo());
        if (action == null) {
            action = "";
        }

        try {

            switch (action) {
                case "/cadastro":
                    apresentaFormCadastro(request, response);
                    break;

                case "/insercao":
                    insere(request, response);
                    break;

                default:
                    lista(request, response);
                    break;
            }
        } catch (RuntimeException | IOException | ServletException e) {
            throw new ServletException(e);
        }
    }

    private void lista(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // List<Locacao> listaLocacoes = daoLocacao.getAll();
        // request.getSession().setAttribute("listaLocacoes", listaLocacoes);
        request.getSession().setAttribute("listaLocacoes", daoLocacao.getAll());
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/logado/usuario/index.jsp");
        dispatcher.forward(request, response);
    }


    private void apresentaFormCadastro(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getSession().setAttribute("listaLocadoras", new LocadoraDAO().getAll());
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/locacao/formulario.jsp");
        dispatcher.forward(request, response);
    }

    private void insere(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {

            SimpleDateFormat reFormat = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date data_sem_formatar = reFormat.parse(request.getParameter("dataLocacao"));
            java.sql.Date dataLocacao = new java.sql.Date(data_sem_formatar.getTime());

            String horarioString = request.getParameter("horario");
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
            java.util.Date horario_sem_formatar = timeFormat.parse(horarioString);
            java.sql.Time horario = new java.sql.Time(horario_sem_formatar.getTime());
            
            Locadora locadora = daoLocadora.get(Long.parseLong(request.getParameter("locadoraId")));
            Usuario usuario = (Usuario) request.getSession().getAttribute("usuarioLogado");
            Locacao locacao = new Locacao(daoCliente.get(usuario.getId()), locadora,
                    dataLocacao, horario);
            
            if (!daoLocacao.existeLocacao(locadora.getCidade(), dataLocacao, horario)) {
                daoLocacao.insert(locacao);
                request.setAttribute("erroLocacao", "");
                request.setAttribute("locadoraParaEmail", locadora);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/SendEmail");
                dispatcher.forward(request, response);
                // response.sendRedirect("lista");
            }
            else {
                request.setAttribute("erroLocacao", "Horário indisponível");
                //apresentaFormCadastro(request, response);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/locacao/formulario.jsp");
                dispatcher.forward(request, response);
            }
            
        } catch (ParseException | RuntimeException | IOException e) {
            throw new ServletException(e);
        }
    }
}
