package com.enokdev.boutique.interceptor;

import com.enokdev.boutique.model.Utilisateur;
import com.enokdev.boutique.utils.RequiredRole;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;

import java.util.Arrays;

@Component
@RequiredArgsConstructor
public class RoleInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        if (!(handler instanceof HandlerMethod)) {
            return true;
        }

        HandlerMethod handlerMethod = (HandlerMethod) handler;
        RequiredRole requiredRole = handlerMethod.getMethodAnnotation(RequiredRole.class);

        if (requiredRole == null) {
            requiredRole = handlerMethod.getBeanType().getAnnotation(RequiredRole.class);
        }

        if (requiredRole == null) {
            return true;
        }

        HttpSession session = request.getSession();
        Utilisateur.Role userRole = (Utilisateur.Role) session.getAttribute("userRole");

        if (userRole == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        boolean hasPermission = Arrays.asList(requiredRole.value()).contains(userRole);

        if (!hasPermission) {
            response.sendRedirect(request.getContextPath() + "/erros/acces-refuse");
            return false;
        }

        return true;
    }
}