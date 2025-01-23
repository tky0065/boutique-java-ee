package com.enokdev.boutique.interceptor;

import com.enokdev.boutique.config.RolePermissions;
import com.enokdev.boutique.model.Utilisateur;
import com.enokdev.boutique.utils.RequiredPermission;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
@RequiredArgsConstructor
public class AuthenticationInterceptor implements HandlerInterceptor {

    private final RolePermissions rolePermissions;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String path = request.getRequestURI();

        if (path.startsWith("/resources") || path.startsWith("/auth")) {
            return true;
        }

        HttpSession session = request.getSession();
        Long userId = (Long) session.getAttribute("userId");
        Utilisateur.Role userRole = (Utilisateur.Role) session.getAttribute("userRole");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return false;
        }

        if (handler instanceof HandlerMethod) {
            HandlerMethod handlerMethod = (HandlerMethod) handler;

            RequiredPermission permissionAnn = handlerMethod.getMethodAnnotation(RequiredPermission.class);
            if (permissionAnn == null) {
                permissionAnn = handlerMethod.getBeanType().getAnnotation(RequiredPermission.class);
            }

            if (permissionAnn != null) {
                boolean hasPermission = rolePermissions.hasPermission(userRole, permissionAnn.value());
                if (!hasPermission) {
                    response.sendRedirect(request.getContextPath() + "/errors/acces-refuse");
                    return false;
                }
            }
        }

        return true;
    }
}

