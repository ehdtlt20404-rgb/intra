<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="대시보드"/>
<c:set var="activeMenu" value="main"/>
<%@ include file="/WEB-INF/views/include/header.jsp"%>

        <div class="page page--dashboard">
          <section class="dash-hero" aria-label="기관장 경영방침">
            <div class="dash-hero__content">
              <span class="dash-hero__tag">기관장 경영방침</span>
              <h1 class="dash-hero__title">
                미래를 여는 <em>친환경·성장 에너지</em>,<br>
                사람 중심의 <strong>신뢰·상생 에너지</strong>
              </h1>
            </div>
            <div class="dash-hero__deco" aria-hidden="true"></div>
          </section>

          <section class="dash-summary" aria-label="주요 현황">
            <a href="${pageContext.request.contextPath}/leadership/list.do" class="dash-card dash-card--leadership">
              <span class="dash-card__icon" aria-hidden="true">🎯</span>
              <div class="dash-card__body">
                <p class="dash-card__label">리더십 활동내역</p>
                <div>
                  <span class="dash-card__value" id="dash-lead-act-count">0</span>
                  <span class="dash-card__unit dash-card__unit--sep"> / </span>
                  <span class="dash-card__value dash-card__value--total" id="dash-lead-task-total">0</span>
                  <span class="dash-card__unit">건</span>
                  <span class="dash-card__hint">(중점과제수)</span>
                </div>
              </div>
              <span class="dash-card__arrow" aria-hidden="true">›</span>
            </a>
            <a href="${pageContext.request.contextPath}/contract/list.do" class="dash-card dash-card--contract">
              <span class="dash-card__icon" aria-hidden="true">📋</span>
              <div class="dash-card__body">
                <p class="dash-card__label">경영계약 활동내역</p>
                <div>
                  <span class="dash-card__value" id="dash-contract-act-count">0</span>
                  <span class="dash-card__unit dash-card__unit--sep"> / </span>
                  <span class="dash-card__value dash-card__value--total" id="dash-contract-plan-total">0</span>
                  <span class="dash-card__unit">건</span>
                  <span class="dash-card__hint">(달성계획수)</span>
                </div>
              </div>
              <span class="dash-card__arrow" aria-hidden="true">›</span>
            </a>
            <a href="${pageContext.request.contextPath}/activities/list.do" class="dash-card dash-card--activity">
              <span class="dash-card__icon" aria-hidden="true">👤</span>
              <div class="dash-card__body">
                <p class="dash-card__label">기타 주요 활동 수</p>
                <div>
                  <span class="dash-card__value" id="dash-etc-act-count">0</span>
                  <span class="dash-card__unit">건</span>
                </div>
              </div>
              <span class="dash-card__arrow" aria-hidden="true">›</span>
            </a>
          </section>

          <section class="dash-recent" aria-labelledby="recent-title">
            <div class="dash-recent__head">
              <h2 id="recent-title" class="dash-recent__title">최근 활동 내역</h2>
              <a href="${pageContext.request.contextPath}/activities/all.do" class="dash-recent__more">전체 보기 ›</a>
            </div>
            <table class="dash-recent__table">
              <colgroup>
                <col style="width:3rem"><col style="width:9.5rem"><col><col style="width:9rem">
              </colgroup>
              <thead>
                <tr>
                  <th class="dash-recent__no">No.</th>
                  <th>구분</th>
                  <th>내용</th>
                  <th class="dash-recent__date">등록일시</th>
                </tr>
              </thead>
              <tbody id="dash-recent-tbody">
                <tr><td colspan="4" style="text-align:center;">최근 활동 내역이 없습니다.</td></tr>
              </tbody>
            </table>
          </section>
        </div>

  <script>
  var CTX = "${pageContext.request.contextPath}";
  var KIND_LABEL = { leadership: "리더십", contract: "경영계약", etc: "기타 주요 활동" };

  function ajaxGet(url, cb) {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", url, true);
    xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
    xhr.onreadystatechange = function() {
      if (xhr.readyState === 4) {
        try { cb(JSON.parse(xhr.responseText), xhr.status); }
        catch(e) { cb(null, xhr.status); }
      }
    };
    xhr.send(null);
  }

  /* ── 리더십 카드: 중점과제 수 ── */
  ajaxGet(CTX + "/leadership/list.ajax.do", function(data, status) {
    if (status !== 200 || !data) return;
    var cats = data.categories || [];
    var taskTotal = 0;
    cats.forEach(function(c) { taskTotal += (c.tasks || []).length; });
    document.getElementById("dash-lead-task-total").textContent = String(taskTotal);
  });

  /* ── 경영계약 카드: 성과지표 수 ── */
  ajaxGet(CTX + "/contract/list.ajax.do", function(data, status) {
    if (status !== 200 || !data) return;
    var goals = data.goals || [];
    var indTotal = 0;
    goals.forEach(function(g) { indTotal += (g.indicators || []).length; });
    document.getElementById("dash-contract-plan-total").textContent = String(indTotal);
  });

  /* ── 활동 카드 + 최근 활동 테이블 ── */
  ajaxGet(CTX + "/activities/all.ajax.do", function(data, status) {
    if (status !== 200 || !data) return;
    var acts = data.activities || [];

    document.getElementById("dash-lead-act-count").textContent =
      String(acts.filter(function(a) { return a.category === "leadership"; }).length);
    document.getElementById("dash-contract-act-count").textContent =
      String(acts.filter(function(a) { return a.category === "contract"; }).length);
    document.getElementById("dash-etc-act-count").textContent =
      String(acts.filter(function(a) { return a.category === "etc"; }).length);

    var recent = acts.slice()
      .sort(function(a, b) { return (b.actDate || "").localeCompare(a.actDate || ""); })
      .slice(0, 5);

    var tbody = document.getElementById("dash-recent-tbody");
    tbody.innerHTML = "";

    if (!recent.length) {
      var tr = document.createElement("tr");
      var td = document.createElement("td");
      td.colSpan = 4; td.style.textAlign = "center";
      td.textContent = "최근 활동 내역이 없습니다.";
      tr.appendChild(td); tbody.appendChild(tr);
      return;
    }

    recent.forEach(function(a, i) {
      var tr = document.createElement("tr");
      tr.style.cursor = "pointer";
      tr.addEventListener("click", function() {
        location.href = CTX + "/activities/edit.do?actId=" + encodeURIComponent(a.actId);
      });
      function mkTd(t, cls) {
        var c = document.createElement("td");
        if (cls) c.className = cls;
        c.textContent = t || "—";
        return c;
      }
      tr.appendChild(mkTd(String(i + 1), "dash-recent__no"));
      var kindTd = document.createElement("td");
      var tag = document.createElement("span");
      tag.className = "dash-recent__tag dash-recent__tag--" + (a.category || "");
      tag.textContent = KIND_LABEL[a.category] || a.category || "—";
      kindTd.appendChild(tag); tr.appendChild(kindTd);
      tr.appendChild(mkTd(a.title || ""));
      tr.appendChild(mkTd(a.actDate || "", "dash-recent__date"));
      tbody.appendChild(tr);
    });
  });
  </script>

<%@ include file="/WEB-INF/views/include/footer.jsp"%>
