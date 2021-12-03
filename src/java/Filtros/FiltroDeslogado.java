/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Filtros;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author brunops
 */
public class FiltroDeslogado implements Filter {
    @Override
    public void init(FilterConfig fc) throws ServletException {}
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain) throws IOException, ServletException {
            request.setCharacterEncoding("UTF-8");
            response.setContentType("text/html; charset=UTF-8");
    
        HttpServletRequest httpServletRequest = (HttpServletRequest) request;
                
        HttpSession sessao  = httpServletRequest.getSession();
        
        if(sessao.getAttribute("ativo") == null)
            chain.doFilter(request, response);
        else
            ((HttpServletResponse)response).sendRedirect("index.jsp");
    }
    
    @Override
    public void destroy() { }
}