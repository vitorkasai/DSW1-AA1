package br.ufscar.dc.dsw.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.sql.Date;
import java.sql.Time;

import br.ufscar.dc.dsw.domain.Locacao;

// Não possui um update() pois não faz sentido editar uma locação (apenas excluir e/ou realizar outra)
public class LocacaoDAO extends GenericDAO {

    public List<Locacao> getAll() {
        System.out.println("Passei por LocacaoDAO.java");
        List<Locacao> listaLocacoes = new ArrayList<>();
        // Retorna todas as colunas de locadora e também aqueles dados vindos da classe pai Usuario
        String sql = "SELECT * FROM locacao;";

        try {
            Connection conn = this.getConnection();
            Statement statement = conn.createStatement();
;
            ResultSet resultSet = statement.executeQuery(sql);
            while (resultSet.next()) {
                String CPF = resultSet.getString("CPF");
                String CNPJ = resultSet.getString("CNPJ");
                Date dia = resultSet.getDate("dia");
                Time horario = resultSet.getTime("horario");
                Locacao locacao = new Locacao(new ClienteDAO().get(CPF), new LocadoraDAO().get(CNPJ), dia, horario);
                listaLocacoes.add(locacao);
            }

            resultSet.close();
            statement.close();
            conn.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return listaLocacoes;
    }

    public Locacao get(String CPF, String CNPJ, Date dia, Time horario) {
        Locacao locacao = null;   
        String sql = "SELECT * FROM locacao WHERE CPF = ? AND CNPJ = ? AND dia = ? AND horario = ?;";

        try {
            Connection conn = this.getConnection();
            PreparedStatement statement = conn.prepareStatement(sql);
            
            statement.setString(1, CPF);
            statement.setString(2, CNPJ);
            statement.setDate(3, dia);
            statement.setTime(4, horario);

            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                locacao = new Locacao(new ClienteDAO().get(CPF), new LocadoraDAO().get(CNPJ), dia, horario);
            }

            resultSet.close();
            statement.close();
            conn.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
     return locacao;
    }

    public void insert(Locacao locacao) {

        String sql = "INSERT INTO locacao (CPF, CNPJ, dia, horario) VALUES (?, ?, ?, ?);";

        try {
            Connection conn = this.getConnection();
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setString(1, locacao.getCliente().getCPF());
            statement.setString(2, locacao.getLocadora().getCNPJ());
            statement.setDate(3, locacao.getDia());
            statement.setTime(4, locacao.getHorario());
            statement.executeUpdate();

            statement.close();
            conn.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void delete(Locacao locacao) {
        
        String sql = "DELETE FROM locacao WHERE CPF = ?, CNPJ = ?, dia = ?, horario = ?";

        try {
            Connection conn = this.getConnection();
            PreparedStatement statement = conn.prepareStatement(sql);

            statement.setString(1, locacao.getCliente().getCPF());
            statement.setString(2, locacao.getLocadora().getCNPJ());
            statement.setDate(3, locacao.getDia());
            statement.setTime(4, locacao.getHorario());
            statement.executeUpdate();

            statement.close();
            conn.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

}
