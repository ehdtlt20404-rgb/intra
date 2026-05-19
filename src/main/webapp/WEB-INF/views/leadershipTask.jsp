<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="중점과제 상세"/>
<c:set var="activeMenu" value="leadership"/>
<%@ include file="/WEB-INF/views/include/header.jsp"%>

        <div class="page page--leadership-task" id="leadership-task-main">
          <div class="lead-task-crumb">
            <a href="${pageContext.request.contextPath}/leadership/list.do" class="lead-task-crumb__back">‹ 리더십 목록</a>
            <span class="lead-task-crumb__sep">/</span>
            <span class="lead-task-crumb__cat" id="crumb-cat"></span>
            <span class="lead-task-crumb__sep">/</span>
            <span class="lead-task-crumb__task" id="crumb-task"></span>
          </div>
          <div class="lead-task-header">
            <div class="lead-task-header__name">
              <span class="lead-task-header__num" id="task-num"></span>
              <span class="lead-task-header__title" id="task-title"></span>
            </div>
            <div class="lead-task-header__aside">
              <button type="button" id="btn-act-add" class="lead-task-header__act-add">+ 활동실적</button>
            </div>
          </div>
          <div class="lead-task-panel">
            <form id="taskDetailForm">
              <input type="hidden" id="hdCatId"  name="catId"  value="${param.catId}">
              <input type="hidden" id="hdTaskId" name="taskId" value="${param.taskId}">
              <div class="lead-detail-section">
                <h3 class="lead-detail-section__title">KPI 기본정보</h3>
                <div class="lead-detail-field">
                  <label class="lead-detail-label">KPI명</label>
                  <input type="text" name="kpiName" id="kpiName" class="lead-modal__input">
                </div>
                <div class="lead-detail-field">
                  <label class="lead-detail-label">세부항목</label>
                  <input type="text" name="subItem" id="subItem" class="lead-modal__input">
                </div>
              </div>
              <div class="lead-detail-section">
                <h3 class="lead-detail-section__title">배경 및 방향</h3>
                <div class="lead-detail-field">
                  <label class="lead-detail-label">① 환경 인식</label>
                  <textarea name="bgEnv" id="bgEnv" class="lead-modal__input lead-modal__input--textarea" rows="3"></textarea>
                </div>
                <div class="lead-detail-field">
                  <label class="lead-detail-label">② 기관장 방향</label>
                  <textarea name="bgLeader" id="bgLeader" class="lead-modal__input lead-modal__input--textarea" rows="3"></textarea>
                </div>
                <div class="lead-detail-field">
                  <label class="lead-detail-label">③ 추진방향</label>
                  <textarea name="direction" id="direction" class="lead-modal__input lead-modal__input--textarea" rows="3"></textarea>
                </div>
              </div>
              <div class="lead-detail-section">
                <h3 class="lead-detail-section__title">활동계획</h3>
                <div class="lead-detail-field">
                  <label class="lead-detail-label">활동유형</label>
                  <input type="text" name="actType" id="actType" class="lead-modal__input">
                </div>
                <div class="lead-detail-field">
                  <label class="lead-detail-label">주요 활동내용</label>
                  <textarea name="actMain" id="actMain" class="lead-modal__input lead-modal__input--textarea" rows="3"></textarea>
                </div>
                <div class="lead-detail-field">
                  <label class="lead-detail-label">세부 활동내용</label>
                  <textarea name="actDetail" id="actDetail" class="lead-modal__input lead-modal__input--textarea" rows="3"></textarea>
                </div>
              </div>
              <div class="lead-detail-section">
                <h3 class="lead-detail-section__title">일정 및 기대효과</h3>
                <div class="lead-detail-field">
                  <label class="lead-detail-label">추진일정</label>
                  <textarea name="schedule" id="schedule" class="lead-modal__input lead-modal__input--textarea" rows="2"></textarea>
                </div>
                <div class="lead-detail-field">
                  <label class="lead-detail-label">기대성과</label>
                  <textarea name="expected" id="expected" class="lead-modal__input lead-modal__input--textarea" rows="2"></textarea>
                </div>
              </div>
              <div class="lead-detail-section">
                <h3 class="lead-detail-section__title">월별 계획 / 실적</h3>
                <div class="lead-month-grid" id="monthGrid"></div>
              </div>
              <div class="lead-detail-actions">
                <button type="button" id="btnSave" class="btn btn--primary">저장</button>
                <button type="button" class="btn btn--secondary"
                  onclick="location.href='${pageContext.request.contextPath}/leadership/list.do'">목록으로</button>
              </div>
            </form>
          </div>
        </div>

  <script>
  var CTX    = "${pageContext.request.contextPath}";
  var catId  = document.getElementById("hdCatId").value;
  var taskId = document.getElementById("hdTaskId").value;

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

  function buildMonthGrid(months) {
    var grid = document.getElementById("monthGrid");
    grid.innerHTML = "";
    var labels = ["1월","2월","3월","4월","5월","6월","7월","8월","9월","10월","11월","12월"];
    labels.forEach(function(lbl, i) {
      var cell = document.createElement("div");
      cell.className = "lead-month-cell";
      var hd = document.createElement("div");
      hd.className = "lead-month-cell__header";
      hd.textContent = lbl;
      var planInp = document.createElement("input");
      planInp.type = "text"; planInp.className = "lead-month-cell__input";
      planInp.placeholder = "계획"; planInp.id = "month_plan_" + i;
      planInp.value = (months && months[i]) ? (months[i].plan || "") : "";
      var resultInp = document.createElement("input");
      resultInp.type = "text"; resultInp.className = "lead-month-cell__input";
      resultInp.placeholder = "실적"; resultInp.id = "month_result_" + i;
      resultInp.value = (months && months[i]) ? (months[i].result || "") : "";
      cell.appendChild(hd); cell.appendChild(planInp); cell.appendChild(resultInp);
      grid.appendChild(cell);
    });
  }

  function loadTaskDetail() {
    if (!catId || !taskId) return;
    ajax("GET", CTX + "/leadership/task/detail.ajax.do?catId=" + encodeURIComponent(catId) + "&taskId=" + encodeURIComponent(taskId),
      null, function(data, status) {
        if (status !== 200 || !data) return;
        var cat = data.category || {}, task = data.task || {}, detail = task.detail || {};
        document.getElementById("crumb-cat").textContent  = cat.title || "";
        document.getElementById("crumb-task").textContent = "중점과제 " + (data.taskIdx + 1);
        document.getElementById("task-num").textContent   = "중점과제 " + (data.taskIdx + 1);
        document.getElementById("task-title").textContent = task.title || "";
        document.getElementById("kpiName").value   = detail.kpiName   || "";
        document.getElementById("subItem").value   = detail.subItem   || "";
        document.getElementById("bgEnv").value     = detail.bgEnv     || "";
        document.getElementById("bgLeader").value  = detail.bgLeader  || "";
        document.getElementById("direction").value = detail.direction || "";
        document.getElementById("actType").value   = detail.actType   || "";
        document.getElementById("actMain").value   = detail.actMain   || "";
        document.getElementById("actDetail").value = detail.actDetail || "";
        document.getElementById("schedule").value  = detail.schedule  || "";
        document.getElementById("expected").value  = detail.expected  || "";
        buildMonthGrid(detail.months);
      }
    );
  }

  document.getElementById("btnSave").addEventListener("click", function() {
    var months = [];
    for (var i = 0; i < 12; i++) {
      months.push({
        plan:   document.getElementById("month_plan_"   + i).value,
        result: document.getElementById("month_result_" + i).value
      });
    }
    var payload = {
      catId: catId, taskId: taskId,
      kpiName:   document.getElementById("kpiName").value,
      subItem:   document.getElementById("subItem").value,
      bgEnv:     document.getElementById("bgEnv").value,
      bgLeader:  document.getElementById("bgLeader").value,
      direction: document.getElementById("direction").value,
      actType:   document.getElementById("actType").value,
      actMain:   document.getElementById("actMain").value,
      actDetail: document.getElementById("actDetail").value,
      schedule:  document.getElementById("schedule").value,
      expected:  document.getElementById("expected").value,
      months:    months
    };
    ajax("POST", CTX + "/leadership/task/detail/save.ajax.do", payload, function(res) {
      if (res && res.result === "ok") alert("저장되었습니다.");
      else alert("저장 실패");
    });
  });

  document.getElementById("btn-act-add").addEventListener("click", function() {
    location.href = CTX + "/activities/register.do?catId=" + encodeURIComponent(catId) + "&taskId=" + encodeURIComponent(taskId) + "&category=leadership";
  });

  loadTaskDetail();
  buildMonthGrid([]);
  </script>

<%@ include file="/WEB-INF/views/include/footer.jsp"%>
