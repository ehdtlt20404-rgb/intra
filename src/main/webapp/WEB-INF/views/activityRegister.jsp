<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="활동 등록"/>
<c:set var="activeMenu" value="activities"/>
<%@ include file="/WEB-INF/views/include/header.jsp"%>

        <div class="page page--activity-form">
          <section class="act-reg__form" aria-labelledby="act-reg-form-title">
            <h3 id="act-reg-form-title" class="visually-hidden">활동 실적 작성</h3>
            <input type="hidden" id="hdActId"  value="${param.actId}">
            <input type="hidden" id="hdCatId"  value="${param.catId}">
            <input type="hidden" id="hdTaskId" value="${param.taskId}">

            <div class="act-reg__field">
              <label for="act-reg-title" class="act-reg__label">활동내용명 <span class="act-reg__req">*</span></label>
              <input type="text" id="act-reg-title" class="lead-modal__input" placeholder="예) '26.4.15 태안 풍력단지 현장방문">
            </div>
            <div class="act-reg__field">
              <label for="act-reg-indicator-select" class="act-reg__label">연관 지표 <span class="act-reg__req">*</span></label>
              <p class="act-reg__indicator-hint">목록에서 항목을 고르면 아래에 추가됩니다.</p>
              <select id="act-reg-indicator-select" class="lead-modal__input act-reg__select" onchange="addIndicator(this)">
                <option value="">— 선택하여 추가 —</option>
                <optgroup label="리더십 범주" id="act-reg-optgroup-leadership"></optgroup>
                <optgroup label="경영계약 이행성과" id="act-reg-optgroup-contract"></optgroup>
              </select>
              <div id="act-reg-indicator" class="act-reg__indicator-tags"></div>
              <input type="hidden" id="hdIndicators" value="">
            </div>
            <div class="act-reg__grid2">
              <div class="act-reg__field">
                <label for="act-reg-recognition" class="act-reg__label">① 인식 <span class="act-reg__req">*</span></label>
                <textarea id="act-reg-recognition" class="lead-modal__input lead-modal__input--textarea" rows="3"></textarea>
              </div>
              <div class="act-reg__field">
                <label for="act-reg-direction" class="act-reg__label">② 방향 <span class="act-reg__req">*</span></label>
                <textarea id="act-reg-direction" class="lead-modal__input lead-modal__input--textarea" rows="3"></textarea>
              </div>
            </div>
            <div class="act-reg__field">
              <label class="act-reg__label">③ 활동유형</label>
              <div class="lead-act-modal__type-grid" id="act-reg-type-grid"></div>
              <input type="hidden" id="hdTypePrimary" value="">
              <input type="hidden" id="hdTypeSecondary" value="">
            </div>
            <div class="act-reg__field">
              <label for="act-reg-content" class="act-reg__label">④ 세부 활동실적</label>
              <textarea id="act-reg-content" class="lead-modal__input lead-modal__input--textarea" rows="4"></textarea>
            </div>
            <div class="act-reg__grid2">
              <div class="act-reg__field">
                <label for="act-reg-date" class="act-reg__label">활동 일자 <span class="act-reg__req">*</span></label>
                <input type="date" id="act-reg-date" class="lead-modal__input">
              </div>
              <div class="act-reg__field">
                <label for="act-reg-proof-text" class="act-reg__label">증빙자료</label>
                <input type="text" id="act-reg-proof-text" class="lead-modal__input" placeholder="첨부 파일명 또는 설명">
              </div>
            </div>
            <div class="act-reg__actions">
              <span class="act-reg__saved" id="act-reg-saved"></span>
              <button type="button" class="btn btn--danger"     id="btn-act-delete" style="display:none;" onclick="deleteActivity()">삭제</button>
              <button type="button" class="btn btn--secondary"  onclick="location.href='${pageContext.request.contextPath}/activities/list.do'">취소</button>
              <button type="button" class="btn btn--secondary"  onclick="saveActivity(true)">임시저장</button>
              <button type="button" class="btn btn--primary"    onclick="saveActivity(false)">등록</button>
            </div>
          </section>
        </div>

  <script>
  var CTX = "${pageContext.request.contextPath}";
  var actId = document.getElementById("hdActId").value;
  var selectedIndicators = [];

  var ACT_TYPES = [
    { value: "direction",     label: "방향제시" },
    { value: "resource",      label: "자원배분" },
    { value: "communication", label: "소통협력" },
    { value: "execution",     label: "실행강화" },
    { value: "problem",       label: "문제해결" }
  ];

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

  /* ── 활동유형 그리드 ── */
  function selectType(value) {
    document.getElementById("hdTypePrimary").value = value;
    var btns = document.querySelectorAll("#act-reg-type-grid .mi-type-btn");
    for (var i = 0; i < btns.length; i++) {
      btns[i].className = "mi-type-btn" + (btns[i].getAttribute("data-value") === value ? " is-active" : "");
    }
  }

  function buildTypeGrid() {
    var grid = document.getElementById("act-reg-type-grid");
    grid.innerHTML = "";
    for (var i = 0; i < ACT_TYPES.length; i++) {
      var t = ACT_TYPES[i];
      grid.innerHTML += '<button type="button" class="mi-type-btn" data-value="' + t.value
        + '" onclick="selectType(\'' + t.value + '\')">' + t.label + '</button>';
    }
  }

  /* ── 연관지표 옵션 로드 ── */
  function loadIndicatorOptions() {
    ajax("GET", CTX + "/activities/indicator-options.ajax.do", null, function(data, status) {
      if (status !== 200 || !data) return;
      var grpLead = document.getElementById("act-reg-optgroup-leadership");
      var grpCont = document.getElementById("act-reg-optgroup-contract");
      grpLead.innerHTML = ""; grpCont.innerHTML = "";
      var lead = data.leadership || [], cont = data.contract || [];
      for (var i = 0; i < lead.length; i++) {
        grpLead.innerHTML += '<option value="' + (lead[i].id || lead[i].catId || "") + '">'
          + (lead[i].name || lead[i].title || "") + '</option>';
      }
      for (var j = 0; j < cont.length; j++) {
        grpCont.innerHTML += '<option value="' + (cont[j].id || cont[j].indId || "") + '">'
          + (cont[j].name || cont[j].title || "") + '</option>';
      }
    });
  }

  /* ── 연관지표 태그 ── */
  function addIndicator(sel) {
    var val = sel.value;
    var lbl = sel.options[sel.selectedIndex] ? sel.options[sel.selectedIndex].textContent : "";
    if (!val) return;
    for (var i = 0; i < selectedIndicators.length; i++) {
      if (selectedIndicators[i].id === val) { sel.value = ""; return; }
    }
    selectedIndicators.push({ id: val, label: lbl });
    document.getElementById("hdIndicators").value = selectedIndicators.map(function(x) { return x.id; }).join(",");
    renderIndicatorTags();
    sel.value = "";
  }

  function removeIndicator(id) {
    selectedIndicators = selectedIndicators.filter(function(x) { return x.id !== id; });
    document.getElementById("hdIndicators").value = selectedIndicators.map(function(x) { return x.id; }).join(",");
    renderIndicatorTags();
  }

  function renderIndicatorTags() {
    var html = "";
    for (var i = 0; i < selectedIndicators.length; i++) {
      var ind = selectedIndicators[i];
      html += '<span class="act-reg__ind-tag">' + ind.label
        + '<button type="button" class="act-reg__ind-tag-x" onclick="removeIndicator(\'' + ind.id + '\')">×</button>'
        + '</span>';
    }
    document.getElementById("act-reg-indicator").innerHTML = html;
  }

  /* ── 기존 데이터 로드 (수정 모드) ── */
  function loadActivityDetail() {
    if (!actId) return;
    ajax("GET", CTX + "/activities/detail.ajax.do?actId=" + encodeURIComponent(actId), null, function(data, status) {
      if (status !== 200 || !data || !data.activity) return;
      var a = data.activity;
      document.getElementById("act-reg-title").value       = a.title       || "";
      document.getElementById("act-reg-recognition").value = a.recognition || "";
      document.getElementById("act-reg-direction").value   = a.direction   || "";
      document.getElementById("act-reg-content").value     = a.content     || "";
      document.getElementById("act-reg-date").value        = a.actDate     || "";
      document.getElementById("act-reg-proof-text").value  = a.proof       || "";
      if (a.typePrimary) selectType(a.typePrimary);
      if (a.typeSecondary) {
        document.getElementById("hdTypeSecondary").value = Array.isArray(a.typeSecondary)
          ? a.typeSecondary.join(",") : a.typeSecondary;
      }
      if (a.indicators && a.indicators.length) {
        selectedIndicators = a.indicators;
        document.getElementById("hdIndicators").value = selectedIndicators.map(function(x) { return x.id; }).join(",");
        renderIndicatorTags();
      }
      document.getElementById("btn-act-delete").style.display = "";
    });
  }

  /* ── 저장 ── */
  function saveActivity(isDraft) {
    var title = document.getElementById("act-reg-title").value.trim();
    if (!title && !isDraft) { document.getElementById("act-reg-title").focus(); alert("활동내용명을 입력하세요."); return; }
    var payload = {
      actId:         document.getElementById("hdActId").value,
      catId:         document.getElementById("hdCatId").value,
      taskId:        document.getElementById("hdTaskId").value,
      title:         title,
      recognition:   document.getElementById("act-reg-recognition").value,
      direction:     document.getElementById("act-reg-direction").value,
      typePrimary:   document.getElementById("hdTypePrimary").value,
      typeSecondary: (document.getElementById("hdTypeSecondary").value || "").split(",").filter(Boolean),
      content:       document.getElementById("act-reg-content").value,
      actDate:       document.getElementById("act-reg-date").value.trim(),
      proof:         document.getElementById("act-reg-proof-text").value.trim(),
      indicators:    selectedIndicators,
      isDraft:       isDraft
    };
    var url = payload.actId ? CTX + "/activities/update.ajax.do" : CTX + "/activities/save.ajax.do";
    ajax("POST", url, payload, function(res) {
      if (res && res.result === "ok") {
        if (isDraft) {
          var saved = document.getElementById("act-reg-saved");
          saved.textContent = "임시저장되었습니다.";
          setTimeout(function() { saved.textContent = ""; }, 3000);
        } else {
          location.href = CTX + "/activities/list.do";
        }
      } else { alert("저장 실패"); }
    });
  }

  /* ── 삭제 ── */
  function deleteActivity() {
    if (!actId || !confirm("활동실적을 삭제하시겠습니까?")) return;
    ajax("POST", CTX + "/activities/delete.ajax.do", { actId: actId }, function(res) {
      if (res && res.result === "ok") location.href = CTX + "/activities/list.do";
      else alert("삭제 실패");
    });
  }

  buildTypeGrid();
  loadIndicatorOptions();
  loadActivityDetail();
  </script>

<%@ include file="/WEB-INF/views/include/footer.jsp"%>
