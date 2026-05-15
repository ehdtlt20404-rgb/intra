<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="경영계약 이행성과"/>
<c:set var="activeMenu" value="contract"/>
<%@ include file="/WEB-INF/views/include/header.jsp"%>

        <div class="page page--contract">
          <!-- 관리자 전용: 성과목표 추가 버튼 -->
          <div class="contract-toolbar admin-only">
            <button type="button" id="btnGoalAdd" class="btn btn--admin-teal">+ 성과목표 추가</button>
          </div>
          <section class="contract-panel" aria-labelledby="contract-intro">
            <p id="contract-intro" class="page-intro">
              성과지표 행을 클릭하면 상세 페이지로 이동합니다.
            </p>
            <div class="contract-table-wrap contract-table-wrap--perf">
              <table class="contract-table contract-table--perf">
                <thead>
                  <tr>
                    <th scope="col">성과목표</th>
                    <th scope="col">성과지표</th>
                    <th scope="col" class="contract-table__col-type">유형</th>
                    <th scope="col" class="contract-table__col-target">'26 목표치</th>
                  </tr>
                </thead>
                <tbody id="contract-perf-tbody"></tbody>
              </table>
            </div>
          </section>
        </div>

  <!-- 성과목표 추가 모달 -->
  <div id="modal-goal" class="cp-modal" aria-modal="true" role="dialog" hidden>
    <div class="cp-modal__backdrop"></div>
    <div class="cp-modal__box">
      <div class="cp-modal__head">
        <h2 class="cp-modal__title">성과목표 추가</h2>
        <button type="button" class="cp-modal__x" id="modal-goal-x" aria-label="닫기">×</button>
      </div>
      <div class="cp-modal__body">
        <label class="cp-modal__label" for="modal-goal-input">성과목표명</label>
        <input id="modal-goal-input" type="text" class="cp-modal__input" placeholder="성과목표명을 입력하세요" autocomplete="off">
      </div>
      <div class="cp-modal__footer">
        <button type="button" class="btn btn--secondary" id="modal-goal-cancel">취소</button>
        <button type="button" class="btn btn--primary" id="modal-goal-save">추가</button>
      </div>
    </div>
  </div>

  <!-- 성과지표 추가 모달 -->
  <div id="modal-ind" class="cp-modal" aria-modal="true" role="dialog" hidden>
    <div class="cp-modal__backdrop"></div>
    <div class="cp-modal__box cp-modal__box--wide">
      <div class="cp-modal__head">
        <h2 class="cp-modal__title">성과지표 추가</h2>
        <button type="button" class="cp-modal__x" id="modal-ind-x" aria-label="닫기">×</button>
      </div>
      <div class="cp-modal__body">
        <input type="hidden" id="modal-ind-goalid">
        <div class="mi-card">
          <div class="mi-card__name">
            <label class="mi-card__label" for="mi-name">성과지표명</label>
            <input id="mi-name" type="text" class="mi-card__input" placeholder="성과지표명" autocomplete="off">
          </div>
          <div class="mi-card__aside">
            <div class="mi-field-inline">
              <span class="mi-card__label">유형</span>
              <div class="mi-type-group" role="group">
                <button type="button" class="mi-type-btn is-active" data-type="qual">비계량</button>
                <button type="button" class="mi-type-btn" data-type="quant">계량</button>
              </div>
              <input type="hidden" id="mi-type" value="qual">
            </div>
            <div class="mi-field-inline">
              <label class="mi-card__label" for="mi-dept">담당부서</label>
              <input id="mi-dept" type="text" class="mi-card__input" placeholder="부서명" autocomplete="off">
            </div>
          </div>
        </div>
        <div class="mi-section">
          <h3 class="mi-section__title">연도별 성과목표치</h3>
          <div class="mi-targets">
            <div class="mi-targets__col">
              <div class="mi-targets__head">1차년도 (~'25)</div>
              <input id="mi-t1" type="text" class="mi-targets__input">
            </div>
            <div class="mi-targets__col mi-targets__col--accent">
              <div class="mi-targets__head">2차년도 (~'26)</div>
              <input id="mi-t2" type="text" class="mi-targets__input">
            </div>
            <div class="mi-targets__col">
              <div class="mi-targets__head">3차년도 (~'27)</div>
              <input id="mi-t3" type="text" class="mi-targets__input">
            </div>
            <div class="mi-targets__col">
              <div class="mi-targets__head">'26년도 연도말 계획</div>
              <input id="mi-forecast" type="text" class="mi-targets__input" placeholder="계획값">
            </div>
          </div>
        </div>
      </div>
      <div class="cp-modal__footer">
        <button type="button" class="btn btn--secondary" id="modal-ind-cancel">취소</button>
        <button type="button" class="btn btn--primary" id="modal-ind-save">추가</button>
      </div>
    </div>
  </div>

  <script>
  var CTX = "${pageContext.request.contextPath}";
  var modalGoal = document.getElementById("modal-goal");
  var modalInd  = document.getElementById("modal-ind");

  /* ── AJAX 유틸 ── */
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

  /* ── 테이블 렌더 ── */
  function renderContract() {
    ajax("GET", CTX + "/contract/list.ajax.do", null, function(data, status) {
      if (status !== 200 || !data) return;
      var tbody = document.getElementById("contract-perf-tbody");
      tbody.innerHTML = "";
      var goals = data.goals || [];

      if (!goals.length) {
        var trE = document.createElement("tr");
        var tdE = document.createElement("td");
        tdE.colSpan = 4;
        tdE.className = "contract-table__empty";
        tdE.textContent = "등록된 성과목표가 없습니다.";
        trE.appendChild(tdE);
        tbody.appendChild(trE);
        return;
      }

      goals.forEach(function(goal) {
        var inds = goal.indicators || [];
        if (!inds.length) {
          var tr = document.createElement("tr");
          tr.className = "contract-table__row";
          var tdGoal = document.createElement("td");
          tdGoal.className = "contract-table__goal";
          tdGoal.textContent = goal.title;
          appendGoalDeleteBtn(tdGoal, goal.goalId);
          appendIndAddBtn(tdGoal, goal.goalId);
          tr.appendChild(tdGoal);
          for (var c = 0; c < 3; c++) {
            var td = document.createElement("td");
            td.textContent = "—";
            tr.appendChild(td);
          }
          tbody.appendChild(tr);
          return;
        }

        inds.forEach(function(ind, ii) {
          var tr = document.createElement("tr");
          tr.className = "contract-table__row";
          tr.style.cursor = "pointer";

          if (ii === 0) {
            var tdGoal = document.createElement("td");
            tdGoal.className = "contract-table__goal";
            if (inds.length > 1) tdGoal.rowSpan = inds.length;
            tdGoal.textContent = goal.title;
            appendGoalDeleteBtn(tdGoal, goal.goalId);
            appendIndAddBtn(tdGoal, goal.goalId);
            tr.appendChild(tdGoal);
          }

          var tdInd = document.createElement("td");
          tdInd.className = "contract-table__indicator";
          tdInd.textContent = ind.name || "";
          tr.appendChild(tdInd);

          var tdType = document.createElement("td");
          tdType.className = "contract-table__col-type contract-table__center";
          tdType.textContent = ind.quant ? "계량" : "비계량";
          tr.appendChild(tdType);

          var tdTarget = document.createElement("td");
          tdTarget.className = "contract-table__col-target contract-table__center";
          tdTarget.textContent = ind.t2 || "—";
          tr.appendChild(tdTarget);

          (function(goalId, indId, subId) {
            tr.addEventListener("click", function() {
              var url = CTX + "/contract/indicator.do?goalId=" + encodeURIComponent(goalId) +
                        "&indId=" + encodeURIComponent(indId);
              if (subId) url += "&sub=" + encodeURIComponent(subId);
              location.href = url;
            });
          })(goal.goalId, ind.indId,
             (ind.subTasks && ind.subTasks[0]) ? ind.subTasks[0].subTaskId : "");

          tbody.appendChild(tr);
        });
      });
    });
  }

  function appendGoalDeleteBtn(td, goalId) {
    var btn = document.createElement("button");
    btn.type = "button";
    btn.className = "btn lead-block__del-btn admin-only";
    btn.innerHTML = '<svg class="icon-trash" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/><path d="M9 6V4a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v2"/></svg>';
    btn.addEventListener("click", function(e) {
      e.stopPropagation();
      if (!confirm("성과목표를 삭제하시겠습니까?")) return;
      ajax("POST", CTX + "/contract/goal/delete.ajax.do", { goalId: goalId }, function(res) {
        if (res && res.result === "ok") renderContract();
        else alert("삭제 실패");
      });
    });
    td.appendChild(btn);
  }

  function appendIndAddBtn(td, goalId) {
    var btn = document.createElement("button");
    btn.type = "button";
    btn.className = "btn btn--admin-teal admin-only";
    btn.textContent = "+ 지표 추가";
    btn.style.marginLeft = "4px";
    btn.addEventListener("click", function(e) {
      e.stopPropagation();
      openIndModal(goalId);
    });
    td.appendChild(btn);
  }

  /* ── 성과목표 추가 모달 ── */
  document.getElementById("btnGoalAdd").addEventListener("click", function() {
    document.getElementById("modal-goal-input").value = "";
    modalGoal.removeAttribute("hidden");
    setTimeout(function() { document.getElementById("modal-goal-input").focus(); }, 0);
  });
  document.getElementById("modal-goal-cancel").addEventListener("click", function() {
    modalGoal.setAttribute("hidden", "");
  });
  document.getElementById("modal-goal-x").addEventListener("click", function() {
    modalGoal.setAttribute("hidden", "");
  });
  modalGoal.querySelector(".cp-modal__backdrop").addEventListener("click", function() {
    modalGoal.setAttribute("hidden", "");
  });
  document.getElementById("modal-goal-input").addEventListener("keydown", function(e) {
    if (e.key === "Enter") { e.preventDefault(); document.getElementById("modal-goal-save").click(); }
    if (e.key === "Escape") modalGoal.setAttribute("hidden", "");
  });
  document.getElementById("modal-goal-save").addEventListener("click", function() {
    var title = document.getElementById("modal-goal-input").value.trim();
    if (!title) { document.getElementById("modal-goal-input").focus(); return; }
    ajax("POST", CTX + "/contract/goal/save.ajax.do", { title: title }, function(res) {
      if (res && res.result === "ok") {
        modalGoal.setAttribute("hidden", "");
        renderContract();
      } else { alert("저장 실패"); }
    });
  });

  /* ── 성과지표 추가 모달 ── */
  document.querySelectorAll(".mi-type-btn").forEach(function(btn) {
    btn.addEventListener("click", function() {
      document.querySelectorAll(".mi-type-btn").forEach(function(b) { b.classList.remove("is-active"); });
      btn.classList.add("is-active");
      document.getElementById("mi-type").value = btn.getAttribute("data-type");
    });
  });

  function openIndModal(goalId) {
    document.getElementById("modal-ind-goalid").value = goalId;
    ["mi-name","mi-dept","mi-t1","mi-t2","mi-t3","mi-forecast"].forEach(function(id) {
      document.getElementById(id).value = "";
    });
    document.getElementById("mi-type").value = "qual";
    document.querySelectorAll(".mi-type-btn").forEach(function(b) { b.classList.remove("is-active"); });
    document.querySelector('.mi-type-btn[data-type="qual"]').classList.add("is-active");
    modalInd.removeAttribute("hidden");
    setTimeout(function() { document.getElementById("mi-name").focus(); }, 0);
  }
  document.getElementById("modal-ind-cancel").addEventListener("click", function() {
    modalInd.setAttribute("hidden", "");
  });
  document.getElementById("modal-ind-x").addEventListener("click", function() {
    modalInd.setAttribute("hidden", "");
  });
  modalInd.querySelector(".cp-modal__backdrop").addEventListener("click", function() {
    modalInd.setAttribute("hidden", "");
  });
  document.getElementById("modal-ind-save").addEventListener("click", function() {
    var name = document.getElementById("mi-name").value.trim();
    if (!name) { document.getElementById("mi-name").focus(); return; }
    var payload = {
      goalId:   document.getElementById("modal-ind-goalid").value,
      name:     name,
      quant:    document.getElementById("mi-type").value === "quant",
      dept:     document.getElementById("mi-dept").value.trim(),
      t1:       document.getElementById("mi-t1").value.trim(),
      t2:       document.getElementById("mi-t2").value.trim(),
      t3:       document.getElementById("mi-t3").value.trim(),
      forecast: document.getElementById("mi-forecast").value.trim()
    };
    ajax("POST", CTX + "/contract/indicator/save.ajax.do", payload, function(res) {
      if (res && res.result === "ok") {
        modalInd.setAttribute("hidden", "");
        renderContract();
      } else { alert("저장 실패"); }
    });
  });

  /* ── 초기 로드 ── */
  renderContract();
  </script>

<%@ include file="/WEB-INF/views/include/footer.jsp"%>
