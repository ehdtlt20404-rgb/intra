<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="성과지표 상세"/>
<c:set var="activeMenu" value="contract"/>
<%@ include file="/WEB-INF/views/include/header.jsp"%>

        <div class="page page--contract-indicator">
          <div class="lead-task-crumb">
            <a href="${pageContext.request.contextPath}/contract/list.do" class="lead-task-crumb__back">‹ 경영계약 목록</a>
            <span class="lead-task-crumb__sep">/</span>
            <span class="lead-task-crumb__cat" id="crumb-goal"></span>
            <span class="lead-task-crumb__sep">/</span>
            <span class="lead-task-crumb__task" id="crumb-ind"></span>
          </div>

          <div class="lead-task-header">
            <div class="lead-task-header__name">
              <span class="lead-task-header__title" id="ind-name-header"></span>
            </div>
          </div>

          <div class="lead-task-panel">
            <input type="hidden" id="hdGoalId" value="${param.goalId}">
            <input type="hidden" id="hdIndId"  value="${param.indId}">
            <input type="hidden" id="hdSub"    value="${param.sub}">
            <input type="hidden" id="hdType"   value="qual">

            <div class="lead-detail-section">
              <h3 class="lead-detail-section__title">성과지표 기본정보</h3>
              <div class="lead-detail-field">
                <label class="lead-detail-label">성과지표명</label>
                <input type="text" id="ind-name" class="lead-modal__input">
              </div>
              <div class="lead-detail-field">
                <label class="lead-detail-label">유형</label>
                <div class="mi-type-group" role="group">
                  <button type="button" class="mi-type-btn" id="typeQual"  data-type="qual"  onclick="setType('qual')">비계량</button>
                  <button type="button" class="mi-type-btn" id="typeQuant" data-type="quant" onclick="setType('quant')">계량</button>
                </div>
              </div>
              <div class="lead-detail-field">
                <label class="lead-detail-label">담당부서</label>
                <input type="text" id="ind-dept" class="lead-modal__input">
              </div>
            </div>

            <div class="lead-detail-section">
              <h3 class="lead-detail-section__title">연도별 성과목표치</h3>
              <div class="mi-targets">
                <div class="mi-targets__col">
                  <div class="mi-targets__head">1차년도 (~'25)</div>
                  <input id="ind-t1" type="text" class="mi-targets__input">
                </div>
                <div class="mi-targets__col mi-targets__col--accent">
                  <div class="mi-targets__head">2차년도 (~'26)</div>
                  <input id="ind-t2" type="text" class="mi-targets__input">
                </div>
                <div class="mi-targets__col">
                  <div class="mi-targets__head">3차년도 (~'27)</div>
                  <input id="ind-t3" type="text" class="mi-targets__input">
                </div>
                <div class="mi-targets__col">
                  <div class="mi-targets__head">'26년도 연도말 계획</div>
                  <input id="ind-forecast" type="text" class="mi-targets__input">
                </div>
              </div>
            </div>

            <div class="lead-detail-section">
              <h3 class="lead-detail-section__title">달성계획 및 월별 실적</h3>
              <div class="lead-detail-field">
                <label class="lead-detail-label">달성계획</label>
                <textarea id="ind-plan" class="lead-modal__input lead-modal__input--textarea" rows="3"></textarea>
              </div>
              <div class="lead-month-grid" id="monthGrid"></div>
            </div>

            <div class="lead-detail-actions">
              <button type="button" class="btn btn--primary"   onclick="saveIndicator()">저장</button>
              <button type="button" class="btn btn--danger admin-only" onclick="deleteIndicator()">삭제</button>
              <button type="button" class="btn btn--secondary"
                onclick="location.href='${pageContext.request.contextPath}/contract/list.do'">목록으로</button>
            </div>
          </div>
        </div>

  <script>
  var CTX    = "${pageContext.request.contextPath}";
  var goalId = document.getElementById("hdGoalId").value;
  var indId  = document.getElementById("hdIndId").value;
  var sub    = document.getElementById("hdSub").value;

  function ajax(method, url, data, cb) {
    var xhr = new XMLHttpRequest();
    xhr.open(method, url, true);
    xhr.setRequestHeader("Content-Type", "application/json; charset=UTF-8");
    xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
    xhr.onreadystatechange = function() {
      if (xhr.readyState === 4) {
        try { cb(JSON.parse(xhr.responseText), xhr.status); }
        catch(e) { cb(null, xhr.status); }
      }
    };
    xhr.send(data ? JSON.stringify(data) : null);
  }

  function setType(type) {
    document.getElementById("hdType").value = type;
    document.getElementById("typeQual").className  = "mi-type-btn" + (type === "qual"  ? " is-active" : "");
    document.getElementById("typeQuant").className = "mi-type-btn" + (type === "quant" ? " is-active" : "");
  }

  function buildMonthGrid(months) {
    var html = "";
    var labels = ["1월","2월","3월","4월","5월","6월","7월","8월","9월","10월","11월","12월"];
    for (var i = 0; i < 12; i++) {
      var plan   = (months && months[i]) ? (months[i].plan   || "") : "";
      var result = (months && months[i]) ? (months[i].result || "") : "";
      html += '<div class="lead-month-cell">'
        + '<div class="lead-month-cell__header">' + labels[i] + '</div>'
        + '<input type="text" class="lead-month-cell__input" id="month_plan_'   + i + '" placeholder="계획" value="' + plan   + '">'
        + '<input type="text" class="lead-month-cell__input" id="month_result_' + i + '" placeholder="실적" value="' + result + '">'
        + '</div>';
    }
    document.getElementById("monthGrid").innerHTML = html;
  }

  function loadDetail() {
    if (!goalId || !indId) { buildMonthGrid([]); return; }
    var url = CTX + "/contract/indicator/detail.ajax.do?goalId=" + encodeURIComponent(goalId)
            + "&indId=" + encodeURIComponent(indId)
            + (sub ? "&sub=" + encodeURIComponent(sub) : "");
    ajax("GET", url, null, function(data, status) {
      if (status !== 200 || !data) { buildMonthGrid([]); return; }
      var goal = data.goal || {}, ind = data.indicator || {};
      document.getElementById("crumb-goal").textContent      = goal.title    || "";
      document.getElementById("crumb-ind").textContent       = ind.name      || "";
      document.getElementById("ind-name-header").textContent = ind.name      || "";
      document.getElementById("ind-name").value     = ind.name     || "";
      document.getElementById("ind-dept").value     = ind.dept     || "";
      document.getElementById("ind-t1").value       = ind.t1       || "";
      document.getElementById("ind-t2").value       = ind.t2       || "";
      document.getElementById("ind-t3").value       = ind.t3       || "";
      document.getElementById("ind-forecast").value = ind.forecast || "";
      document.getElementById("ind-plan").value     = ind.plan     || "";
      setType(ind.quant ? "quant" : "qual");
      buildMonthGrid(ind.months);
    });
  }

  function saveIndicator() {
    var months = [];
    for (var i = 0; i < 12; i++) {
      months.push({
        plan:   document.getElementById("month_plan_"   + i).value,
        result: document.getElementById("month_result_" + i).value
      });
    }
    var payload = {
      goalId:   goalId,
      indId:    indId,
      sub:      sub,
      name:     document.getElementById("ind-name").value,
      dept:     document.getElementById("ind-dept").value,
      quant:    document.getElementById("hdType").value === "quant",
      t1:       document.getElementById("ind-t1").value,
      t2:       document.getElementById("ind-t2").value,
      t3:       document.getElementById("ind-t3").value,
      forecast: document.getElementById("ind-forecast").value,
      plan:     document.getElementById("ind-plan").value,
      months:   months
    };
    ajax("POST", CTX + "/contract/indicator/detail/save.ajax.do", payload, function(res) {
      if (res && res.result === "ok") alert("저장되었습니다.");
      else alert("저장 실패");
    });
  }

  function deleteIndicator() {
    if (!confirm("성과지표를 삭제하시겠습니까?")) return;
    ajax("POST", CTX + "/contract/indicator/delete.ajax.do", { goalId: goalId, indId: indId }, function(res) {
      if (res && res.result === "ok") location.href = CTX + "/contract/list.do";
      else alert("삭제 실패");
    });
  }

  loadDetail();
  buildMonthGrid([]);
  </script>

<%@ include file="/WEB-INF/views/include/footer.jsp"%>
