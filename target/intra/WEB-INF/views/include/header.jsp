<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=1280">
  <title>${pageTitle} — 기관장 실적·성과 관리시스템</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/styles.css">
</head>
<body>
  <div class="app-layout">
    <header class="app-top">
      <a href="${pageContext.request.contextPath}/main.do" class="app-top__brand" aria-label="홈">
        <span class="app-top__logo">
          <img src="${pageContext.request.contextPath}/resources/img/ci.png" alt="CI">
        </span>
      </a>
      <nav class="app-top__nav" aria-label="주 메뉴">
        <a href="${pageContext.request.contextPath}/leadership/list.do"
           class="app-top__nav-link ${activeMenu == 'leadership' ? 'is-active' : ''}">리더십</a>
        <a href="${pageContext.request.contextPath}/contract/list.do"
           class="app-top__nav-link ${activeMenu == 'contract' ? 'is-active' : ''}">경영계약 이행성과</a>
        <a href="${pageContext.request.contextPath}/activities/list.do"
           class="app-top__nav-link ${activeMenu == 'activities' ? 'is-active' : ''}">기타 주요 활동</a>
        <a href="${pageContext.request.contextPath}/activities/all.do"
           class="app-top__nav-link ${activeMenu == 'allActivities' ? 'is-active' : ''}"
           style="display:none;">기관장 활동내역</a>
      </nav>
      <div class="app-top__tools">
        <div class="role-toggle" aria-label="화면 모드">
          <button type="button" class="role-btn" data-role="admin">관리자</button>
          <button type="button" class="role-btn" data-role="user">사용자</button>
        </div>
      </div>
    </header>

    <div class="app-body">
      <aside class="side-panel" aria-label="보조 메뉴">
        <div class="side-panel__section" aria-expanded="true">
          <button type="button" class="side-panel__section-header">
            연도 선택 <span class="side-panel__chev">˅</span>
          </button>
          <ul class="side-panel__year-list">
            <li><button type="button" class="side-panel__year-item is-active">2026년</button></li>
          </ul>
        </div>
        <div class="side-panel__divider"></div>
        <div class="side-panel__links">
          <a href="#" class="side-panel__link">공지사항</a>
          <a href="#" class="side-panel__link">자료실</a>
        </div>
        <div class="side-panel__footer">
          © 2024 기관장 실적·성과 관리시스템<br>All rights reserved.<br>v 1.0.0
        </div>
      </aside>

      <main class="app-main">
