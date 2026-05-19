<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="기타 주요 활동"/>
<c:set var="activeMenu" value="activities"/>
<%@ include file="/WEB-INF/views/include/header.jsp"%>

        <div class="page page--activities">
          <section class="activities-panel" aria-labelledby="activities-heading">
            <h2 id="activities-heading" class="visually-hidden">기타 주요 활동</h2>
            <div class="activities-toolbar">
              <a href="${pageContext.request.contextPath}/activities/register.do?category=etc" class="btn btn--primary">+ 활동실적</a>
            </div>
            <div class="activities-table-wrap">
              <table class="activities-table">
                <colgroup>
                  <col style="width:3.5rem">
                  <col>
                  <col style="width:12rem">
                  <col style="width:8rem">
                  <col style="width:4rem">
                </colgroup>
                <thead>
                  <tr>
                    <th scope="col" class="activities-table__col-no">No.</th>
                    <th scope="col">활동내용</th>
                    <th scope="col" class="activities-table__col-narrow">활동유형</th>
                    <th scope="col" class="activities-table__col-date">활동 일자</th>
                    <th scope="col" class="activities-table__col-narrow">첨부</th>
                  </tr>
                </thead>
                <tbody>
                  <c:choose>
                    <c:when test="${empty activities}">
                      <tr class="activities-table__empty-row">
                        <td colspan="5">등록된 활동실적이 없습니다.</td>
                      </tr>
                    </c:when>
                    <c:otherwise>
                      <c:forEach var="a" items="${activities}" varStatus="s">
                        <tr class="activities-table__row" style="cursor:pointer"
                            onclick="location.href='${pageContext.request.contextPath}/activities/edit.do?actId=${a.actId}'">
                          <td class="activities-table__col-no">${s.count}</td>
                          <td><c:out value="${a.title}"/></td>
                          <td class="activities-table__col-narrow"><c:out value="${a.typePrimary}"/></td>
                          <td class="activities-table__col-date"><c:out value="${a.actDate}"/></td>
                          <td class="activities-table__proof-cell">${not empty a.proof ? 'O' : '-'}</td>
                        </tr>
                      </c:forEach>
                    </c:otherwise>
                  </c:choose>
                </tbody>
              </table>
            </div>
          </section>
        </div>

<%@ include file="/WEB-INF/views/include/footer.jsp"%>
