<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
      </main>
    </div>
  </div>

  <%-- ===============================================================
       공통 JS
       - role.js      : 관리자/사용자 토글
       - side-panel.js: 사이드패널 UI
       - scroll-forward.js: 스크롤 UI
  =============================================================== --%>
  <script src="${pageContext.request.contextPath}/resources/js/role.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/side-panel.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/scroll-forward.js"></script>

  <%-- 페이지별 추가 JS (각 JSP에서 pageScript 변수로 전달) --%>
  ${pageScript}

</body>
</html>
