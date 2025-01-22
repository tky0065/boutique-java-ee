
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${empty sessionScope.utilisateur}">
    <c:redirect url="/auth/login"/>
</c:if>

<jsp:forward page="/dashboard"/>
