<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="리더십"/>
<c:set var="activeMenu" value="leadership"/>
<%@ include file="/WEB-INF/views/include/header.jsp"%>

        <div class="page page--leadership">
          <div id="leadership-header" class="admin-only">
            <div class="lead-page-header">
              <h1 class="lead-page-header__title">리더십 범주</h1>
              <div class="lead-page-header__input-row">
                <input type="text" id="catDeptInp" class="admin-input lead-page-header__dept-input" placeholder="담당부서명">
                <input type="text" id="catInp" class="admin-input" placeholder="새 범주 제목 입력"
                  onkeydown="if(event.key==='Enter') addCategory()">
              </div>
              <div class="lead-page-header__btn-row">
                <button type="button" class="btn btn--admin-teal" onclick="addCategory()">+ 추가</button>
              </div>
            </div>
          </div>
          <div id="leadership-main" class="lead-page-panel"></div>
        </div>

  <!-- 중점과제 추가 모달 -->
  <div id="modal-keytask" class="cp-modal" aria-modal="true" role="dialog" hidden>
    <div class="cp-modal__backdrop" onclick="closeTaskModal()"></div>
    <div class="cp-modal__box">
      <div class="cp-modal__head">
        <h2 class="cp-modal__title">중점과제 추가</h2>
        <button type="button" class="cp-modal__x" aria-label="닫기" onclick="closeTaskModal()">×</button>
      </div>
      <div class="cp-modal__body">
        <input id="modal-keytask-input" type="text" class="cp-modal__input"
          placeholder="중점과제 과제명을 입력하세요" autocomplete="off"
          onkeydown="if(event.key==='Enter'){event.preventDefault();saveTask();} if(event.key==='Escape') closeTaskModal();">
        <input type="hidden" id="modal-keytask-catid">
      </div>
      <div class="cp-modal__footer">
        <button type="button" class="btn btn--secondary" onclick="closeTaskModal()">취소</button>
        <button type="button" class="btn btn--primary"   onclick="saveTask()">추가</button>
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

  /* ── 모달 ── */
  function openTaskModal(catId) {
    document.getElementById("modal-keytask-catid").value = catId;
    document.getElementById("modal-keytask-input").value = "";
    document.getElementById("modal-keytask").removeAttribute("hidden");
    setTimeout(function() { document.getElementById("modal-keytask-input").focus(); }, 0);
  }
  function closeTaskModal() {
    document.getElementById("modal-keytask").setAttribute("hidden", "");
  }

  /* ── 범주 추가 ── */
  function addCategory() {
    var title = document.getElementById("catInp").value.trim();
    var dept  = document.getElementById("catDeptInp").value.trim();
    if (!title) { document.getElementById("catInp").focus(); return; }
    ajax("POST", CTX + "/leadership/category/save.ajax.do", { title: title, dept: dept }, function(res) {
      if (res && res.result === "ok") {
        document.getElementById("catInp").value = "";
        document.getElementById("catDeptInp").value = "";
        renderLeadership();
      } else { alert("저장 실패"); }
    });
  }

  /* ── 범주 삭제 ── */
  function deleteCategory(catId) {
    if (!confirm("범주를 삭제하시겠습니까?")) return;
    ajax("POST", CTX + "/leadership/category/delete.ajax.do", { catId: catId }, function(res) {
      if (res && res.result === "ok") renderLeadership();
      else alert("삭제 실패");
    });
  }

  /* ── 중점과제 저장 ── */
  function saveTask() {
    var title = document.getElementById("modal-keytask-input").value.trim();
    var catId = document.getElementById("modal-keytask-catid").value;
    if (!title) { document.getElementById("modal-keytask-input").focus(); return; }
    ajax("POST", CTX + "/leadership/task/save.ajax.do", { catId: catId, title: title }, function(res) {
      if (res && res.result === "ok") { closeTaskModal(); renderLeadership(); }
      else alert("저장 실패");
    });
  }

  /* ── 목록 렌더 ── */
  function renderLeadership() {
    ajax("GET", CTX + "/leadership/list.ajax.do", null, function(data, status) {
      if (status !== 200 || !data) return;
      var main = document.getElementById("leadership-main");
      main.innerHTML = "";
      var categories = data.categories || [];

      if (!categories.length) {
        main.innerHTML = '<p class="lead-empty">등록된 범주가 없습니다.</p>';
        return;
      }

      var html = "";
      for (var i = 0; i < categories.length; i++) {
        var cat = categories[i];
        var headerId = "lead-cat-" + cat.catId;
        var tasks = cat.tasks || [];

        var taskRows = "";
        if (!tasks.length) {
          taskRows = '<li class="task-list__empty-notice"><div class="task-row task-row--static">'
            + '<span class="task-row__name task-row__name--muted">등록된 중점과제가 없습니다</span></div></li>';
        } else {
          for (var j = 0; j < tasks.length; j++) {
            var task = tasks[j];
            taskRows += '<li class="task-list__item">'
              + '<div class="task-row" style="cursor:pointer" onclick="goTask(\'' + cat.catId + '\',\'' + task.taskId + '\')">'
              + '<span class="task-row__name">' + (task.title || "") + '</span>'
              + '</div></li>';
          }
        }

        html += '<section class="lead-block" aria-labelledby="' + headerId + '">'
          + '<header class="lead-block__head">'
          + '<span class="lead-block__num" aria-hidden="true">' + (i + 1) + '</span>'
          + '<h2 id="' + headerId + '" class="lead-block__title">' + (cat.title || "") + '</h2>'
          + '<span class="lead-block__meta">' + (cat.dept || "") + '</span>'
          + '<button type="button" class="btn lead-block__del-btn admin-only" aria-label="범주 삭제" title="범주 삭제"'
          + ' onclick="deleteCategory(\'' + cat.catId + '\')">'
          + '<svg class="icon-trash" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">'
          + '<polyline points="3 6 5 6 21 6"></polyline>'
          + '<path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"></path>'
          + '<path d="M10 11v6"></path><path d="M14 11v6"></path>'
          + '<path d="M9 6V4a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v2"></path>'
          + '</svg></button>'
          + '</header>'
          + '<ul class="task-list">' + taskRows + '</ul>'
          + '</section>'
          + '<div class="lead-block__add-wrap admin-only">'
          + '<button type="button" class="btn btn--keytask-add" onclick="openTaskModal(\'' + cat.catId + '\')">중점과제 추가</button>'
          + '</div>';
      }
      main.innerHTML = html;
    });
  }

  function goTask(catId, taskId) {
    location.href = CTX + "/leadership/task.do?catId=" + encodeURIComponent(catId) + "&taskId=" + encodeURIComponent(taskId);
  }

  renderLeadership();
  </script>

<%@ include file="/WEB-INF/views/include/footer.jsp"%>
