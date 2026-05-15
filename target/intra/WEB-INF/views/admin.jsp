<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="관리자 설정"/>
<c:set var="activeMenu" value="admin"/>
<%@ include file="/WEB-INF/views/include/header.jsp"%>

        <div class="page page--admin">
          <!-- ① 리더십 범주 관리 -->
          <section class="admin-card" aria-labelledby="admin-cat-heading">
            <div class="admin-card__titlebar">
              <h2 id="admin-cat-heading" class="admin-card__title">리더십 범주</h2>
              <div class="admin-card__toolbar">
                <button type="button" class="btn btn--admin-teal" onclick="document.getElementById('new-cat-title').focus()">+ 범주 추가</button>
                <span id="cat-status" class="admin-save-status" aria-live="polite"></span>
              </div>
            </div>
            <div class="admin-new-category-row">
              <input type="text" id="new-cat-title" class="admin-input" placeholder="새 범주 제목 입력" autocomplete="off"
                onkeydown="if(event.key==='Enter') addCategory()">
              <input type="text" id="new-cat-dept"  class="admin-input" placeholder="담당부서명" autocomplete="off">
              <button type="button" class="btn btn--admin-teal" onclick="addCategory()">추가</button>
            </div>
            <ul id="admin-category-list" class="admin-category-list"></ul>
          </section>

          <!-- ② 경영계약 성과지표 관리 -->
          <section class="admin-card" aria-labelledby="admin-contract-heading">
            <div class="admin-card__titlebar">
              <h2 id="admin-contract-heading" class="admin-card__title">경영계약 성과지표</h2>
              <div class="admin-card__toolbar">
                <button type="button" class="btn btn--admin-teal" onclick="openGoalModal()">+ 성과목표 추가</button>
                <span id="admin-ind-status" class="admin-save-status" aria-live="polite"></span>
              </div>
            </div>
            <div id="admin-goal-list"></div>
          </section>

          <!-- ③ 데이터 백업·복원 -->
          <section class="admin-card admin-card--backup" aria-labelledby="admin-backup-heading">
            <div class="admin-card__titlebar">
              <h2 id="admin-backup-heading" class="admin-card__title">데이터 백업·복원</h2>
              <span id="admin-backup-status" class="admin-save-status" aria-live="polite"></span>
            </div>
            <div class="admin-backup__actions">
              <button type="button" class="btn btn--admin-teal" onclick="alert('백업 기능은 추후 지원됩니다.')">JSON 백업 다운로드</button>
              <button type="button" class="btn btn--danger" onclick="resetData()">초기화</button>
            </div>
          </section>
        </div>

  <!-- 성과목표 추가 모달 -->
  <div id="modal-admin-goal" class="cp-modal" aria-modal="true" role="dialog" hidden>
    <div class="cp-modal__backdrop" onclick="closeGoalModal()"></div>
    <div class="cp-modal__box">
      <div class="cp-modal__head">
        <h2 class="cp-modal__title">성과목표 추가</h2>
        <button type="button" class="cp-modal__x" aria-label="닫기" onclick="closeGoalModal()">×</button>
      </div>
      <div class="cp-modal__body">
        <input id="modal-admin-goal-input" type="text" class="cp-modal__input"
          placeholder="성과목표명을 입력하세요" autocomplete="off"
          onkeydown="if(event.key==='Enter'){event.preventDefault();saveGoal();} if(event.key==='Escape') closeGoalModal();">
      </div>
      <div class="cp-modal__footer">
        <button type="button" class="btn btn--secondary" onclick="closeGoalModal()">취소</button>
        <button type="button" class="btn btn--primary"   onclick="saveGoal()">추가</button>
      </div>
    </div>
  </div>

  <script>
  var CTX = "${pageContext.request.contextPath}";

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

  function showStatus(id, msg) {
    var el = document.getElementById(id);
    el.textContent = msg;
    setTimeout(function() { el.textContent = ""; }, 2000);
  }

  /* ── 리더십 범주 ── */
  function loadCategories() {
    ajax("GET", CTX + "/leadership/list.ajax.do", null, function(data, status) {
      if (status !== 200 || !data) return;
      var ul = document.getElementById("admin-category-list");
      var cats = data.categories || [];
      if (!cats.length) {
        ul.innerHTML = '<li class="admin-category-item">등록된 범주가 없습니다.</li>';
        return;
      }
      var html = "";
      for (var i = 0; i < cats.length; i++) {
        var cat = cats[i];
        html += '<li class="admin-category-item">'
          + '<span class="admin-category-item__num">' + (i + 1) + '.</span>'
          + '<span class="admin-category-item__title">' + (cat.title || "")
          + (cat.dept ? " (" + cat.dept + ")" : "") + '</span>'
          + '<span class="admin-category-item__count">중점과제 ' + (cat.tasks || []).length + '건</span>'
          + '<button type="button" class="btn btn--danger btn--sm" onclick="deleteCategory(\'' + cat.catId + '\')">삭제</button>'
          + '</li>';
      }
      ul.innerHTML = html;
    });
  }

  function addCategory() {
    var title = document.getElementById("new-cat-title").value.trim();
    var dept  = document.getElementById("new-cat-dept").value.trim();
    if (!title) { document.getElementById("new-cat-title").focus(); return; }
    ajax("POST", CTX + "/leadership/category/save.ajax.do", { title: title, dept: dept }, function(res) {
      if (res && res.result === "ok") {
        document.getElementById("new-cat-title").value = "";
        document.getElementById("new-cat-dept").value  = "";
        showStatus("cat-status", "저장되었습니다.");
        loadCategories();
      } else { alert("저장 실패"); }
    });
  }

  function deleteCategory(catId) {
    if (!confirm("범주를 삭제하시겠습니까?")) return;
    ajax("POST", CTX + "/leadership/category/delete.ajax.do", { catId: catId }, function(res) {
      if (res && res.result === "ok") { showStatus("cat-status", "삭제되었습니다."); loadCategories(); }
      else alert("삭제 실패");
    });
  }

  /* ── 경영계약 성과목표 ── */
  function loadContractGoals() {
    ajax("GET", CTX + "/contract/list.ajax.do", null, function(data, status) {
      if (status !== 200 || !data) return;
      var wrap = document.getElementById("admin-goal-list");
      var goals = data.goals || [];
      if (!goals.length) {
        wrap.innerHTML = '<p class="admin-empty">등록된 성과목표가 없습니다.</p>';
        return;
      }
      var html = "";
      for (var i = 0; i < goals.length; i++) {
        var g = goals[i];
        html += '<div class="admin-goal-item">'
          + '<span class="admin-category-item__num">' + (i + 1) + '.</span>'
          + '<span class="admin-goal-item__title">' + (g.title || "") + '</span>'
          + '<span class="admin-category-item__count">성과지표 ' + (g.indicators || []).length + '건</span>'
          + '<button type="button" class="btn btn--danger btn--sm" onclick="deleteGoal(\'' + g.goalId + '\')">삭제</button>'
          + '</div>';
      }
      wrap.innerHTML = html;
    });
  }

  function openGoalModal() {
    document.getElementById("modal-admin-goal-input").value = "";
    document.getElementById("modal-admin-goal").removeAttribute("hidden");
    setTimeout(function() { document.getElementById("modal-admin-goal-input").focus(); }, 0);
  }
  function closeGoalModal() {
    document.getElementById("modal-admin-goal").setAttribute("hidden", "");
  }
  function saveGoal() {
    var title = document.getElementById("modal-admin-goal-input").value.trim();
    if (!title) { document.getElementById("modal-admin-goal-input").focus(); return; }
    ajax("POST", CTX + "/contract/goal/save.ajax.do", { title: title }, function(res) {
      if (res && res.result === "ok") {
        closeGoalModal();
        showStatus("admin-ind-status", "저장되었습니다.");
        loadContractGoals();
      } else { alert("저장 실패"); }
    });
  }
  function deleteGoal(goalId) {
    if (!confirm("성과목표를 삭제하시겠습니까?")) return;
    ajax("POST", CTX + "/contract/goal/delete.ajax.do", { goalId: goalId }, function(res) {
      if (res && res.result === "ok") { showStatus("admin-ind-status", "삭제되었습니다."); loadContractGoals(); }
      else alert("삭제 실패");
    });
  }

  function resetData() {
    if (!confirm("모든 데이터를 초기화하시겠습니까?")) return;
    alert("초기화 기능은 추후 지원됩니다.");
  }

  loadCategories();
  loadContractGoals();
  </script>

<%@ include file="/WEB-INF/views/include/footer.jsp"%>
